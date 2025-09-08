<?php

// Minimal WP stubs
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
if (!function_exists('get_the_title')) { function get_the_title($id) { return 'Title #' . (int) $id; } }
if (!function_exists('get_post_modified_time')) {
    function get_post_modified_time($format, $gmt, $id) {
        if ((int)$id === 1) return '2025-01-01T00:00:00+00:00';
        if ((int)$id === 2) return '2025-01-02T00:00:00+00:00';
        return '2025-01-03T00:00:00+00:00';
    }
}
if (!function_exists('get_post_meta')) { function get_post_meta($id) { return []; } }

// Local base mapping
if (class_exists('PHPUnit\\Framework\\TestCase')) {
    if (!class_exists('Au_Base_TestCase', false)) { class_alias('PHPUnit\\Framework\\TestCase', 'Au_Base_TestCase'); }
} else {
    class Au_Base_TestCase {
    protected function assertIsArray($v): void { if (!is_array($v)) { throw new \Exception('Expected array'); } }
    protected function assertSame($a, $b): void { if ($a !== $b) { throw new \Exception('Not identical'); } }
    }
}

final class CollectionsHeadersTest extends Au_Base_TestCase
{
    private function getRouteCallback(string $method, string $path): callable
    {
        foreach (($GLOBALS['__au_routes'] ?? []) as $r) {
            if ($r['route'] === $path) {
                $m = is_array($r['args']['methods'] ?? null) ? array_map('strtoupper', $r['args']['methods']) : [strtoupper((string)($r['args']['methods'] ?? ''))];
                if (in_array(strtoupper($method), $m, true)) { return $r['args']['callback']; }
            }
        }
    throw new \Exception('Route not registered: ' . $method . ' ' . $path);
    }

    public function testCollectionReturns304WithIfModifiedSince(): void
    {
        $GLOBALS['__au_routes'] = [];
    $rest = new \Aukrug\Connect\Rest();
        $rest->registerRoutes();
        $cb = $this->getRouteCallback('GET', '/collection/(?P<type>[a-z\-]+)');
        // Build a request-like object for type=places
        $req = new class {
            public function get_param($k) {
                $map = [ 'type' => 'places', 'search' => null, 'page' => 1, 'per_page' => 20 ];
                return $map[$k] ?? null;
            }
        };
        // First call populates headers; we only need to set IMS equal to max modified
        $first = $cb($req);
        $this->assertIsArray($first);
        $_SERVER['HTTP_IF_MODIFIED_SINCE'] = gmdate('D, d M Y H:i:s', strtotime('2025-01-02T00:00:00Z')) . ' GMT';
        $second = $cb($req);
        $this->assertSame(null, $second);
        unset($_SERVER['HTTP_IF_MODIFIED_SINCE']);
    }
}
