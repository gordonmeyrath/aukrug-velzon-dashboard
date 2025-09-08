<?php
use PHPUnit\Framework\TestCase;

final class SyncFormatTest extends TestCase
{
    public function testHealthForFcmIncomplete(): void
    {
        $h = \Aukrug\Connect\Settings::computeHealth([
            'au_push_provider' => 'fcm',
            'au_fcm_server_key' => '',
        ]);
        $this->assertIsArray($h);
    }
}
