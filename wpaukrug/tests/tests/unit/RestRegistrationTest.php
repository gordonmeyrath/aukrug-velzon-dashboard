<?php
use PHPUnit\Framework\TestCase;

final class RestRegistrationTest extends TestCase
{
    public function testComputeHealthShape(): void
    {
        $opts = [
            'au_push_provider' => 'webpush',
            'au_vapid_public' => '',
            'au_vapid_private' => '',
            'au_vapid_subject' => '',
        ];
        $health = \Aukrug\Connect\Settings::computeHealth($opts);
        $this->assertIsArray($health);
        $this->assertArrayHasKey('provider', $health);
    }
}
