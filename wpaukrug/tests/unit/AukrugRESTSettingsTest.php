<?php
use PHPUnit\Framework\TestCase;
use Brain\Monkey;
use Brain\Monkey\Functions;

class AukrugRESTSettingsTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        Monkey\setUp();
        Functions\when('current_user_can')->justReturn(true);
        Functions\when('get_option')->alias(function($key, $default = []) {
            if ($key === 'aukrug_plugin_settings') {
                return [
                    'site_title' => 'Test Aukrug',
                    'contact_email' => 'test@aukrug.de',
                    'map_provider' => 'osm',
                ];
            }
            return $default;
        });
        Functions\when('update_option')->alias(function($key, $value) {
            return true;
        });
        Functions\when('rest_ensure_response')->alias(function($data) {
            return $data;
        });
    }

    protected function tearDown(): void
    {
        Monkey\tearDown();
        parent::tearDown();
    }

    public function test_get_settings_returns_options()
    {
        $rest = new AukrugREST();
        $request = $this->getMockBuilder('WP_REST_Request')->disableOriginalConstructor()->getMock();
        $result = $rest->getSettings($request);
        $this->assertIsArray($result);
        $this->assertEquals('Test Aukrug', $result['site_title']);
        $this->assertEquals('test@aukrug.de', $result['contact_email']);
        $this->assertEquals('osm', $result['map_provider']);
    }

    public function test_save_settings_updates_options()
    {
        $rest = new AukrugREST();
        $request = $this->getMockBuilder('WP_REST_Request')->disableOriginalConstructor()->getMock();
        $request->method('get_param')->willReturn([
            'site_title' => 'Neu',
            'contact_email' => 'neu@aukrug.de',
            'map_provider' => 'google',
        ]);
        $result = $rest->saveSettings($request);
        $this->assertIsArray($result);
        $this->assertTrue($result['success']);
        $this->assertEquals('Neu', $result['settings']['site_title']);
        $this->assertEquals('neu@aukrug.de', $result['settings']['contact_email']);
        $this->assertEquals('google', $result['settings']['map_provider']);
    }

    public function test_save_settings_invalid_data_returns_error()
    {
        $rest = new AukrugREST();
        $request = $this->getMockBuilder('WP_REST_Request')->disableOriginalConstructor()->getMock();
        $request->method('get_param')->willReturn('not-an-array');
        $result = $rest->saveSettings($request);
        $this->assertInstanceOf('WP_Error', $result);
    }
}
