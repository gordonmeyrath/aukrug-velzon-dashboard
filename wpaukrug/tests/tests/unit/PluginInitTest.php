<?php
declare(strict_types=1);

use PHPUnit\Framework\TestCase;

final class PluginInitTest extends TestCase
{
    public function test_plugin_class_exists(): void
    {
        require_once __DIR__ . '/../../au_aukrug_connect.php';
        $this->assertTrue(class_exists(\Aukrug\Connect\Plugin::class));
    }
}
