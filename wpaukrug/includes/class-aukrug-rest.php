<?php
/**
 * Comprehensive REST API Endpoints
 * Complete backend implementation for modern dashboard
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class Aukrug_Rest {
    
    public function __construct() {
        add_action('rest_api_init', array($this, 'register_routes'));
    }

    public function register_routes() {
        // KPIs and Overview
        register_rest_route('aukrug/v1', '/kpis', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_kpis'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));

        register_rest_route('aukrug/v1', '/recent-activity', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_recent_activity'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));

        // Community Management - Extended for App Backend
        register_rest_route('aukrug/v1', '/community/members', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_community_members'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));

        register_rest_route('aukrug/v1', '/community/posts', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_community_posts'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));

        register_rest_route('aukrug/v1', '/community/events', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_community_events'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));
        
        // App-to-Backend Community API
        register_rest_route('aukrug/v1', '/app/users/profile', array(
            'methods' => array('GET', 'PUT'),
            'callback' => array($this, 'handle_user_profile'),
            'permission_callback' => array($this, 'check_user_permission')
        ));
        
        register_rest_route('aukrug/v1', '/app/community/groups', array(
            'methods' => array('GET', 'POST'),
            'callback' => array($this, 'handle_community_groups'),
            'permission_callback' => array($this, 'check_user_permission')
        ));
        
        register_rest_route('aukrug/v1', '/app/community/posts', array(
            'methods' => array('GET', 'POST'),
            'callback' => array($this, 'handle_community_posts'),
            'permission_callback' => array($this, 'check_user_permission')
        ));
        
        register_rest_route('aukrug/v1', '/app/community/events', array(
            'methods' => array('GET', 'POST'),
            'callback' => array($this, 'handle_community_events'),
            'permission_callback' => array($this, 'check_user_permission')
        ));
        
        register_rest_route('aukrug/v1', '/app/community/messages', array(
            'methods' => array('GET', 'POST'),
            'callback' => array($this, 'handle_community_messages'),
            'permission_callback' => array($this, 'check_user_permission')
        ));
        
        register_rest_route('aukrug/v1', '/app/community/marketplace', array(
            'methods' => array('GET', 'POST'),
            'callback' => array($this, 'handle_marketplace'),
            'permission_callback' => array($this, 'check_user_permission')
        ));
        
        register_rest_route('aukrug/v1', '/app/community/notifications', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_user_notifications'),
            'permission_callback' => array($this, 'check_user_permission')
        ));

        // Geocaching
        register_rest_route('aukrug/v1', '/geocaching/caches', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_geocaching_caches'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));

        register_rest_route('aukrug/v1', '/geocaching/stats', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_geocaching_stats'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));

        // App-Only Caches
        register_rest_route('aukrug/v1', '/appcaches', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_app_caches'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));

        register_rest_route('aukrug/v1', '/appcaches', array(
            'methods' => 'POST',
            'callback' => array($this, 'create_app_cache'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));

        // Reports (replace old block)
        register_rest_route('aukrug/v1', '/reports', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_reports'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));
        register_rest_route('aukrug/v1', '/health', array(
            'methods' => 'GET',
            'callback' => array($this, 'health_check'),
            'permission_callback' => '__return_true'
        ));
        register_rest_route('aukrug/v1', '/reports/stats', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_reports_stats'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));
        register_rest_route('aukrug/v1', '/reports/stats/timeseries', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_reports_timeseries'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));
        register_rest_route('aukrug/v1', '/reports/export', array(
            'methods' => 'GET',
            'callback' => array($this, 'export_reports'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));
        register_rest_route('aukrug/v1', '/reports/(?P<id>\d+)', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_report'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));
        register_rest_route('aukrug/v1', '/reports/(?P<id>\d+)', array(
            'methods' => 'PUT',
            'callback' => array($this, 'update_report'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));
        register_rest_route('aukrug/v1', '/reports/(?P<id>\d+)/assign', array(
            'methods' => 'POST',
            'callback' => array($this, 'assign_report'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));
        register_rest_route('aukrug/v1', '/reports/bulk', array(
            'methods' => 'POST',
            'callback' => array($this, 'bulk_update_reports'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));
        register_rest_route('aukrug/v1', '/reports/(?P<id>\d+)/comments', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_report_comments'),
            'permission_callback' => array($this, 'check_admin_permission')
        ));
        register_rest_route('aukrug/v1', '/reports/(?P<id>\d+)/comments', array(
            'methods' => 'POST',
            'callback' => array($this, 'add_report_comment'),
            'permission_callback' => '__return_true'
        ));
    }

    public function check_admin_permission() {
        return current_user_can('manage_options');
    }

    public function get_kpis($request) {
        global $wpdb;

        // Get community stats
        $total_members = $wpdb->get_var("
            SELECT COUNT(*) FROM {$wpdb->users} 
            WHERE user_registered >= DATE_SUB(NOW(), INTERVAL 1 YEAR)
        ");

        $members_delta = $wpdb->get_var("
            SELECT COUNT(*) FROM {$wpdb->users} 
            WHERE user_registered >= DATE_SUB(NOW(), INTERVAL 30 DAY)
        ") - $wpdb->get_var("
            SELECT COUNT(*) FROM {$wpdb->users} 
            WHERE user_registered BETWEEN DATE_SUB(NOW(), INTERVAL 60 DAY) AND DATE_SUB(NOW(), INTERVAL 30 DAY)
        ");

        // Get geocache stats
        $active_caches = $wpdb->get_var("
            SELECT COUNT(*) FROM {$wpdb->posts} 
            WHERE post_type = 'geocache' AND post_status = 'publish'
        ");

        $caches_delta = 0; // Placeholder for cache delta calculation

        // Get reports stats
        $total_reports = $wpdb->get_var("
            SELECT COUNT(*) FROM {$wpdb->posts} 
            WHERE post_type = 'aukrug_report'
        ");

        $reports_delta = $wpdb->get_var("
            SELECT COUNT(*) FROM {$wpdb->posts} 
            WHERE post_type = 'aukrug_report' AND post_date >= DATE_SUB(NOW(), INTERVAL 30 DAY)
        ");

        // App downloads (mock data)
        $app_downloads = get_option('aukrug_app_downloads', 1247);
        $downloads_delta = get_option('aukrug_app_downloads_delta', 23);

        return rest_ensure_response(array(
            'total_members' => (int) $total_members,
            'members_delta' => (int) $members_delta,
            'active_caches' => (int) $active_caches,
            'caches_delta' => (int) $caches_delta,
            'total_reports' => (int) $total_reports,
            'reports_delta' => (int) $reports_delta,
            'app_downloads' => (int) $app_downloads,
            'downloads_delta' => (int) $downloads_delta
        ));
    }

    public function get_recent_activity($request) {
        global $wpdb;

        $activities = $wpdb->get_results("
            SELECT 
                p.post_title as title,
                p.post_date as created_at,
                p.post_type,
                CASE 
                    WHEN p.post_type = 'aukrug_report' THEN CONCAT('Neue Meldung: ', p.post_title)
                    WHEN p.post_type = 'geocache' THEN CONCAT('Geocache aktualisiert: ', p.post_title)
                    ELSE CONCAT('Aktivität: ', p.post_title)
                END as description
            FROM {$wpdb->posts} p
            WHERE p.post_type IN ('aukrug_report', 'geocache', 'post')
            AND p.post_status = 'publish'
            ORDER BY p.post_date DESC
            LIMIT 20
        ");

        return rest_ensure_response($activities ?: array());
    }

    public function get_community_members($request) {
        global $wpdb;

        $members = $wpdb->get_results("
            SELECT 
                u.ID as id,
                u.display_name,
                u.user_email as email,
                u.user_registered as registered,
                CASE 
                    WHEN u.user_status = 0 THEN 'active'
                    ELSE 'inactive'
                END as status
            FROM {$wpdb->users} u
            ORDER BY u.user_registered DESC
            LIMIT 100
        ");

        return rest_ensure_response($members ?: array());
    }

    public function get_community_posts($request) {
        $posts = get_posts(array(
            'post_type' => 'post',
            'post_status' => 'publish',
            'numberposts' => 50,
            'orderby' => 'date',
            'order' => 'DESC'
        ));

        $formatted_posts = array_map(function($post) {
            return array(
                'id' => $post->ID,
                'title' => $post->post_title,
                'content' => wp_trim_words($post->post_content, 20),
                'author' => get_the_author_meta('display_name', $post->post_author),
                'date' => $post->post_date,
                'status' => $post->post_status
            );
        }, $posts);

        return rest_ensure_response($formatted_posts);
    }

    public function get_community_events($request) {
        // Mock event data
        $events = array(
            array(
                'id' => 1,
                'title' => 'Aukrug Stammtisch',
                'date' => date('Y-m-d H:i:s', strtotime('+1 week')),
                'location' => 'Gasthof zur Post, Aukrug',
                'attendees' => 15
            ),
            array(
                'id' => 2,
                'title' => 'Geocaching Tour',
                'date' => date('Y-m-d H:i:s', strtotime('+2 weeks')),
                'location' => 'Aukrug Wanderweg',
                'attendees' => 8
            )
        );

        return rest_ensure_response($events);
    }

    public function get_geocaching_caches($request) {
        global $wpdb;

        $caches = $wpdb->get_results("
            SELECT 
                p.ID as id,
                p.post_title as name,
                pm1.meta_value as gc_code,
                pm2.meta_value as type,
                pm3.meta_value as latitude,
                pm4.meta_value as longitude,
                p.post_status as status,
                pm5.meta_value as owner,
                p.post_modified as last_sync
            FROM {$wpdb->posts} p
            LEFT JOIN {$wpdb->postmeta} pm1 ON p.ID = pm1.post_id AND pm1.meta_key = 'gc_code'
            LEFT JOIN {$wpdb->postmeta} pm2 ON p.ID = pm2.post_id AND pm2.meta_key = 'cache_type'
            LEFT JOIN {$wpdb->postmeta} pm3 ON p.ID = pm3.post_id AND pm3.meta_key = 'latitude'
            LEFT JOIN {$wpdb->postmeta} pm4 ON p.ID = pm4.post_id AND pm4.meta_key = 'longitude'
            LEFT JOIN {$wpdb->postmeta} pm5 ON p.ID = pm5.post_id AND pm5.meta_key = 'cache_owner'
            WHERE p.post_type = 'geocache'
            ORDER BY p.post_date DESC
            LIMIT 100
        ");

        return rest_ensure_response($caches ?: array());
    }

    public function get_geocaching_stats($request) {
        global $wpdb;

        $stats = array(
            'total_caches' => $wpdb->get_var("SELECT COUNT(*) FROM {$wpdb->posts} WHERE post_type = 'geocache'"),
            'active_caches' => $wpdb->get_var("SELECT COUNT(*) FROM {$wpdb->posts} WHERE post_type = 'geocache' AND post_status = 'publish'"),
            'archived_caches' => $wpdb->get_var("SELECT COUNT(*) FROM {$wpdb->posts} WHERE post_type = 'geocache' AND post_status = 'private'")
        );

        return rest_ensure_response($stats);
    }

    public function get_app_caches($request) {
        global $wpdb;

        $app_caches = $wpdb->get_results("
            SELECT 
                p.ID as id,
                p.post_title as name,
                pm1.meta_value as app_code,
                pm2.meta_value as difficulty,
                pm3.meta_value as terrain,
                pm4.meta_value as latitude,
                pm5.meta_value as longitude,
                p.post_status as status,
                p.post_date as created_at
            FROM {$wpdb->posts} p
            LEFT JOIN {$wpdb->postmeta} pm1 ON p.ID = pm1.post_id AND pm1.meta_key = 'app_code'
            LEFT JOIN {$wpdb->postmeta} pm2 ON p.ID = pm2.post_id AND pm2.meta_key = 'difficulty'
            LEFT JOIN {$wpdb->postmeta} pm3 ON p.ID = pm3.post_id AND pm3.meta_key = 'terrain'
            LEFT JOIN {$wpdb->postmeta} pm4 ON p.ID = pm4.post_id AND pm4.meta_key = 'latitude'
            LEFT JOIN {$wpdb->postmeta} pm5 ON p.ID = pm5.post_id AND pm5.meta_key = 'longitude'
            WHERE p.post_type = 'app_cache'
            ORDER BY p.post_date DESC
        ");

        return rest_ensure_response($app_caches ?: array());
    }

    public function get_reports($request) {
        global $wpdb; $params = $request->get_params();
        $where = "WHERE p.post_type='aukrug_report'";
        if (!empty($params['status'])) { $status = esc_sql(sanitize_text_field($params['status'])); $where .= " AND pm_status.meta_value='$status'"; }
        if (!empty($params['category'])) { $cat = esc_sql(sanitize_text_field($params['category'])); $where .= " AND pm_cat.meta_value='$cat'"; }
        if (!empty($params['priority'])) { $prio = esc_sql(sanitize_text_field($params['priority'])); $where .= " AND pm_prio.meta_value='$prio'"; }
        if (!empty($params['from'])) { $from = esc_sql(sanitize_text_field($params['from'])); $where .= " AND p.post_date>='$from'"; }
        if (!empty($params['to'])) { $to = esc_sql(sanitize_text_field($params['to'])); $where .= " AND p.post_date<='$to'"; }
        $limit = isset($params['limit']) ? min(200, max(1, intval($params['limit']))) : 50;
        $sql = $wpdb->prepare("SELECT p.ID id, p.post_title title, p.post_content description, pm_cat.meta_value category, pm_prio.meta_value priority, pm_status.meta_value status, pm_addr.meta_value address, pm_lat.meta_value lat, pm_lng.meta_value lng, pm_assign.meta_value assigned_to, p.post_date created_at, p.post_author user_id FROM {$wpdb->posts} p LEFT JOIN {$wpdb->postmeta} pm_cat ON p.ID=pm_cat.post_id AND pm_cat.meta_key='report_category' LEFT JOIN {$wpdb->postmeta} pm_prio ON p.ID=pm_prio.post_id AND pm_prio.meta_key='report_priority' LEFT JOIN {$wpdb->postmeta} pm_status ON p.ID=pm_status.post_id AND pm_status.meta_key='report_status' LEFT JOIN {$wpdb->postmeta} pm_addr ON p.ID=pm_addr.post_id AND pm_addr.meta_key='report_address' LEFT JOIN {$wpdb->postmeta} pm_lat ON p.ID=pm_lat.post_id AND pm_lat.meta_key='report_lat' LEFT JOIN {$wpdb->postmeta} pm_lng ON p.ID=pm_lng.post_id AND pm_lng.meta_key='report_lng' LEFT JOIN {$wpdb->postmeta} pm_assign ON p.ID=pm_assign.post_id AND pm_assign.meta_key='report_assigned_to' $where ORDER BY p.post_date DESC LIMIT %d", $limit);
        $reports = $wpdb->get_results($sql);
        return rest_ensure_response($reports ?: array());
    }

    public function get_reports_stats($request) {
        global $wpdb; $stats = array('total'=>0,'by_status'=>array(),'by_priority'=>array(),'by_category'=>array(),'open_reports'=>0,'urgent_reports'=>0);
        $stats['total'] = (int)$wpdb->get_var("SELECT COUNT(*) FROM {$wpdb->posts} WHERE post_type='aukrug_report'");
        $rows = $wpdb->get_results("SELECT pm.meta_value status, COUNT(*) c FROM {$wpdb->postmeta} pm JOIN {$wpdb->posts} p ON p.ID=pm.post_id WHERE p.post_type='aukrug_report' AND pm.meta_key='report_status' GROUP BY pm.meta_value", ARRAY_A); foreach ($rows as $r){$stats['by_status'][$r['status']] = (int)$r['c']; if($r['status']==='open') $stats['open_reports']=(int)$r['c'];}
        $rows = $wpdb->get_results("SELECT pm.meta_value prio, COUNT(*) c FROM {$wpdb->postmeta} pm JOIN {$wpdb->posts} p ON p.ID=pm.post_id WHERE p.post_type='aukrug_report' AND pm.meta_key='report_priority' GROUP BY pm.meta_value", ARRAY_A); foreach ($rows as $r){$stats['by_priority'][$r['prio']] = (int)$r['c']; if($r['prio']==='urgent') $stats['urgent_reports']=(int)$r['c'];}
        $rows = $wpdb->get_results("SELECT pm.meta_value cat, COUNT(*) c FROM {$wpdb->postmeta} pm JOIN {$wpdb->posts} p ON p.ID=pm.post_id WHERE p.post_type='aukrug_report' AND pm.meta_key='report_category' GROUP BY pm.meta_value", ARRAY_A); foreach ($rows as $r){$stats['by_category'][$r['cat']] = (int)$r['c'];}
        return rest_ensure_response($stats);
    }

    public function get_devices($request) {
        global $wpdb;

        // Mock device data
        $devices = array(
            array(
                'id' => 1,
                'device_name' => 'iPhone 15 Pro',
                'platform' => 'iOS',
                'app_version' => '1.2.3',
                'last_seen' => date('Y-m-d H:i:s', strtotime('-2 hours')),
                'is_active' => true
            ),
            array(
                'id' => 2,
                'device_name' => 'Samsung Galaxy S24',
                'platform' => 'Android',
                'app_version' => '1.2.1',
                'last_seen' => date('Y-m-d H:i:s', strtotime('-1 day')),
                'is_active' => false
            )
        );

        return rest_ensure_response($devices);
    }

    public function get_sync_status($request) {
        $status = array(
            'is_running' => get_option('aukrug_sync_running', false),
            'last_run' => get_option('aukrug_sync_last_run', date('Y-m-d H:i:s')),
            'next_run' => get_option('aukrug_sync_next_run', date('Y-m-d H:i:s', strtotime('+15 minutes'))),
            'total_synced' => get_option('aukrug_sync_total_synced', 156),
            'errors' => get_option('aukrug_sync_errors', 0)
        );

        return rest_ensure_response($status);
    }

    public function get_sync_logs($request) {
        $logs = get_option('aukrug_sync_logs', array(
            array(
                'timestamp' => date('Y-m-d H:i:s', strtotime('-1 hour')),
                'type' => 'info',
                'message' => 'Synchronisation erfolgreich abgeschlossen'
            ),
            array(
                'timestamp' => date('Y-m-d H:i:s', strtotime('-2 hours')),
                'type' => 'warning',
                'message' => 'Geocache GC123ABC nicht gefunden'
            )
        ));

        return rest_ensure_response($logs);
    }

    public function start_sync($request) {
        update_option('aukrug_sync_running', true);
        update_option('aukrug_sync_last_run', current_time('mysql'));
        
        // Trigger actual sync process here
        do_action('aukrug_start_sync');

        return rest_ensure_response(array('status' => 'started'));
    }

    public function stop_sync($request) {
        update_option('aukrug_sync_running', false);
        
        // Stop sync process here
        do_action('aukrug_stop_sync');

        return rest_ensure_response(array('status' => 'stopped'));
    }

    public function get_settings($request) {
        $settings = array(
            'api_endpoint' => get_option('aukrug_api_endpoint', ''),
            'api_key' => get_option('aukrug_api_key', ''),
            'auto_sync' => get_option('aukrug_auto_sync', true),
            'sync_interval' => get_option('aukrug_sync_interval', 15),
            'email_notifications' => get_option('aukrug_email_notifications', true),
            'push_notifications' => get_option('aukrug_push_notifications', false),
            'debug_mode' => get_option('aukrug_debug_mode', false),
            'cache_enabled' => get_option('aukrug_cache_enabled', true),
            'cache_ttl' => get_option('aukrug_cache_ttl', 300)
        );

        return rest_ensure_response($settings);
    }

    public function save_settings($request) {
        $params = $request->get_params();
        
        $settings_map = array(
            'api_endpoint' => 'aukrug_api_endpoint',
            'api_key' => 'aukrug_api_key',
            'auto_sync' => 'aukrug_auto_sync',
            'sync_interval' => 'aukrug_sync_interval',
            'email_notifications' => 'aukrug_email_notifications',
            'push_notifications' => 'aukrug_push_notifications',
            'debug_mode' => 'aukrug_debug_mode',
            'cache_enabled' => 'aukrug_cache_enabled',
            'cache_ttl' => 'aukrug_cache_ttl'
        );

        foreach ($settings_map as $param => $option) {
            if (isset($params[$param])) {
                update_option($option, $params[$param]);
            }
        }

        return rest_ensure_response(array('status' => 'saved'));
    }

    public function create_app_cache($request) {
        $params = $request->get_params();
        
        $post_data = array(
            'post_title' => sanitize_text_field($params['name']),
            'post_content' => sanitize_textarea_field($params['description']),
            'post_type' => 'app_cache',
            'post_status' => 'publish',
            'meta_input' => array(
                'app_code' => sanitize_text_field($params['app_code']),
                'difficulty' => floatval($params['difficulty']),
                'terrain' => floatval($params['terrain']),
                'latitude' => floatval($params['latitude']),
                'longitude' => floatval($params['longitude'])
            )
        );

        $post_id = wp_insert_post($post_data);

        if (is_wp_error($post_id)) {
            return new WP_Error('create_failed', 'Failed to create app cache', array('status' => 500));
        }

        return rest_ensure_response(array('id' => $post_id, 'status' => 'created'));
    }

    public function get_report($request) {
        $id = $request['id'];
        $post = get_post($id);
        
        if (!$post || $post->post_type !== 'aukrug_report') {
            return new WP_Error('not_found', 'Report not found', array('status' => 404));
        }
        $attachments_json = get_post_meta($post->ID,'report_attachments',true);
        $attachments = $attachments_json ? json_decode($attachments_json,true) : array();
        $report = array(
            'id' => $post->ID,
            'title' => $post->post_title,
            'description' => $post->post_content,
            'category' => get_post_meta($post->ID, 'report_category', true),
            'priority' => get_post_meta($post->ID, 'report_priority', true),
            'status' => get_post_meta($post->ID, 'report_status', true) ?: 'open',
            'address' => get_post_meta($post->ID,'report_address',true),
            'lat' => get_post_meta($post->ID,'report_lat',true),
            'lng' => get_post_meta($post->ID,'report_lng',true),
            'assigned_to' => get_post_meta($post->ID,'report_assigned_to',true),
            'due_date' => get_post_meta($post->ID,'report_due_date',true),
            'attachments' => $attachments,
            'created_at' => $post->post_date,
            'user_id' => $post->post_author
        );

        return rest_ensure_response($report);
    }

    public function update_report($request) {
        // ...existing code up to wp_update_post...
        $id = $request['id'];
        $params = $request->get_params();
        $post = get_post($id);
        if (!$post || $post->post_type !== 'aukrug_report') {
            return new WP_Error('not_found', 'Report not found', array('status' => 404));
        }
        
        // Track old status for notifications
        $old_status = get_post_meta($id, 'report_status', true);
        
        $update_data = array('ID' => $id);
        if (isset($params['title'])) { $update_data['post_title'] = sanitize_text_field($params['title']); }
        if (isset($params['description'])) { $update_data['post_content'] = wp_kses_post($params['description']); }
        if (count($update_data) > 1) { wp_update_post($update_data); }
        if (isset($params['status'])) { 
            update_post_meta($id, 'report_status', sanitize_text_field($params['status'])); 
            
            // Trigger status change notification
            $new_status = sanitize_text_field($params['status']);
            if ($old_status !== $new_status && class_exists('Aukrug_Notifications')) {
                Aukrug_Notifications::trigger_status_changed($id, $old_status, $new_status);
            }
        }
        if (isset($params['priority'])) { update_post_meta($id, 'report_priority', sanitize_text_field($params['priority'])); }
        if (isset($params['category'])) { update_post_meta($id, 'report_category', sanitize_text_field($params['category'])); }
        if (isset($params['assigned_to'])) { 
            $old_assignee = get_post_meta($id, 'report_assigned_to', true);
            $new_assignee = intval($params['assigned_to']);
            update_post_meta($id, 'report_assigned_to', $new_assignee); 
            
            // Trigger assignment notification
            if ($old_assignee != $new_assignee && $new_assignee > 0 && class_exists('Aukrug_Notifications')) {
                Aukrug_Notifications::trigger_assignment($id, $new_assignee, get_current_user_id());
            }
        }
        if (isset($params['due_date'])) { update_post_meta($id, 'report_due_date', sanitize_text_field($params['due_date'])); }
        $this->log_report_activity($id, 'update');
        return rest_ensure_response(array('status' => 'updated'));
    }

    private function allowed_report_categories(){return array('strasse','beleuchtung','abfall','vandalismus','gruenflaeche','wasser','laerm','spielplatz','umwelt','winterdienst','gebaeude','sonstiges');}
    private function normalize_category($cat){$cat=sanitize_key($cat);return in_array($cat,$this->allowed_report_categories(),true)?$cat:'sonstiges';}
    private function log_report_activity($report_id,$action,$meta=array()){global $wpdb;$table=$wpdb->prefix.'aukrug_report_activity';$wpdb->insert($table,array('report_id'=>intval($report_id),'action'=>sanitize_key($action),'actor_id'=>get_current_user_id()?:null,'actor_role'=>current_user_can('manage_options')?'admin':(is_user_logged_in()?'user':'anonymous'),'meta'=>!empty($meta)?wp_json_encode($meta):null));}
    private function rate_limit_check($type,$limit=5,$per_seconds=300){
        // Primitive IP basiertes Rate-Limit (kein perfekter Schutz, aber Grundrauschen filtert Bots)
        $ip = $_SERVER['REMOTE_ADDR'] ?? '0.0.0.0';
        $key = 'aukrug_rl_'.$type.'_'.md5($ip);
        $window = get_transient($key);
        if(!$window){
            $window = array('count'=>0,'start'=>time());
        }
        if(time() - $window['start'] > $per_seconds){
            $window = array('count'=>0,'start'=>time());
        }
        if($window['count'] >= $limit){
            return new WP_Error('rate_limited','Zu viele Anfragen. Bitte später erneut versuchen.',array('status'=>429));
        }
        $window['count']++;
        set_transient($key,$window,$per_seconds);
        return true;
    }

    public function create_report($request){
        // Rate-Limit (5 Meldungen / 5 Minuten pro IP)
        $rl = $this->rate_limit_check('create_report',5,300); if(is_wp_error($rl)) return $rl;
        $p=$request->get_params();
        $title=sanitize_text_field($p['title']??'Meldung');
        $desc=wp_kses_post($p['description']??'');
        $cat=$this->normalize_category($p['category']??'sonstiges');
        $prio=sanitize_key($p['priority']??'normal');
        $post_id=wp_insert_post(array('post_type'=>'aukrug_report','post_title'=>$title,'post_content'=>$desc,'post_status'=>'publish'));
        if(is_wp_error($post_id))return new WP_Error('create_failed','Report konnte nicht erstellt werden',array('status'=>500));
        update_post_meta($post_id,'report_category',$cat);
        update_post_meta($post_id,'report_priority',$prio);
        update_post_meta($post_id,'report_status','open');
        if(!empty($p['lat']))update_post_meta($post_id,'report_lat',floatval($p['lat']));
        if(!empty($p['lng']))update_post_meta($post_id,'report_lng',floatval($p['lng']));
        if(!empty($p['address']))update_post_meta($post_id,'report_address',sanitize_text_field($p['address']));
        if(!empty($p['contact_email']))update_post_meta($post_id,'report_contact_email',sanitize_email($p['contact_email']));
        if(!empty($p['contact_name']))update_post_meta($post_id,'report_contact_name',sanitize_text_field($p['contact_name']));
        if(!empty($p['attachments']))update_post_meta($post_id,'report_attachments',wp_json_encode($p['attachments']));
        update_post_meta($post_id,'report_ip',$_SERVER['REMOTE_ADDR']??'');
        $this->log_report_activity($post_id,'create');
        
        // Trigger notification
        if (class_exists('Aukrug_Notifications')) {
            Aukrug_Notifications::trigger_report_created($post_id, array(
                'title' => $title,
                'description' => $desc,
                'category' => $cat,
                'priority' => $prio,
                'address' => $p['address'] ?? ''
            ));
        }
        
        return rest_ensure_response(array('id'=>$post_id,'status'=>'created'));
    }

    public function get_report_comments($request){global $wpdb;$rid=intval($request['id']);$table=$wpdb->prefix.'aukrug_report_comments';$visibility=current_user_can('manage_options')?"IN ('public','internal')":"= 'public'";$rows=$wpdb->get_results($wpdb->prepare("SELECT id,author_id,author_name,author_role,visibility,message,attachments,created_at FROM $table WHERE report_id=%d AND visibility $visibility ORDER BY id ASC",$rid));foreach($rows as &$r){if(!empty($r->attachments)){$r->attachments=json_decode($r->attachments,true);} }return rest_ensure_response($rows?:array());}

    public function add_report_comment($request){
        // Rate-Limit (10 Kommentare / 5 Minuten pro IP)
        $rl = $this->rate_limit_check('add_report_comment',10,300); if(is_wp_error($rl)) return $rl;
        global $wpdb;
        $rid=intval($request['id']);
        $p=$request->get_params();
        $msg=trim(wp_kses_post($p['message']??''));
        if($msg==='')return new WP_Error('empty_message','Leere Nachricht',array('status'=>400));

        // Community API Handlers for Flutter App
    }
    
    /**
     * Check user permission for app requests
     */
    public function check_user_permission($request) {
        return is_user_logged_in();
    }
    
    /**
     * Handle user profile requests from app
     */
    public function handle_user_profile($request) {
        $user_id = get_current_user_id();
        
        if ($request->get_method() === 'GET') {
            return $this->get_user_profile_data($user_id);
        } else if ($request->get_method() === 'PUT') {
            return $this->update_user_profile_data($user_id, $request->get_params());
        }
    }
    
    /**
     * Handle community groups from app
     */
    public function handle_community_groups($request) {
        if ($request->get_method() === 'GET') {
            return $this->get_groups_for_app($request->get_params());
        } else if ($request->get_method() === 'POST') {
            return $this->create_group_from_app($request->get_params());
        }
    }
    
    /**
     * Handle community posts from app
     */
    public function handle_community_posts($request) {
        if ($request->get_method() === 'GET') {
            return $this->get_posts_for_app($request->get_params());
        } else if ($request->get_method() === 'POST') {
            return $this->create_post_from_app($request->get_params());
        }
    }
    
    /**
     * Handle community events from app
     */
    public function handle_community_events($request) {
        if ($request->get_method() === 'GET') {
            return $this->get_events_for_app($request->get_params());
        } else if ($request->get_method() === 'POST') {
            return $this->create_event_from_app($request->get_params());
        }
    }
    
    /**
     * Handle community messages from app
     */
    public function handle_community_messages($request) {
        if ($request->get_method() === 'GET') {
            return $this->get_messages_for_app($request->get_params());
        } else if ($request->get_method() === 'POST') {
            return $this->send_message_from_app($request->get_params());
        }
    }
    
    /**
     * Handle marketplace from app
     */
    public function handle_marketplace($request) {
        if ($request->get_method() === 'GET') {
            return $this->get_marketplace_for_app($request->get_params());
        } else if ($request->get_method() === 'POST') {
            return $this->create_marketplace_item_from_app($request->get_params());
        }
    }
    
    /**
     * Get user notifications for app
     */
    public function get_user_notifications($request) {
        $user_id = get_current_user_id();
        global $wpdb;
        
        $table = $wpdb->prefix . 'aukrug_notifications';
        $notifications = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $table WHERE user_id = %d ORDER BY created_at DESC LIMIT 50",
            $user_id
        ));
        
        return rest_ensure_response($notifications ?: array());
    }
    
    // Implementation methods for app backend
    
    private function get_user_profile_data($user_id) {
        global $wpdb;
        
        $user = get_userdata($user_id);
        if (!$user) {
            return new WP_Error('user_not_found', 'User not found', array('status' => 404));
        }
        
        // Get extended profile data
        $table = $wpdb->prefix . 'aukrug_user_profiles';
        $profile = $wpdb->get_row($wpdb->prepare(
            "SELECT * FROM $table WHERE user_id = %d",
            $user_id
        ));
        
        $data = array(
            'id' => $user_id,
            'username' => $user->user_login,
            'email' => $user->user_email,
            'display_name' => $user->display_name,
            'role' => $user->roles[0] ?? 'subscriber',
            'bio' => $profile->bio ?? '',
            'location' => $profile->location ?? '',
            'website' => $profile->website ?? '',
            'phone' => $profile->phone ?? '',
            'verification_status' => $profile->verification_status ?? 'pending',
            'avatar_url' => get_avatar_url($user_id),
            'member_since' => $user->user_registered
        );
        
        return rest_ensure_response($data);
    }
    
    private function update_user_profile_data($user_id, $params) {
        global $wpdb;
        
        $table = $wpdb->prefix . 'aukrug_user_profiles';
        
        $update_data = array();
        if (isset($params['bio'])) $update_data['bio'] = sanitize_textarea_field($params['bio']);
        if (isset($params['location'])) $update_data['location'] = sanitize_text_field($params['location']);
        if (isset($params['website'])) $update_data['website'] = esc_url_raw($params['website']);
        if (isset($params['phone'])) $update_data['phone'] = sanitize_text_field($params['phone']);
        
        if (!empty($update_data)) {
            $update_data['updated_at'] = current_time('mysql');
            
            $existing = $wpdb->get_var($wpdb->prepare(
                "SELECT id FROM $table WHERE user_id = %d",
                $user_id
            ));
            
            if ($existing) {
                $wpdb->update($table, $update_data, array('user_id' => $user_id));
            } else {
                $update_data['user_id'] = $user_id;
                $update_data['created_at'] = current_time('mysql');
                $wpdb->insert($table, $update_data);
            }
        }
        
        return rest_ensure_response(array('status' => 'updated'));
    }
    
    private function get_groups_for_app($params) {
        global $wpdb;
        
        $table = $wpdb->prefix . 'aukrug_groups';
        $limit = intval($params['limit'] ?? 20);
        $offset = intval($params['offset'] ?? 0);
        $type = sanitize_text_field($params['type'] ?? '');
        
        $where = "WHERE status = 'active'";
        if ($type && in_array($type, ['public', 'private'])) {
            $where .= $wpdb->prepare(" AND type = %s", $type);
        }
        
        $groups = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $table $where ORDER BY created_at DESC LIMIT %d OFFSET %d",
            $limit, $offset
        ));
        
        return rest_ensure_response($groups ?: array());
    }
    
    private function create_group_from_app($params) {
        global $wpdb;
        
        $user_id = get_current_user_id();
        $table = $wpdb->prefix . 'aukrug_groups';
        
        $data = array(
            'name' => sanitize_text_field($params['name']),
            'description' => sanitize_textarea_field($params['description'] ?? ''),
            'type' => in_array($params['type'], ['public', 'private', 'secret']) ? $params['type'] : 'public',
            'category' => sanitize_text_field($params['category'] ?? ''),
            'location' => sanitize_text_field($params['location'] ?? ''),
            'creator_id' => $user_id,
            'created_at' => current_time('mysql')
        );
        
        $result = $wpdb->insert($table, $data);
        
        if ($result === false) {
            return new WP_Error('create_failed', 'Group creation failed', array('status' => 500));
        }
        
        $group_id = $wpdb->insert_id;
        
        // Add creator as admin member
        $members_table = $wpdb->prefix . 'aukrug_group_members';
        $wpdb->insert($members_table, array(
            'group_id' => $group_id,
            'user_id' => $user_id,
            'role' => 'admin',
            'joined_at' => current_time('mysql')
        ));
        
        return rest_ensure_response(array('id' => $group_id, 'status' => 'created'));
    }
    
    private function get_posts_for_app($params) {
        global $wpdb;
        
        $table = $wpdb->prefix . 'aukrug_posts';
        $limit = intval($params['limit'] ?? 20);
        $offset = intval($params['offset'] ?? 0);
        $group_id = intval($params['group_id'] ?? 0);
        
        $where = "WHERE status = 'published'";
        if ($group_id) {
            $where .= $wpdb->prepare(" AND group_id = %d", $group_id);
        }
        
        $posts = $wpdb->get_results($wpdb->prepare(
            "SELECT p.*, u.display_name as author_name 
             FROM $table p 
             LEFT JOIN {$wpdb->users} u ON p.user_id = u.ID 
             $where 
             ORDER BY p.created_at DESC 
             LIMIT %d OFFSET %d",
            $limit, $offset
        ));
        
        return rest_ensure_response($posts ?: array());
    }
    
    private function create_post_from_app($params) {
        global $wpdb;
        
        $user_id = get_current_user_id();
        $table = $wpdb->prefix . 'aukrug_posts';
        
        $data = array(
            'user_id' => $user_id,
            'content' => wp_kses_post($params['content']),
            'type' => in_array($params['type'], ['text', 'image', 'video', 'link']) ? $params['type'] : 'text',
            'visibility' => in_array($params['visibility'], ['public', 'friends', 'group']) ? $params['visibility'] : 'public',
            'group_id' => intval($params['group_id'] ?? 0) ?: null,
            'location' => sanitize_text_field($params['location'] ?? ''),
            'attachments' => !empty($params['attachments']) ? wp_json_encode($params['attachments']) : null,
            'created_at' => current_time('mysql')
        );
        
        $result = $wpdb->insert($table, $data);
        
        if ($result === false) {
            return new WP_Error('create_failed', 'Post creation failed', array('status' => 500));
        }
        
        return rest_ensure_response(array('id' => $wpdb->insert_id, 'status' => 'created'));
    }
    
    private function get_events_for_app($params) {
        global $wpdb;
        
        $table = $wpdb->prefix . 'aukrug_events';
        $limit = intval($params['limit'] ?? 20);
        $offset = intval($params['offset'] ?? 0);
        
        $events = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $table 
             WHERE status = 'published' AND start_date >= NOW() 
             ORDER BY start_date ASC 
             LIMIT %d OFFSET %d",
            $limit, $offset
        ));
        
        return rest_ensure_response($events ?: array());
    }
    
    private function create_event_from_app($params) {
        global $wpdb;
        
        $user_id = get_current_user_id();
        $table = $wpdb->prefix . 'aukrug_events';
        
        $data = array(
            'title' => sanitize_text_field($params['title']),
            'description' => sanitize_textarea_field($params['description'] ?? ''),
            'organizer_id' => $user_id,
            'start_date' => sanitize_text_field($params['start_date']),
            'end_date' => sanitize_text_field($params['end_date']),
            'location' => sanitize_text_field($params['location'] ?? ''),
            'address' => sanitize_textarea_field($params['address'] ?? ''),
            'type' => in_array($params['type'], ['public', 'private', 'group']) ? $params['type'] : 'public',
            'category' => sanitize_text_field($params['category'] ?? ''),
            'max_attendees' => intval($params['max_attendees'] ?? 0) ?: null,
            'created_at' => current_time('mysql')
        );
        
        $result = $wpdb->insert($table, $data);
        
        if ($result === false) {
            return new WP_Error('create_failed', 'Event creation failed', array('status' => 500));
        }
        
        return rest_ensure_response(array('id' => $wpdb->insert_id, 'status' => 'created'));
    }
    
    private function get_messages_for_app($params) {
        global $wpdb;
        
        $user_id = get_current_user_id();
        $conversation_id = intval($params['conversation_id'] ?? 0);
        
        if (!$conversation_id) {
            // Get conversations for user
            $conversations_table = $wpdb->prefix . 'aukrug_conversations';
            $participants_table = $wpdb->prefix . 'aukrug_conversation_participants';
            
            $conversations = $wpdb->get_results($wpdb->prepare(
                "SELECT c.* FROM $conversations_table c 
                 INNER JOIN $participants_table p ON c.id = p.conversation_id 
                 WHERE p.user_id = %d AND p.status = 'active' 
                 ORDER BY c.last_activity DESC",
                $user_id
            ));
            
            return rest_ensure_response($conversations ?: array());
        } else {
            // Get messages for conversation
            $messages_table = $wpdb->prefix . 'aukrug_messages';
            
            $messages = $wpdb->get_results($wpdb->prepare(
                "SELECT m.*, u.display_name as sender_name 
                 FROM $messages_table m 
                 LEFT JOIN {$wpdb->users} u ON m.sender_id = u.ID 
                 WHERE m.conversation_id = %d 
                 ORDER BY m.created_at ASC 
                 LIMIT 100",
                $conversation_id
            ));
            
            return rest_ensure_response($messages ?: array());
        }
    }
    
    private function send_message_from_app($params) {
        global $wpdb;
        
        $user_id = get_current_user_id();
        $conversation_id = intval($params['conversation_id']);
        $content = sanitize_textarea_field($params['content']);
        
        if (empty($content)) {
            return new WP_Error('empty_content', 'Message content cannot be empty', array('status' => 400));
        }
        
        $messages_table = $wpdb->prefix . 'aukrug_messages';
        
        $data = array(
            'conversation_id' => $conversation_id,
            'sender_id' => $user_id,
            'content' => $content,
            'message_type' => $params['type'] ?? 'text',
            'attachments' => !empty($params['attachments']) ? wp_json_encode($params['attachments']) : null,
            'created_at' => current_time('mysql')
        );
        
        $result = $wpdb->insert($messages_table, $data);
        
        if ($result === false) {
            return new WP_Error('send_failed', 'Message sending failed', array('status' => 500));
        }
        
        // Update conversation last activity
        $conversations_table = $wpdb->prefix . 'aukrug_conversations';
        $wpdb->update(
            $conversations_table,
            array('last_activity' => current_time('mysql')),
            array('id' => $conversation_id)
        );
        
        return rest_ensure_response(array('id' => $wpdb->insert_id, 'status' => 'sent'));
    }
    
    private function get_marketplace_for_app($params) {
        global $wpdb;
        
        $table = $wpdb->prefix . 'aukrug_marketplace';
        $limit = intval($params['limit'] ?? 20);
        $offset = intval($params['offset'] ?? 0);
        $category = sanitize_text_field($params['category'] ?? '');
        
        $where = "WHERE status = 'available'";
        if ($category) {
            $where .= $wpdb->prepare(" AND category = %s", $category);
        }
        
        $items = $wpdb->get_results($wpdb->prepare(
            "SELECT m.*, u.display_name as seller_name 
             FROM $table m 
             LEFT JOIN {$wpdb->users} u ON m.seller_id = u.ID 
             $where 
             ORDER BY m.created_at DESC 
             LIMIT %d OFFSET %d",
            $limit, $offset
        ));
        
        return rest_ensure_response($items ?: array());
    }
    
    private function create_marketplace_item_from_app($params) {
        global $wpdb;
        
        $user_id = get_current_user_id();
        $table = $wpdb->prefix . 'aukrug_marketplace';
        
        $data = array(
            'seller_id' => $user_id,
            'title' => sanitize_text_field($params['title']),
            'description' => sanitize_textarea_field($params['description'] ?? ''),
            'category' => sanitize_text_field($params['category'] ?? ''),
            'price' => floatval($params['price'] ?? 0),
            'currency' => 'EUR',
            'condition_type' => in_array($params['condition'], ['new', 'like_new', 'good', 'fair', 'poor']) ? $params['condition'] : 'good',
            'location' => sanitize_text_field($params['location'] ?? ''),
            'images' => !empty($params['images']) ? wp_json_encode($params['images']) : null,
            'created_at' => current_time('mysql')
        );
        
        $result = $wpdb->insert($table, $data);
        
        if ($result === false) {
            return new WP_Error('create_failed', 'Marketplace item creation failed', array('status' => 500));
        }
        
        return rest_ensure_response(array('id' => $wpdb->insert_id, 'status' => 'created'));
        $table=$wpdb->prefix.'aukrug_report_comments';
        $visibility=(isset($p['visibility'])&&current_user_can('manage_options')&&$p['visibility']==='internal')?'internal':'public';
        $attachments=!empty($p['attachments'])?wp_json_encode($p['attachments']):null;
        
        $is_admin_comment = current_user_can('manage_options');
        
        $wpdb->insert($table,array(
            'report_id'=>$rid,
            'author_id'=>get_current_user_id()?:null,
            'author_name'=>is_user_logged_in()?wp_get_current_user()->display_name:sanitize_text_field($p['author_name']??''),
            'author_email'=>is_user_logged_in()?wp_get_current_user()->user_email:sanitize_email($p['author_email']??''),
            'author_role'=>current_user_can('manage_options')?'admin':(is_user_logged_in()?'user':'anonymous'),
            'visibility'=>$visibility,
            'message'=>$msg,
            'attachments'=>$attachments
        ));
        $cid=$wpdb->insert_id;
        $this->log_report_activity($rid,'comment',array('comment_id'=>$cid,'visibility'=>$visibility));
        
        // Trigger comment notification
        if (class_exists('Aukrug_Notifications')) {
            $comment_data = array(
                'author_name' => is_user_logged_in() ? wp_get_current_user()->display_name : sanitize_text_field($p['author_name'] ?? ''),
                'message' => $msg,
                'visibility' => $visibility
            );
            Aukrug_Notifications::trigger_comment_added($rid, $comment_data, $is_admin_comment);
        }
        
        return rest_ensure_response(array('id'=>$cid,'status'=>'created'));
    }

    public function assign_report($request){$rid=intval($request['id']);$assignee=intval($request->get_param('user_id'));update_post_meta($rid,'report_assigned_to',$assignee);$this->log_report_activity($rid,'assign',array('to'=>$assignee));return rest_ensure_response(array('status'=>'assigned'));}

    public function bulk_update_reports($request){$p=$request->get_params();$ids=array_map('intval',$p['ids']??array());$updated=0;foreach($ids as $id){if(!empty($p['status']))update_post_meta($id,'report_status',sanitize_text_field($p['status']));if(!empty($p['priority']))update_post_meta($id,'report_priority',sanitize_text_field($p['priority']));$this->log_report_activity($id,'bulk_update');$updated++;}return rest_ensure_response(array('updated'=>$updated));}

    public function get_reports_timeseries($request){global $wpdb;$days=isset($request['days'])?max(1,min(90,intval($request['days']))):30;$rows=$wpdb->get_results($wpdb->prepare("SELECT DATE(post_date) d, COUNT(*) c FROM {$wpdb->posts} WHERE post_type='aukrug_report' AND post_date >= DATE_SUB(CURDATE(), INTERVAL %d DAY) GROUP BY DATE(post_date) ORDER BY d ASC",$days));return rest_ensure_response($rows?:array());}

    public function export_reports($request){if(!current_user_can('manage_options'))return new WP_Error('forbidden','Nicht erlaubt',array('status'=>403));global $wpdb;$rows=$wpdb->get_results("SELECT p.ID,p.post_title,p.post_date,pmc.meta_value category,pmp.meta_value priority,pms.meta_value status FROM {$wpdb->posts} p LEFT JOIN {$wpdb->postmeta} pmc ON p.ID=pmc.post_id AND pmc.meta_key='report_category' LEFT JOIN {$wpdb->postmeta} pmp ON p.ID=pmp.post_id AND pmp.meta_key='report_priority' LEFT JOIN {$wpdb->postmeta} pms ON p.ID=pms.post_id AND pms.meta_key='report_status' WHERE p.post_type='aukrug_report' ORDER BY p.post_date DESC LIMIT 1000",ARRAY_A);$csv="ID;Titel;Datum;Kategorie;Priorität;Status\n";foreach($rows as $r){$csv.=sprintf("%d;%s;%s;%s;%s;%s\n",$r['ID'],str_replace(["\n",";"],[' ',' '],$r['post_title']),$r['post_date'],$r['category'],$r['priority'],$r['status']);}return new WP_REST_Response($csv,200,array('Content-Type'=>'text/csv; charset=utf-8'));}
}

new Aukrug_Rest();
