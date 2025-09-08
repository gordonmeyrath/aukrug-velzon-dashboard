<?php
/**
 * Comprehensive Test Suite for Aukrug Plugin
 * Tests all REST endpoints and functionality
 */

use PHPUnit\Framework\TestCase;
use Brain\Monkey;
use Brain\Monkey\Functions;
use Brain\Monkey\Actions;
use Brain\Monkey\Filters;

class AukrugCompleteTest extends TestCase {

    protected function setUp(): void {
        parent::setUp();
        Monkey\setUp();
        
        // Load mock classes
        require_once __DIR__ . '/../mocks/wpdb.php';
        
        // Mock WordPress functions
        Functions\when('current_user_can')->justReturn(true);
        Functions\when('rest_ensure_response')->returnArg();
        Functions\when('wp_verify_nonce')->justReturn(true);
        Functions\when('sanitize_text_field')->returnArg();
        Functions\when('sanitize_textarea_field')->returnArg();
        Functions\when('esc_attr')->returnArg();
        Functions\when('esc_url_raw')->returnArg();
        Functions\when('wp_create_nonce')->justReturn('test-nonce');
        Functions\when('rest_url')->justReturn('http://example.com/wp-json/');
        Functions\when('get_option')->justReturn('test-value');
        Functions\when('update_option')->justReturn(true);
        Functions\when('current_time')->justReturn(date('Y-m-d H:i:s'));
        Functions\when('get_posts')->justReturn(array());
        Functions\when('wp_trim_words')->returnArg();
        Functions\when('get_the_author_meta')->justReturn('Test Author');
        Functions\when('get_post_meta')->justReturn('test-meta');
        Functions\when('wp_insert_post')->justReturn(123);
        Functions\when('get_post')->justReturn((object) array(
            'ID' => 123,
            'post_title' => 'Test Post',
            'post_content' => 'Test Content',
            'post_type' => 'test',
            'post_status' => 'publish',
            'post_date' => date('Y-m-d H:i:s'),
            'post_author' => 1
        ));
        Functions\when('wp_update_post')->justReturn(123);
        
        // Mock global $wpdb
        global $wpdb;
        $wpdb = new wpdb();
    }

    protected function tearDown(): void {
        Monkey\tearDown();
        parent::tearDown();
    }

    public function test_health_endpoint() {
        require_once __DIR__ . '/../includes/class-aukrug-health.php';
        
        $health = new Aukrug_Health();
        $response = $health->health_check();
        
        $this->assertIsArray($response);
        $this->assertArrayHasKey('status', $response);
        $this->assertArrayHasKey('timestamp', $response);
        $this->assertArrayHasKey('plugin_version', $response);
    }

    public function test_admin_counts_endpoint() {
        require_once __DIR__ . '/../includes/class-aukrug-health.php';
        
        $health = new Aukrug_Health();
        $response = $health->admin_counts();
        
        $this->assertIsArray($response);
        $this->assertArrayHasKey('total_posts', $response);
        $this->assertArrayHasKey('total_users', $response);
    }

    public function test_rest_complete_kpis() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        
        $response = $rest->get_kpis($request);
        
