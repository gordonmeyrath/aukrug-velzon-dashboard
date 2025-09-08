<?php
require_once __DIR__ . '/../bootstrap.php';

// Local fallback TestCase to satisfy static analysis when PHPUnit isn't available
if (!class_exists('PHPUnit\\Framework\\TestCase')) {
    class TestCase {
        protected function assertIsArray($v): void { if (!is_array($v)) { throw new Exception('Expected array'); } }
        protected function assertArrayHasKey($k, $arr): void { if (!is_array($arr) || !array_key_exists($k, $arr)) { throw new Exception('Key missing'); } }
        protected function assertFalse($v): void { if ($v !== false) { throw new Exception('Expected false'); } }
        protected function assertSame($a, $b): void { if ($a !== $b) { throw new Exception('Not identical'); } }
    }
} else {
    // If PHPUnit exists, alias its TestCase to our local name to keep the 'extends' working
    class_alias('PHPUnit\\Framework\\TestCase', 'TestCase');
}

final class PushProviderTest extends TestCase
{
    public function testSendDefaultsToFcmAndFailsWithoutConfig(): void
    {
        $push = new \Aukrug\Connect\Notify\Push();
        $res = $push->send(['dummyToken'], ['title' => 'Hi', 'body' => 'There'], ['k' => 'v']);
        $this->assertIsArray($res);
        $this->assertArrayHasKey('ok', $res);
        $this->assertFalse($res['ok']);
        $this->assertArrayHasKey('reason', $res);
        // In a non-WordPress test environment, wp_remote_post does not exist
        // -> FCM not configured
        $this->assertSame('fcm_not_configured', $res['reason']);
    }

    public function testApnsReturnsNotConfiguredWhenMissingSettings(): void
    {
        $push = new \Aukrug\Connect\Notify\Push();
        // Force provider via reflection hack: call APNs class directly
        $apns = new \Aukrug\Connect\Notify\PushAPNs();
        $res = $apns->send(['token'], ['title' => 'x'], []);
        $this->assertIsArray($res);
        $this->assertFalse($res['ok']);
        $this->assertSame('apns_not_configured', $res['reason']);
    }
}
