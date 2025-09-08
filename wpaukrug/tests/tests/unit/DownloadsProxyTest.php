<?php
declare(strict_types=1);

require_once __DIR__ . '/../bootstrap.php';

// Local base that maps to PHPUnit TestCase when available without direct reference
if (class_exists('PHPUnit\\Framework\\TestCase')) {
    class_alias('PHPUnit\\Framework\\TestCase', 'Au_Base_TestCase_Dl');
} else {
    class Au_Base_TestCase_Dl {
        protected function assertIsArray($v): void { if (!is_array($v)) { throw new Exception('Expected array'); } }
        protected function assertSame($a, $b): void { if ($a !== $b) { throw new Exception('Not identical'); } }
        protected function markTestSkipped(string $msg = ''): void { /* no-op */ }
    }
}

final class DownloadsProxyTest extends Au_Base_TestCase_Dl
{
    public function test_bad_request_when_id_missing(): void
    {
        $d = new \Aukrug\Connect\Downloads();
        $res = $d->buildDownloadProxyResponse(0);
        $this->assertIsArray($res);
        $this->assertSame(400, $res['status']);
    }

    public function test_not_found_when_wrong_type_without_wp(): void
    {
        if (function_exists('get_post_type')) {
            $this->markTestSkipped('WordPress functions present; this test targets non-WP context.');
        }
        $d = new \Aukrug\Connect\Downloads();
        $res = $d->buildDownloadProxyResponse(123);
        $this->assertIsArray($res);
        // In non-WP context, get_post_type returns ''. That triggers not_found.
        $this->assertSame(404, $res['status']);
    }
}