        $this->assertIsArray($response);
        $this->assertArrayHasKey('total_members', $response);
        $this->assertArrayHasKey('active_caches', $response);
    }

    public function test_rest_complete_community_members() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        
        $response = $rest->get_community_members($request);
        
        $this->assertIsArray($response);
    }

    public function test_rest_complete_geocaching_caches() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        
        $response = $rest->get_geocaching_caches($request);
        
        $this->assertIsArray($response);
    }

    public function test_rest_complete_app_caches() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        
        $response = $rest->get_app_caches($request);
        
        $this->assertIsArray($response);
    }

    public function test_rest_complete_reports() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        
        $response = $rest->get_reports($request);
        
        $this->assertIsArray($response);
    }

    public function test_rest_complete_devices() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        
        $response = $rest->get_devices($request);
        
        $this->assertIsArray($response);
    }

    public function test_rest_complete_sync_status() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        
        $response = $rest->get_sync_status($request);
        
        $this->assertIsArray($response);
        $this->assertArrayHasKey('is_running', $response);
        $this->assertArrayHasKey('last_run', $response);
    }

    public function test_rest_complete_settings() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        
        $response = $rest->get_settings($request);
        
        $this->assertIsArray($response);
        $this->assertArrayHasKey('api_endpoint', $response);
        $this->assertArrayHasKey('auto_sync', $response);
    }

    public function test_create_app_cache() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        $request->method('get_params')->willReturn(array(
            'name' => 'Test Cache',
            'description' => 'Test Description',
            'app_code' => 'TC001',
            'difficulty' => 2.5,
            'terrain' => 3.0,
            'latitude' => 54.1,
            'longitude' => 9.8
        ));
        
        $response = $rest->create_app_cache($request);
        
        $this->assertIsArray($response);
        $this->assertArrayHasKey('id', $response);
        $this->assertArrayHasKey('status', $response);
        $this->assertEquals('created', $response['status']);
    }

    public function test_start_sync() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        
        Actions\expectDone('aukrug_start_sync')->once();
        
        $response = $rest->start_sync($request);
        
        $this->assertIsArray($response);
        $this->assertEquals('started', $response['status']);
    }

    public function test_stop_sync() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        
        Actions\expectDone('aukrug_stop_sync')->once();
        
        $response = $rest->stop_sync($request);
        
        $this->assertIsArray($response);
        $this->assertEquals('stopped', $response['status']);
    }

    public function test_save_settings() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        $request->method('get_params')->willReturn(array(
            'api_endpoint' => 'https://api.example.com',
            'auto_sync' => true,
            'sync_interval' => 30
        ));
        
        $response = $rest->save_settings($request);
        
        $this->assertIsArray($response);
        $this->assertEquals('saved', $response['status']);
    }

    public function test_permission_callback() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $result = $rest->check_admin_permission();
        
        $this->assertTrue($result);
    }

    public function test_get_report() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        $request->method('offsetGet')->with('id')->willReturn(123);
        
        Functions\when('get_post')->justReturn((object) array(
            'ID' => 123,
            'post_title' => 'Test Report',
            'post_content' => 'Test Description',
            'post_type' => 'aukrug_report',
            'post_status' => 'publish',
            'post_date' => date('Y-m-d H:i:s'),
            'post_author' => 1
        ));
        
        $response = $rest->get_report($request);
        
        $this->assertIsArray($response);
        $this->assertArrayHasKey('id', $response);
        $this->assertArrayHasKey('title', $response);
        $this->assertEquals(123, $response['id']);
    }

    public function test_update_report() {
        require_once __DIR__ . '/../includes/class-aukrug-rest-complete.php';
        
        $rest = new Aukrug_REST_Complete();
        $request = $this->createMock('WP_REST_Request');
        $request->method('offsetGet')->with('id')->willReturn(123);
        $request->method('get_params')->willReturn(array(
            'status' => 'closed',
            'title' => 'Updated Report'
        ));
        
        Functions\when('get_post')->justReturn((object) array(
            'ID' => 123,
            'post_type' => 'aukrug_report'
        ));
        
        $response = $rest->update_report($request);
        
        $this->assertIsArray($response);
        $this->assertEquals('updated', $response['status']);
    }

    public function test_cpt_extended_initialization() {
        // Mock WordPress functions for CPT
        Functions\when('register_post_type')->justReturn(true);
        Functions\when('register_taxonomy')->justReturn(true);
        Functions\when('add_meta_box')->justReturn(true);
        Functions\when('wp_nonce_field')->justReturn(true);
        Functions\when('selected')->justReturn(' selected="selected"');
        Functions\when('checked')->justReturn(' checked="checked"');
        Functions\when('update_post_meta')->justReturn(true);
        Functions\when('delete_post_meta')->justReturn(true);
        
        require_once __DIR__ . '/../includes/class-aukrug-cpt-extended.php';
        
        $cpt = new Aukrug_CPT_Extended();
        
        $this->assertInstanceOf('Aukrug_CPT_Extended', $cpt);
    }

    public function test_assets_loading() {
        // Test that modern assets are properly referenced
        $css_file = __DIR__ . '/../../assets/css/admin-modern.css';
        $js_file = __DIR__ . '/../../assets/js/admin-modern.js';
        
        $this->assertFileExists($css_file);
        $this->assertFileExists($js_file);
        
        // Test CSS contains modern design system
        $css_content = file_get_contents($css_file);
        $this->assertStringContainsString(':root', $css_content);
        $this->assertStringContainsString('--bg:', $css_content);
        $this->assertStringContainsString('.au-container', $css_content);
        
        // Test JS contains dashboard class
        $js_content = file_get_contents($js_file);
        $this->assertStringContainsString('AukrugDashboard', $js_content);
        $this->assertStringContainsString('showTab', $js_content);
    }

    public function test_dashboard_page_exists() {
        $dashboard_file = __DIR__ . '/../../admin/dashboard-page-modern.php';
        $this->assertFileExists($dashboard_file);
        
        $content = file_get_contents($dashboard_file);
        $this->assertStringContainsString('au-admin-app', $content);
        $this->assertStringContainsString('data-tab-content', $content);
    }

    public function test_version_consistency() {
        // Test that version constants are properly defined
        require_once __DIR__ . '/../../au_aukrug_connect.php';
        
        $this->assertTrue(defined('AUKRUG_CONNECT_VERSION'));
        $this->assertNotEmpty(AUKRUG_CONNECT_VERSION);
    }
}
