<?php
/**
 * Public REST API Endpoints for Flutter App
 * These endpoints are accessible without authentication
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class Aukrug_Public_API {
    
    public function __construct() {
        add_action('rest_api_init', array($this, 'register_public_routes'));
    }

    public function register_public_routes() {
        // Places API
        register_rest_route('aukrug/v1', '/places', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_places'),
            'permission_callback' => '__return_true',
            'args' => array(
                'search' => array(
                    'type' => 'string',
                    'required' => false,
                    'description' => 'Search term for places'
                ),
                'category' => array(
                    'type' => 'string',
                    'required' => false,
                    'description' => 'Filter by category'
                ),
                'per_page' => array(
                    'type' => 'integer',
                    'required' => false,
                    'default' => 20,
                    'minimum' => 1,
                    'maximum' => 100
                ),
                'page' => array(
                    'type' => 'integer',
                    'required' => false,
                    'default' => 1,
                    'minimum' => 1
                )
            )
        ));

        register_rest_route('aukrug/v1', '/places/(?P<id>\d+)', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_place'),
            'permission_callback' => '__return_true',
            'args' => array(
                'id' => array(
                    'type' => 'integer',
                    'required' => true,
                    'description' => 'Place ID'
                )
            )
        ));

        // Events API
        register_rest_route('aukrug/v1', '/events', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_events'),
            'permission_callback' => '__return_true',
            'args' => array(
                'from_date' => array(
                    'type' => 'string',
                    'required' => false,
                    'description' => 'Filter events from this date (YYYY-MM-DD)'
                ),
                'to_date' => array(
                    'type' => 'string',
                    'required' => false,
                    'description' => 'Filter events to this date (YYYY-MM-DD)'
                ),
                'per_page' => array(
                    'type' => 'integer',
                    'required' => false,
                    'default' => 20,
                    'minimum' => 1,
                    'maximum' => 100
                ),
                'page' => array(
                    'type' => 'integer',
                    'required' => false,
                    'default' => 1,
                    'minimum' => 1
                )
            )
        ));

        register_rest_route('aukrug/v1', '/events/(?P<id>\d+)', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_event'),
            'permission_callback' => '__return_true',
            'args' => array(
                'id' => array(
                    'type' => 'integer',
                    'required' => true,
                    'description' => 'Event ID'
                )
            )
        ));

        // Public App Health Check
        register_rest_route('aukrug/v1', '/health', array(
            'methods' => 'GET',
            'callback' => array($this, 'health_check'),
            'permission_callback' => '__return_true'
        ));

        // Downloads API (public downloads only)
        register_rest_route('aukrug/v1', '/downloads', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_public_downloads'),
            'permission_callback' => '__return_true',
            'args' => array(
                'category' => array(
                    'type' => 'string',
                    'required' => false,
                    'description' => 'Filter by category'
                ),
                'per_page' => array(
                    'type' => 'integer',
                    'required' => false,
                    'default' => 20,
                    'minimum' => 1,
                    'maximum' => 100
                ),
                'page' => array(
                    'type' => 'integer',
                    'required' => false,
                    'default' => 1,
                    'minimum' => 1
                )
            )
        ));

        // Public Reports API for mobile app
        register_rest_route('aukrug/v1', '/reports', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_public_reports'),
            'permission_callback' => '__return_true',
            'args' => array(
                'status' => array(
                    'type' => 'string',
                    'required' => false,
                    'description' => 'Filter by status'
                ),
                'category' => array(
                    'type' => 'string',
                    'required' => false,
                    'description' => 'Filter by category'
                ),
                'per_page' => array(
                    'type' => 'integer',
                    'required' => false,
                    'default' => 20,
                    'minimum' => 1,
                    'maximum' => 100
                ),
                'page' => array(
                    'type' => 'integer',
                    'required' => false,
                    'default' => 1,
                    'minimum' => 1
                )
            )
        ));

        register_rest_route('aukrug/v1', '/reports', array(
            'methods' => 'POST',
            'callback' => array($this, 'create_public_report'),
            'permission_callback' => '__return_true'
        ));

        register_rest_route('aukrug/v1', '/reports/(?P<id>\d+)', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_public_report'),
            'permission_callback' => '__return_true'
        ));

        register_rest_route('aukrug/v1', '/reports/(?P<id>\d+)/comments', array(
            'methods' => array('GET', 'POST'),
            'callback' => array($this, 'handle_report_comments'),
            'permission_callback' => '__return_true'
        ));

        register_rest_route('aukrug/v1', '/reports/categories', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_report_categories'),
            'permission_callback' => '__return_true'
        ));
    }

    public function health_check($request) {
        return rest_ensure_response(array(
            'ok' => true,
            'plugin' => 'Aukrug WordPress Plugin',
            'version' => get_option('aukrug_version', '1.0.0'),
            'time' => current_time('mysql'),
            'endpoints' => array(
                'places' => '/aukrug/v1/places',
                'events' => '/aukrug/v1/events',
                'downloads' => '/aukrug/v1/downloads',
                'reports' => '/aukrug/v1/reports',
                'reports_create' => 'POST /aukrug/v1/reports',
                'reports_stats' => '/aukrug/v1/reports/stats'
            )
        ));
    }

    public function get_places($request) {
        global $wpdb;
        
        $per_page = intval($request->get_param('per_page') ?: 20);
        $page = intval($request->get_param('page') ?: 1);
        $offset = ($page - 1) * $per_page;
        
        $table_name = $wpdb->prefix . 'aukrug_discover_items';
        
        // Build WHERE clause
        $where_clauses = array();
        $where_values = array();
        
        // Add search parameter
        if ($search = $request->get_param('search')) {
            $where_clauses[] = "(title LIKE %s OR description LIKE %s)";
            $search_term = '%' . $wpdb->esc_like(sanitize_text_field($search)) . '%';
            $where_values[] = $search_term;
            $where_values[] = $search_term;
        }
        
        // Add category filter
        if ($category = $request->get_param('category')) {
            $where_clauses[] = "category = %s";
            $where_values[] = sanitize_text_field($category);
        }
        
        // Build complete WHERE clause
        $where_sql = '';
        if (!empty($where_clauses)) {
            $where_sql = 'WHERE ' . implode(' AND ', $where_clauses);
        }
        
        // Get total count
        $count_sql = "SELECT COUNT(*) FROM $table_name $where_sql";
        if (!empty($where_values)) {
            $count_sql = $wpdb->prepare($count_sql, $where_values);
        }
        $total = $wpdb->get_var($count_sql);
        
        // Get paginated results
        $sql = "SELECT * FROM $table_name $where_sql ORDER BY title ASC LIMIT %d OFFSET %d";
        $values = array_merge($where_values, array($per_page, $offset));
        $results = $wpdb->get_results($wpdb->prepare($sql, $values), ARRAY_A);
        
        $places = array();
        foreach ($results as $row) {
            $places[] = array(
                'id' => "place_" . str_pad($row['id'], 3, '0', STR_PAD_LEFT),
                'name' => $row['title'],
                'description' => $row['description'],
                'category' => $row['category'],
                'coordinates' => array(
                    'lat' => (float) $row['lat'],
                    'lng' => (float) $row['lng']
                ),
                'website' => $row['website_url'],
                'phone' => $row['phone_number'],
                'images' => !empty($row['image_url']) ? array($row['image_url']) : array(),
                'rating' => (int) $row['rating'],
                'is_featured' => (bool) $row['is_featured'],
                'opening_hours' => $row['opening_hours']
            );
        }

        $response = array(
            'data' => $places,
            'meta' => array(
                'count' => count($places),
                'total' => (int) $total,
                'page' => $page,
                'per_page' => $per_page,
                'last_modified' => current_time('mysql')
            )
        );

        return rest_ensure_response($response);
    }

    public function get_place($request) {
        $id = $request->get_param('id');
        $post = get_post($id);

        if (!$post || $post->post_type !== 'geocache' || $post->post_status !== 'publish') {
            return new WP_Error('place_not_found', 'Place not found', array('status' => 404));
        }

        $place = array(
            'id' => "place_" . str_pad($id, 3, '0', STR_PAD_LEFT),
            'name' => $post->post_title,
            'description' => $post->post_content,
            'category' => get_post_meta($id, 'category', true) ?: 'general',
            'coordinates' => array(
                'lat' => (float) get_post_meta($id, 'coords_lat', true),
                'lng' => (float) get_post_meta($id, 'coords_lng', true)
            ),
            'website' => get_post_meta($id, 'website', true),
            'phone' => get_post_meta($id, 'phone', true),
            'images' => $this->get_post_images($id),
            'last_modified' => $post->post_modified
        );

        return rest_ensure_response($place);
    }

    public function get_events($request) {
        $args = array(
            'post_type' => 'aukrug_event',
            'post_status' => 'publish',
            'posts_per_page' => $request->get_param('per_page') ?: 20,
            'paged' => $request->get_param('page') ?: 1,
            'meta_key' => 'event_date',
            'orderby' => 'meta_value',
            'order' => 'ASC'
        );

        // Add date filters
        $meta_query = array();
        
        if ($from_date = $request->get_param('from_date')) {
            $meta_query[] = array(
                'key' => 'event_date',
                'value' => sanitize_text_field($from_date),
                'compare' => '>=',
                'type' => 'DATE'
            );
        }

        if ($to_date = $request->get_param('to_date')) {
            $meta_query[] = array(
                'key' => 'event_date',
                'value' => sanitize_text_field($to_date),
                'compare' => '<=',
                'type' => 'DATE'
            );
        }

        if (!empty($meta_query)) {
            $args['meta_query'] = $meta_query;
        }

        $query = new WP_Query($args);
        $events = array();

        if ($query->have_posts()) {
            while ($query->have_posts()) {
                $query->the_post();
                $post_id = get_the_ID();
                
                $events[] = array(
                    'id' => "event_" . str_pad($post_id, 3, '0', STR_PAD_LEFT),
                    'title' => get_the_title(),
                    'description' => get_the_content(),
                    'date' => get_post_meta($post_id, 'event_date', true),
                    'time' => get_post_meta($post_id, 'event_time', true),
                    'location' => array(
                        'name' => get_post_meta($post_id, 'location_name', true),
                        'address' => get_post_meta($post_id, 'location_address', true),
                        'coordinates' => array(
                            'lat' => (float) get_post_meta($post_id, 'coords_lat', true),
                            'lng' => (float) get_post_meta($post_id, 'coords_lng', true)
                        )
                    ),
                    'organizer' => get_post_meta($post_id, 'organizer', true),
                    'website' => get_post_meta($post_id, 'website', true),
                    'images' => $this->get_post_images($post_id)
                );
            }
            wp_reset_postdata();
        }

        $response = array(
            'data' => $events,
            'meta' => array(
                'count' => count($events),
                'total' => $query->found_posts,
                'page' => (int) ($request->get_param('page') ?: 1),
                'per_page' => (int) ($request->get_param('per_page') ?: 20),
                'last_modified' => current_time('mysql')
            )
        );

        return rest_ensure_response($response);
    }

    public function get_event($request) {
        $id = $request->get_param('id');
        $post = get_post($id);

        if (!$post || $post->post_type !== 'aukrug_event' || $post->post_status !== 'publish') {
            return new WP_Error('event_not_found', 'Event not found', array('status' => 404));
        }

        $event = array(
            'id' => "event_" . str_pad($id, 3, '0', STR_PAD_LEFT),
            'title' => $post->post_title,
            'description' => $post->post_content,
            'date' => get_post_meta($id, 'event_date', true),
            'time' => get_post_meta($id, 'event_time', true),
            'location' => array(
                'name' => get_post_meta($id, 'location_name', true),
                'address' => get_post_meta($id, 'location_address', true),
                'coordinates' => array(
                    'lat' => (float) get_post_meta($id, 'coords_lat', true),
                    'lng' => (float) get_post_meta($id, 'coords_lng', true)
                )
            ),
            'organizer' => get_post_meta($id, 'organizer', true),
            'website' => get_post_meta($id, 'website', true),
            'images' => $this->get_post_images($id),
            'last_modified' => $post->post_modified
        );

        return rest_ensure_response($event);
    }

    public function get_public_downloads($request) {
        $args = array(
            'post_type' => 'aukrug_download',
            'post_status' => 'publish',
            'posts_per_page' => $request->get_param('per_page') ?: 20,
            'paged' => $request->get_param('page') ?: 1,
            'meta_query' => array(
                array(
                    'key' => 'is_public',
                    'value' => '1',
                    'compare' => '='
                )
            ),
            'orderby' => 'date',
            'order' => 'DESC'
        );

        // Add category filter
        if ($category = $request->get_param('category')) {
            $args['meta_query'][] = array(
                'key' => 'category',
                'value' => sanitize_text_field($category),
                'compare' => '='
            );
        }

        $query = new WP_Query($args);
        $downloads = array();

        if ($query->have_posts()) {
            while ($query->have_posts()) {
                $query->the_post();
                $post_id = get_the_ID();
                
                $downloads[] = array(
                    'id' => "download_" . str_pad($post_id, 3, '0', STR_PAD_LEFT),
                    'title' => get_the_title(),
                    'description' => get_the_content(),
                    'category' => get_post_meta($post_id, 'category', true) ?: 'general',
                    'file_url' => get_post_meta($post_id, 'file_url', true),
                    'file_size' => get_post_meta($post_id, 'file_size', true),
                    'download_count' => (int) get_post_meta($post_id, 'download_count', true),
                    'published_date' => get_the_date('c')
                );
            }
            wp_reset_postdata();
        }

        $response = array(
            'data' => $downloads,
            'meta' => array(
                'count' => count($downloads),
                'total' => $query->found_posts,
                'page' => (int) ($request->get_param('page') ?: 1),
                'per_page' => (int) ($request->get_param('per_page') ?: 20),
                'last_modified' => current_time('mysql')
            )
        );

        return rest_ensure_response($response);
    }

    private function get_post_images($post_id) {
        $images = array();
        
        // Get featured image
        if (has_post_thumbnail($post_id)) {
            $images[] = get_the_post_thumbnail_url($post_id, 'large');
        }

        // Get gallery images
        $gallery = get_post_meta($post_id, '_gallery_images', true);
        if ($gallery && is_array($gallery)) {
            foreach ($gallery as $image_id) {
                $image_url = wp_get_attachment_image_url($image_id, 'large');
                if ($image_url) {
                    $images[] = $image_url;
                }
            }
        }

        return $images;
    }

    /**
     * Get public reports for mobile app
     */
    public function get_public_reports($request) {
        global $wpdb;
        
        $per_page = intval($request->get_param('per_page') ?: 20);
        $page = intval($request->get_param('page') ?: 1);
        $offset = ($page - 1) * $per_page;
        
        $status = $request->get_param('status');
        $category = $request->get_param('category');
        
        // Build WHERE clause
        $where_conditions = array("p.post_type = 'aukrug_report'", "p.post_status = 'publish'");
        $where_values = array();
        
        if ($status) {
            $where_conditions[] = "meta_status.meta_value = %s";
            $where_values[] = sanitize_text_field($status);
        }
        
        if ($category) {
            $where_conditions[] = "meta_category.meta_value = %s";
            $where_values[] = sanitize_text_field($category);
        }
        
        $where_clause = implode(' AND ', $where_conditions);
        
        // Get reports with metadata
        $sql = "
            SELECT DISTINCT 
                p.ID,
                p.post_title,
                p.post_content,
                p.post_date,
                COALESCE(meta_status.meta_value, 'open') as status,
                COALESCE(meta_category.meta_value, 'sonstiges') as category,
                COALESCE(meta_priority.meta_value, 'normal') as priority,
                meta_address.meta_value as address,
                meta_contact_name.meta_value as contact_name
            FROM {$wpdb->posts} p
            LEFT JOIN {$wpdb->postmeta} meta_status ON p.ID = meta_status.post_id AND meta_status.meta_key = 'report_status'
            LEFT JOIN {$wpdb->postmeta} meta_category ON p.ID = meta_category.post_id AND meta_category.meta_key = 'report_category'
            LEFT JOIN {$wpdb->postmeta} meta_priority ON p.ID = meta_priority.post_id AND meta_priority.meta_key = 'report_priority'
            LEFT JOIN {$wpdb->postmeta} meta_address ON p.ID = meta_address.post_id AND meta_address.meta_key = 'report_address'
            LEFT JOIN {$wpdb->postmeta} meta_contact_name ON p.ID = meta_contact_name.post_id AND meta_contact_name.meta_key = 'report_contact_name'
            WHERE {$where_clause}
            ORDER BY p.post_date DESC
            LIMIT %d OFFSET %d
        ";
        
        $where_values[] = $per_page;
        $where_values[] = $offset;
        
        $results = $wpdb->get_results($wpdb->prepare($sql, $where_values), ARRAY_A);
        
        // Format results
        $reports = array();
        foreach ($results as $row) {
            $reports[] = array(
                'id' => intval($row['ID']),
                'title' => $row['post_title'],
                'description' => $row['post_content'],
                'status' => $row['status'],
                'category' => $row['category'],
                'priority' => $row['priority'],
                'address' => $row['address'],
                'created_at' => $row['post_date'],
                'reporter_name' => $row['contact_name'] ?: 'Anonym'
            );
        }
        
        // Get total count
        $count_sql = "
            SELECT COUNT(DISTINCT p.ID)
            FROM {$wpdb->posts} p
            LEFT JOIN {$wpdb->postmeta} meta_status ON p.ID = meta_status.post_id AND meta_status.meta_key = 'report_status'
            LEFT JOIN {$wpdb->postmeta} meta_category ON p.ID = meta_category.post_id AND meta_category.meta_key = 'report_category'
            WHERE {$where_clause}
        ";
        
        $count_values = array_slice($where_values, 0, -2); // Remove LIMIT and OFFSET
        $total = $wpdb->get_var($wpdb->prepare($count_sql, $count_values));
        
        return rest_ensure_response(array(
            'data' => $reports,
            'pagination' => array(
                'page' => $page,
                'per_page' => $per_page,
                'total' => intval($total),
                'total_pages' => ceil($total / $per_page)
            ),
            'last_modified' => current_time('mysql')
        ));
    }

    /**
     * Create new public report
     */
    public function create_public_report($request) {
        $params = $request->get_json_params();
        
        // Rate limiting check
        $ip = $_SERVER['REMOTE_ADDR'];
        $rate_key = 'aukrug_api_report_rate_' . md5($ip);
        $recent_reports = get_transient($rate_key) ?: 0;
        
        if ($recent_reports >= 3) {
            return new WP_Error('rate_limit', 'Zu viele Meldungen. Bitte warten Sie 5 Minuten.', array('status' => 429));
        }
        
        // Validate required fields
        if (empty($params['title']) || empty($params['description']) || empty($params['category'])) {
            return new WP_Error('missing_fields', 'Titel, Beschreibung und Kategorie sind erforderlich', array('status' => 400));
        }
        
        // Create post
        $post_data = array(
            'post_type' => 'aukrug_report',
            'post_title' => sanitize_text_field($params['title']),
            'post_content' => wp_kses_post($params['description']),
            'post_status' => 'publish',
            'post_author' => 0
        );
        
        $report_id = wp_insert_post($post_data);
        
        // Debug: Create a temporary log file
        $debug_log = '/tmp/aukrug_api_debug.log';
        $debug_info = array(
            'timestamp' => current_time('mysql'),
            'wp_insert_post_result' => $report_id,
            'is_wp_error' => is_wp_error($report_id),
            'post_data' => $post_data,
            'params' => $params
        );
        
        if (is_wp_error($report_id)) {
            $debug_info['error_message'] = $report_id->get_error_message();
            $debug_info['error_data'] = $report_id->get_error_data();
        } else {
            // Try to get the created post to verify it exists
            $created_post = get_post($report_id);
            $debug_info['created_post'] = $created_post ? array(
                'ID' => $created_post->ID,
                'post_title' => $created_post->post_title,
                'post_type' => $created_post->post_type,
                'post_status' => $created_post->post_status
            ) : 'POST_NOT_FOUND';
        }
        
        file_put_contents($debug_log, print_r($debug_info, true) . "\n\n", FILE_APPEND);
        
        if (is_wp_error($report_id)) {
            return new WP_Error('create_failed', 'Fehler beim Erstellen der Meldung: ' . $report_id->get_error_message(), array('status' => 500));
        }
        
        // Additional check: verify the post was actually created
        $created_post = get_post($report_id);
        if (!$created_post || $created_post->post_type !== 'aukrug_report') {
            return new WP_Error('create_failed', 'Post wurde nicht korrekt erstellt', array('status' => 500));
        }
        
        // Add metadata
        update_post_meta($report_id, 'report_category', sanitize_text_field($params['category']));
        update_post_meta($report_id, 'report_priority', sanitize_text_field($params['priority'] ?: 'normal'));
        update_post_meta($report_id, 'report_status', 'open');
        
        if (!empty($params['address'])) {
            update_post_meta($report_id, 'report_address', sanitize_text_field($params['address']));
        }
        
        if (!empty($params['contact_name'])) {
            update_post_meta($report_id, 'report_contact_name', sanitize_text_field($params['contact_name']));
        }
        
        if (!empty($params['contact_email'])) {
            update_post_meta($report_id, 'report_contact_email', sanitize_email($params['contact_email']));
        }
        
        if (!empty($params['latitude']) && !empty($params['longitude'])) {
            update_post_meta($report_id, 'report_latitude', floatval($params['latitude']));
            update_post_meta($report_id, 'report_longitude', floatval($params['longitude']));
        }
        
        update_post_meta($report_id, 'report_ip', $ip);
        
        // Update rate limiting
        set_transient($rate_key, $recent_reports + 1, 300); // 5 minutes
        
        // Log activity
        global $wpdb;
        $activity_table = $wpdb->prefix . 'aukrug_report_activity';
        if ($wpdb->get_var("SHOW TABLES LIKE '$activity_table'") == $activity_table) {
            $wpdb->insert($activity_table, array(
                'report_id' => $report_id,
                'action' => 'create_mobile',
                'actor_role' => 'mobile_user',
                'meta' => wp_json_encode(array('ip' => $ip, 'user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? '')),
                'created_at' => current_time('mysql')
            ));
        }
        
        // Trigger notification if available
        if (class_exists('Aukrug_Notifications')) {
            Aukrug_Notifications::trigger_report_created($report_id, array(
                'title' => $params['title'],
                'description' => $params['description'],
                'category' => $params['category'],
                'priority' => $params['priority'] ?: 'normal',
                'address' => $params['address'] ?? ''
            ));
        }
        
        return rest_ensure_response(array(
            'success' => true,
            'report_id' => $report_id,
            'message' => 'Meldung erfolgreich erstellt',
            'data' => array(
                'id' => $report_id,
                'title' => $params['title'],
                'status' => 'open',
                'created_at' => current_time('mysql')
            )
        ));
    }

    /**
     * Get single public report
     */
    public function get_public_report($request) {
        $report_id = intval($request['id']);
        $post = get_post($report_id);
        
        if (!$post || $post->post_type !== 'aukrug_report') {
            return new WP_Error('report_not_found', 'Meldung nicht gefunden', array('status' => 404));
        }
        
        // Get metadata
        $status = get_post_meta($report_id, 'report_status', true) ?: 'open';
        $category = get_post_meta($report_id, 'report_category', true);
        $priority = get_post_meta($report_id, 'report_priority', true);
        $address = get_post_meta($report_id, 'report_address', true);
        $contact_name = get_post_meta($report_id, 'report_contact_name', true);
        $latitude = get_post_meta($report_id, 'report_latitude', true);
        $longitude = get_post_meta($report_id, 'report_longitude', true);
        
        // Get public comments
        global $wpdb;
        $comments_table = $wpdb->prefix . 'aukrug_report_comments';
        $comments = array();
        
        if ($wpdb->get_var("SHOW TABLES LIKE '$comments_table'") == $comments_table) {
            $comments_data = $wpdb->get_results($wpdb->prepare(
                "SELECT * FROM $comments_table WHERE report_id = %d AND visibility = 'public' ORDER BY created_at ASC",
                $report_id
            ));
            
            foreach ($comments_data as $comment) {
                $comments[] = array(
                    'id' => intval($comment->id),
                    'author_name' => $comment->author_name,
                    'author_role' => $comment->author_role,
                    'message' => $comment->message,
                    'created_at' => $comment->created_at
                );
            }
        }
        
        $report = array(
            'id' => $report_id,
            'title' => $post->post_title,
            'description' => $post->post_content,
            'status' => $status,
            'category' => $category,
            'priority' => $priority,
            'address' => $address,
            'reporter_name' => $contact_name ?: 'Anonym',
            'created_at' => $post->post_date,
            'updated_at' => $post->post_modified,
            'comments' => $comments
        );
        
        if ($latitude && $longitude) {
            $report['location'] = array(
                'latitude' => floatval($latitude),
                'longitude' => floatval($longitude)
            );
        }
        
        return rest_ensure_response($report);
    }

    /**
     * Handle report comments (GET and POST)
     */
    public function handle_report_comments($request) {
        $report_id = intval($request['id']);
        
        if ($request->get_method() === 'GET') {
            return $this->get_report_comments($report_id);
        } else {
            return $this->add_report_comment($report_id, $request);
        }
    }
    
    private function get_report_comments($report_id) {
        global $wpdb;
        $comments_table = $wpdb->prefix . 'aukrug_report_comments';
        
        if ($wpdb->get_var("SHOW TABLES LIKE '$comments_table'") != $comments_table) {
            return rest_ensure_response(array());
        }
        
        $comments = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $comments_table WHERE report_id = %d AND visibility = 'public' ORDER BY created_at ASC",
            $report_id
        ));
        
        $formatted_comments = array();
        foreach ($comments as $comment) {
            $formatted_comments[] = array(
                'id' => intval($comment->id),
                'author_name' => $comment->author_name,
                'author_role' => $comment->author_role,
                'message' => $comment->message,
                'created_at' => $comment->created_at
            );
        }
        
        return rest_ensure_response($formatted_comments);
    }
    
    private function add_report_comment($report_id, $request) {
        $params = $request->get_json_params();
        
        // Rate limiting
        $ip = $_SERVER['REMOTE_ADDR'];
        $rate_key = 'aukrug_api_comment_rate_' . md5($ip);
        $recent_comments = get_transient($rate_key) ?: 0;
        
        if ($recent_comments >= 5) {
            return new WP_Error('rate_limit', 'Zu viele Kommentare. Bitte warten Sie.', array('status' => 429));
        }
        
        // Validate
        if (empty($params['message'])) {
            return new WP_Error('missing_message', 'Nachricht ist erforderlich', array('status' => 400));
        }
        
        // Add comment
        global $wpdb;
        $comments_table = $wpdb->prefix . 'aukrug_report_comments';
        
        if ($wpdb->get_var("SHOW TABLES LIKE '$comments_table'") != $comments_table) {
            return new WP_Error('db_error', 'Kommentar-System nicht verfügbar', array('status' => 500));
        }
        
        $result = $wpdb->insert($comments_table, array(
            'report_id' => $report_id,
            'author_name' => sanitize_text_field($params['author_name'] ?: 'Anonym'),
            'author_email' => sanitize_email($params['author_email'] ?? ''),
            'author_role' => 'mobile_user',
            'visibility' => 'public',
            'message' => wp_kses_post($params['message']),
            'created_at' => current_time('mysql')
        ));
        
        if (!$result) {
            return new WP_Error('db_error', 'Fehler beim Speichern des Kommentars', array('status' => 500));
        }
        
        // Update rate limiting
        set_transient($rate_key, $recent_comments + 1, 300);
        
        return rest_ensure_response(array(
            'success' => true,
            'message' => 'Kommentar hinzugefügt',
            'comment_id' => $wpdb->insert_id
        ));
    }

    /**
     * Get available report categories
     */
    public function get_report_categories($request) {
        $categories = array(
            array(
                'key' => 'strasse',
                'label' => 'Straße & Verkehr',
                'icon' => 'road',
                'description' => 'Schlaglöcher, defekte Schilder, Markierungen'
            ),
            array(
                'key' => 'beleuchtung',
                'label' => 'Beleuchtung',
                'icon' => 'lightbulb',
                'description' => 'Defekte Straßenlaternen, dunkle Bereiche'
            ),
            array(
                'key' => 'abfall',
                'label' => 'Abfall & Entsorgung',
                'icon' => 'trash',
                'description' => 'Wilde Müllablagerung, volle Container'
            ),
            array(
                'key' => 'vandalismus',
                'label' => 'Vandalismus',
                'icon' => 'warning',
                'description' => 'Sachschäden an öffentlichem Eigentum'
            ),
            array(
                'key' => 'gruenflaeche',
                'label' => 'Grünflächen & Parks',
                'icon' => 'tree',
                'description' => 'Pflege von Parks, umgestürzte Bäume'
            ),
            array(
                'key' => 'wasser',
                'label' => 'Wasser & Abwasser',
                'icon' => 'water',
                'description' => 'Wasserrohrbrüche, verstopfte Gullys'
            ),
            array(
                'key' => 'laerm',
                'label' => 'Lärm & Ruhestörung',
                'icon' => 'volume',
                'description' => 'Lärmbelästigung, Ruhestörungen'
            ),
            array(
                'key' => 'spielplatz',
                'label' => 'Spielplätze',
                'icon' => 'playground',
                'description' => 'Defekte Geräte, Sicherheitsprobleme'
            ),
            array(
                'key' => 'umwelt',
                'label' => 'Umwelt & Natur',
                'icon' => 'leaf',
                'description' => 'Umweltverschmutzung, Naturschutz'
            ),
            array(
                'key' => 'winterdienst',
                'label' => 'Winterdienst',
                'icon' => 'snow',
                'description' => 'Räumung, Streudienst'
            ),
            array(
                'key' => 'gebaeude',
                'label' => 'Öffentliche Gebäude',
                'icon' => 'building',
                'description' => 'Schäden an Gemeindegebäuden'
            ),
            array(
                'key' => 'sonstiges',
                'label' => 'Sonstiges',
                'icon' => 'more',
                'description' => 'Alle anderen Anliegen'
            )
        );
        
        return rest_ensure_response($categories);
    }
}
