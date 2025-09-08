<?php
declare(strict_types=1);

namespace {
    // Provide minimal stubs for get_option to simulate configured VAPID keys in non-WP tests
    if (!function_exists('get_option')) {
        function get_option($k, $d = '') {
            $map = [
                'au_vapid_public' => 'BElB8K2p1VZVQ0b1b2zJ7lU1e9P0Q7G5h8I3K2L1M0N9O8P7Q6R5S4T3U2V1W0X9',
                'au_vapid_private' => 'm1n2o3p4q5r6s7t8u9v0w1x2y3z4A5B6',
                'au_vapid_subject' => 'mailto:test@example.com',
            ];
            return $map[$k] ?? $d;
        }
    }
}

// Minimal Minishlink\WebPush stubs to simulate success path
namespace Minishlink\WebPush {
    class Subscription {
        public static function create(array $arr) { return new self(); }
    }
    class Report { public function isSuccess() { return true; } }
    class WebPush {
        public function __construct($auth) {}
        public function sendOneNotification($subscription, $payload) { return new Report(); }
    }
}

namespace {
    // Local base that maps to PHPUnit TestCase when available without directly referencing its symbol.
    if (class_exists('PHPUnit\\Framework\\TestCase')) {
        if (!class_exists('Au_Base_TestCase', false)) { \class_alias('PHPUnit\\Framework\\TestCase', 'Au_Base_TestCase'); }
    } else {
        class Au_Base_TestCase {
            protected function assertIsArray($v): void { if (!is_array($v)) { throw new \Exception('Expected array'); } }
            protected function assertArrayHasKey($k, $arr): void { if (!is_array($arr) || !array_key_exists($k, $arr)) { throw new \Exception('Key missing'); } }
            protected function assertSame($a, $b): void { if ($a !== $b) { throw new \Exception('Not identical'); } }
        }
    }

    final class PushWebPushMinishlinkTest extends Au_Base_TestCase {
        public function test_send_with_minishlink_succeeds(): void {
            $sender = new \Aukrug\Connect\Notify\PushWebPush();
            $tokens = [[ 'endpoint' => 'https://push.example/abc', 'p256dh' => 'key', 'auth' => 'tok' ]];
            $res = $sender->send($tokens, ['title' => 'Hi'], ['k' => 'v']);
            $this->assertIsArray($res);
            $this->assertArrayHasKey('ok', $res);
            $this->assertArrayHasKey('sent', $res);
            $this->assertSame(true, (bool)$res['ok']);
            $this->assertSame(1, (int)$res['sent']);
        }
    }
}
