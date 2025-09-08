<?php
declare(strict_types=1);

use Aukrug\Connect\Notify\PushWebPush;

// Local base that maps to PHPUnit TestCase when available without directly referencing its symbol.
if (class_exists('PHPUnit\\Framework\\TestCase')) {
    if (!class_exists('Au_Base_TestCase', false)) { \class_alias('PHPUnit\\Framework\\TestCase', 'Au_Base_TestCase'); }
} else {
    class Au_Base_TestCase {
        protected function assertIsArray($v): void { if (!is_array($v)) { throw new \Exception('Expected array'); } }
        protected function assertArrayHasKey($k, $arr): void { if (!is_array($arr) || !array_key_exists($k, $arr)) { throw new \Exception('Key missing'); } }
        protected function assertFalse($v): void { if ($v !== false) { throw new \Exception('Expected false'); } }
        protected function assertSame($a, $b): void { if ($a !== $b) { throw new \Exception('Not identical'); } }
        protected function markTestSkipped(string $msg = ''): void { /* no-op */ }
    }
}

final class PushWebPushTest extends Au_Base_TestCase
{
    public function test_returns_not_configured_when_no_vapid_keys(): void
    {
        // In non-WordPress context, get_option is not defined; sender should report not configured.
        if (function_exists('get_option')) {
            $this->markTestSkipped('get_option exists, cannot simulate missing WordPress options.');
        }
        $sender = new PushWebPush();
        $tokens = [[
            'endpoint' => 'https://example.com/endpoint',
            'p256dh' => 'dummy',
            'auth' => 'dummy',
        ]];
        $res = $sender->send($tokens, ['title' => 'Hi'], []);
        $this->assertIsArray($res);
        $this->assertArrayHasKey('ok', $res);
        $this->assertArrayHasKey('sent', $res);
        $this->assertArrayHasKey('reason', $res);
        $this->assertFalse($res['ok']);
        $this->assertSame(0, $res['sent']);
        $this->assertSame('vapid_not_configured', $res['reason']);
    }
}
