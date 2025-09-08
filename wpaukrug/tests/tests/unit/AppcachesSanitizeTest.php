<?php
declare(strict_types=1);

require_once __DIR__ . '/../bootstrap.php';

if (class_exists('PHPUnit\Framework\TestCase')) {
    class_alias('PHPUnit\\Framework\\TestCase', 'Au_Base_TestCase_Appc');
} else {
    class Au_Base_TestCase_Appc {
        protected function assertSame($a, $b): void { if ($a !== $b) { throw new Exception('Not identical'); } }
        protected function assertIsArray($v): void { if (!is_array($v)) { throw new Exception('Expected array'); } }
        protected function assertContains($needle, $arr): void { if (!is_array($arr) || !in_array($needle, $arr, true)) { throw new Exception('Missing'); } }
    }
}

final class AppcachesSanitizeTest extends Au_Base_TestCase_Appc
{
    public function test_title_required(): void
    {
        $r = \Aukrug\Connect\Appcaches::sanitizePayload(['title' => '   ']);
        $this->assertIsArray($r);
        $this->assertContains('title_required', $r['errors']);
    }

    public function test_coords_clamped_and_status_normalized(): void
    {
        $r = \Aukrug\Connect\Appcaches::sanitizePayload([
            'title' => 'X',
            'coords_lat' => 95,
            'coords_lng' => -200,
            'status' => 'weird',
            'audience' => 'tourist'
        ]);
        $this->assertContains('coords_lat_invalid', $r['errors']);
        $this->assertContains('coords_lng_invalid', $r['errors']);
        $this->assertSame('publish', $r['status']);
        $this->assertSame(['tourist'], $r['audience']);
    }
}
