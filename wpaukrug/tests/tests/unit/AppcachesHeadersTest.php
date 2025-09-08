<?php

// Minimal WP stubs for testing route registration and queries
if (!function_exists('register_rest_route')) {
    function register_rest_route($ns, $route, $args) {
        $GLOBALS['__au_routes'][] = [ 'ns' => $ns, 'route' => $route, 'args' => $args ];
        return true;
    }
}
if (!class_exists('WP_Query')) {
    class WP_Query {
        public array $posts = [];
        public int $found_posts = 0;
        public function __construct($args = []) {
            // Produce two fake posts
            $this->posts = [ (object) ['ID' => 1, 'post_title' => 'A', 'post_modified_gmt' => '2025-01-01 00:00:00'], (object) ['ID' => 2, 'post_title' => 'B', 'post_modified_gmt' => '2025-01-02 00:00:00'] ];
            $this->found_posts = count($this->posts);
        }
    }
}
if (!function_exists('get_the_title')) {
    function get_the_title($id) { return 'Title #' . (int) $id; }
}
if (!function_exists('get_post_modified_time')) {
    function get_post_modified_time($format, $gmt, $id) {
        // Return ISO8601 for given ID
        if ((int)$id === 1) return '2025-01-01T00:00:00+00:00';
        if ((int)$id === 2) return '2025-01-02T00:00:00+00:00';
        return '2025-01-03T00:00:00+00:00';
    }
}
if (!function_exists('get_post_meta')) {
    function get_post_meta($id) { return []; }
}

// Local base that maps to PHPUnit TestCase when available without directly referencing its symbol.
if (class_exists('PHPUnit\\Framework\\TestCase')) {
    if (!class_exists('Au_Base_TestCase', false)) { class_alias('PHPUnit\\Framework\\TestCase', 'Au_Base_TestCase'); }
} else {
    class Au_Base_TestCase {
        protected function assertIsArray($v): void { if (!is_array($v)) { throw new \Exception('Expected array'); } }
        protected function assertArrayHasKey($k, $arr): void { if (!is_array($arr) || !array_key_exists($k, $arr)) { throw new \Exception('Key missing'); } }
        protected function assertFalse($v): void { if ($v !== false) { throw new \Exception('Expected false'); } }
        protected function assertSame($a, $b): void { if ($a !== $b) { throw new \Exception('Not identical'); } }
        protected function markTestSkipped(string $msg = ''): void { /* no-op */ }
    }
}

final class AppcachesHeadersTest extends Au_Base_TestCase
{
    private function getRouteCallback(string $method, string $path): callable
    {
        $routes = $GLOBALS['__au_routes'] ?? [];
        foreach ($routes as $r) {
            if ($r['route'] === $path) {
                // Methods can be a string or array; normalize to upper
                $m = is_array($r['args']['methods'] ?? null) ? array_map('strtoupper', $r['args']['methods']) : [strtoupper((string)($r['args']['methods'] ?? ''))];
                if (in_array(strtoupper($method), $m, true)) {
                    return $r['args']['callback'];
                }
            }
        }
    throw new \Exception('Route not registered: ' . $method . ' ' . $path);
    }

    public function testAppcachesReturns304WithMatchingEtag(): void
    {
        // Register routes
        $GLOBALS['__au_routes'] = [];
        $app = new \Aukrug\Connect\Appcaches();
        $app->registerRoutes();
        $cb = $this->getRouteCallback('GET', '/appcaches');

    // First call to get items and compute the expected ETag exactly as implementation would
    $req = new class {
            public function get_param($k) {
                $params = ['search' => null, 'page' => 1, 'per_page' => 20];
                return $params[$k] ?? null;
            }
        };
    $first = $cb($req);
    $this->assertIsArray($first);
    $items = $first['items'] ?? [];
    $page = $first['page'] ?? 1; $pp = $first['per_page'] ?? 20;
    $updated = array_map(fn($i) => $i['updated_at'] ?? '', $items);
    $etag = 'W/"' . md5('appcaches|' . $page . '|' . $pp . '|' . serialize($updated)) . '"';

    $_SERVER['HTTP_IF_NONE_MATCH'] = $etag;
    $second = $cb($req);
    $this->assertSame(null, $second);
        unset($_SERVER['HTTP_IF_NONE_MATCH']);
    }

    public function testAppcachesReturns304WithIfModifiedSince(): void
    {
        // Register routes
        $GLOBALS['__au_routes'] = [];
        $app = new \Aukrug\Connect\Appcaches();
        $app->registerRoutes();
        $cb = $this->getRouteCallback('GET', '/appcaches');

        // First call to determine max modified (from our stubs it's 2025-01-02)
        $req = new class {
            public function get_param($k) {
                $params = ['search' => null, 'page' => 1, 'per_page' => 20];
                return $params[$k] ?? null;
            }
        };
        $first = $cb($req);
        $this->assertIsArray($first);
        // Build If-Modified-Since header equal to max modified
        $ims = gmdate('D, d M Y H:i:s', strtotime('2025-01-02T00:00:00Z')) . ' GMT';
        $_SERVER['HTTP_IF_MODIFIED_SINCE'] = $ims;
        $second = $cb($req);
        $this->assertSame(null, $second);
        unset($_SERVER['HTTP_IF_MODIFIED_SINCE']);
    }

    public function testDeleteRouteIsRegistered(): void
    {
        $GLOBALS['__au_routes'] = [];
        $app = new \Aukrug\Connect\Appcaches();
        $app->registerRoutes();
        $found = false;
        foreach ($GLOBALS['__au_routes'] as $r) {
            if ($r['route'] === '/appcaches' && strtoupper((string)$r['args']['methods']) === 'DELETE') {
                $this->assertIsArray($r['args']['args']);
                $this->assertArrayHasKey('id', $r['args']['args']);
                $found = true;
            }
        }
        $this->assertSame(true, $found);
    }
}
