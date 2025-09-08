<?php
/**
 * Marketplace functionality for Aukrug Plugin
 * Handles listings, verification, moderation
 */

class Aukrug_Marketplace {
    
    public function __construct() {
        add_action('init', array($this, 'register_post_types'));
        add_action('init', array($this, 'register_taxonomies'));
        add_action('init', array($this, 'register_meta_fields'));
        add_action('rest_api_init', array($this, 'register_rest_routes'));
        add_action('wp_enqueue_scripts', array($this, 'enqueue_scripts'));
        
        // Hooks for community integration
        add_action('transition_post_status', array($this, 'on_listing_published'), 10, 3);
        
        // Rate limiting hooks
        add_action('wp_login', array($this, 'reset_daily_limits'));
    }

    /**
     * Register Custom Post Type: market_listing
     */
    public function register_post_types() {
        $labels = array(
            'name' => 'Marketplace Listings',
            'singular_name' => 'Listing',
            'menu_name' => 'Marketplace',
            'add_new' => 'Add Listing',
            'add_new_item' => 'Add New Listing',
            'edit_item' => 'Edit Listing',
            'new_item' => 'New Listing',
            'view_item' => 'View Listing',
            'search_items' => 'Search Listings',
            'not_found' => 'No listings found',
            'not_found_in_trash' => 'No listings found in trash'
        );

        $args = array(
            'labels' => $labels,
            'public' => true,
            'has_archive' => true,
            'supports' => array('title', 'editor', 'author', 'thumbnail', 'custom-fields'),
            'menu_icon' => 'dashicons-store',
            'capability_type' => 'post',
            'map_meta_cap' => true,
            'capabilities' => array(
                'read' => 'read_marketplace',
                'edit_posts' => 'edit_marketplace',
                'edit_others_posts' => 'moderate_marketplace',
                'publish_posts' => 'edit_marketplace',
                'read_private_posts' => 'moderate_marketplace',
            ),
            'show_in_rest' => true,
            'rest_base' => 'market_listings',
        );

        register_post_type('market_listing', $args);

        // Register market_report CPT for abuse reports
        register_post_type('market_report', array(
            'labels' => array(
                'name' => 'Reports',
                'singular_name' => 'Report',
            ),
            'public' => false,
            'supports' => array('title', 'editor', 'custom-fields'),
            'capability_type' => 'post',
            'map_meta_cap' => true,
        ));
    }

    /**
     * Register taxonomy: market_category
     */
    public function register_taxonomies() {
        register_taxonomy('market_category', 'market_listing', array(
            'labels' => array(
                'name' => 'Categories',
                'singular_name' => 'Category',
                'menu_name' => 'Categories',
            ),
            'hierarchical' => true,
            'public' => true,
            'show_in_rest' => true,
            'rest_base' => 'market_categories',
        ));

        // Add default categories
        if (!term_exists('Electronics', 'market_category')) {
            wp_insert_term('Electronics', 'market_category');
            wp_insert_term('Furniture', 'market_category');
            wp_insert_term('Vehicles', 'market_category');
            wp_insert_term('Services', 'market_category');
            wp_insert_term('Other', 'market_category');
        }
    }

    /**
     * Register meta fields for market_listing
     */
    public function register_meta_fields() {
        register_post_meta('market_listing', 'price', array(
            'type' => 'number',
            'single' => true,
            'show_in_rest' => true,
            'sanitize_callback' => 'floatval',
        ));

        register_post_meta('market_listing', 'currency', array(
            'type' => 'string',
            'single' => true,
            'default' => 'EUR',
            'show_in_rest' => true,
            'sanitize_callback' => 'sanitize_text_field',
        ));

        register_post_meta('market_listing', 'location_area', array(
            'type' => 'string',
            'single' => true,
            'show_in_rest' => true,
            'sanitize_callback' => 'sanitize_text_field',
        ));

        register_post_meta('market_listing', 'images', array(
            'type' => 'array',
            'single' => true,
            'show_in_rest' => array(
                'schema' => array(
                    'type' => 'array',
                    'items' => array('type' => 'integer'),
                ),
            ),
        ));

        register_post_meta('market_listing', 'status', array(
            'type' => 'string',
            'single' => true,
            'default' => 'active',
            'show_in_rest' => true,
            'sanitize_callback' => array($this, 'sanitize_listing_status'),
        ));

        register_post_meta('market_listing', 'contact_via_messenger', array(
            'type' => 'boolean',
            'single' => true,
            'default' => true,
            'show_in_rest' => true,
        ));
    }

    /**
     * Sanitize listing status
     */
    public function sanitize_listing_status($status) {
        $allowed = array('active', 'paused', 'sold');
        return in_array($status, $allowed) ? $status : 'active';
    }

    /**
     * Register REST API routes
     */
    public function register_rest_routes() {
        // Main listings endpoints
        register_rest_route('aukrug/v1', '/market/listings', array(
            array(
                'methods' => 'GET',
                'callback' => array($this, 'get_listings'),
                'permission_callback' => '__return_true',
                'args' => array(
                    'search' => array('type' => 'string'),
                    'category' => array('type' => 'string'),
                    'price_min' => array('type' => 'number'),
                    'price_max' => array('type' => 'number'),
                    'area' => array('type' => 'string'),
                    'status' => array('type' => 'string', 'default' => 'active'),
                    'page' => array('type' => 'integer', 'default' => 1),
                    'per_page' => array('type' => 'integer', 'default' => 20),
                    'sort' => array('type' => 'string', 'default' => 'date'),
                ),
            ),
            array(
                'methods' => 'POST',
                'callback' => array($this, 'create_listing'),
                'permission_callback' => array($this, 'can_create_listing'),
            ),
        ));

        register_rest_route('aukrug/v1', '/market/listings/(?P<id>\d+)', array(
            array(
                'methods' => 'GET',
                'callback' => array($this, 'get_listing'),
                'permission_callback' => '__return_true',
            ),
            array(
                'methods' => 'PUT',
                'callback' => array($this, 'update_listing'),
                'permission_callback' => array($this, 'can_edit_listing'),
            ),
            array(
                'methods' => 'DELETE',
                'callback' => array($this, 'delete_listing'),
                'permission_callback' => array($this, 'can_delete_listing'),
            ),
        ));

        register_rest_route('aukrug/v1', '/market/listings/(?P<id>\d+)/status', array(
            'methods' => 'POST',
            'callback' => array($this, 'update_listing_status'),
            'permission_callback' => array($this, 'can_edit_listing'),
            'args' => array(
                'status' => array('required' => true, 'type' => 'string'),
            ),
        ));

        register_rest_route('aukrug/v1', '/market/listings/(?P<id>\d+)/report', array(
            'methods' => 'POST',
            'callback' => array($this, 'report_listing'),
            'permission_callback' => 'is_user_logged_in',
            'args' => array(
                'reason' => array('required' => true, 'type' => 'string'),
            ),
        ));

        // Favorites
        register_rest_route('aukrug/v1', '/market/favorites/(?P<id>\d+)', array(
            'methods' => 'POST',
            'callback' => array($this, 'toggle_favorite'),
            'permission_callback' => 'is_user_logged_in',
        ));

        register_rest_route('aukrug/v1', '/market/favorites', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_favorites'),
            'permission_callback' => 'is_user_logged_in',
        ));

        // Verification endpoints
        register_rest_route('aukrug/v1', '/verification/request', array(
            'methods' => 'POST',
            'callback' => array($this, 'request_verification'),
            'permission_callback' => 'is_user_logged_in',
            'args' => array(
                'type' => array('required' => true, 'type' => 'string'), // resident|business
                'name' => array('required' => true, 'type' => 'string'),
                'address' => array('required' => true, 'type' => 'string'),
            ),
        ));

        register_rest_route('aukrug/v1', '/verification/status', array(
            'methods' => 'GET',
            'callback' => array($this, 'get_verification_status'),
            'permission_callback' => 'is_user_logged_in',
        ));

        // Image upload
        register_rest_route('aukrug/v1', '/market/upload', array(
            'methods' => 'POST',
            'callback' => array($this, 'upload_image'),
            'permission_callback' => 'is_user_logged_in',
        ));
    }

    /**
     * Check if user can create listings (must be verified)
     */
    public function can_create_listing($request) {
        if (!is_user_logged_in()) {
            return false;
        }

        $user_id = get_current_user_id();
        
        // Check rate limits
        if (!$this->check_rate_limit($user_id, 'create', 5)) {
            return new WP_Error('rate_limit', 'Daily creation limit reached', array('status' => 429));
        }

        // Check verification
        $verified_resident = get_user_meta($user_id, 'au_verified_resident', true);
        $verified_business = get_user_meta($user_id, 'au_verified_business', true);
        
        if (!$verified_resident && !$verified_business) {
            return new WP_Error('not_verified', 'Verification required to create listings', array('status' => 403));
        }

        return true;
    }

    /**
     * Check if user can edit listing
     */
    public function can_edit_listing($request) {
        if (!is_user_logged_in()) {
            return false;
        }

        $post_id = $request['id'];
        $post = get_post($post_id);
        
        if (!$post || $post->post_type !== 'market_listing') {
            return false;
        }

        $user_id = get_current_user_id();
        
        // Check rate limits
        if (!$this->check_rate_limit($user_id, 'edit', 20)) {
            return new WP_Error('rate_limit', 'Daily edit limit reached', array('status' => 429));
        }

        // Owner or moderator
        return $post->post_author == $user_id || current_user_can('moderate_marketplace');
    }

    /**
     * Check if user can delete listing
     */
    public function can_delete_listing($request) {
        return $this->can_edit_listing($request);
    }

    /**
     * Check rate limits
     */
    private function check_rate_limit($user_id, $action, $limit) {
        $key = "au_rate_limit_{$action}_" . date('Y-m-d');
        $current = get_user_meta($user_id, $key, true) ?: 0;
        
        if ($current >= $limit) {
            return false;
        }
        
        update_user_meta($user_id, $key, $current + 1);
        return true;
    }

    /**
     * Reset daily limits on login
     */
    public function reset_daily_limits($user_login) {
        $user = get_user_by('login', $user_login);
        if ($user) {
            delete_user_meta($user->ID, "au_rate_limit_create_" . date('Y-m-d', strtotime('-1 day')));
            delete_user_meta($user->ID, "au_rate_limit_edit_" . date('Y-m-d', strtotime('-1 day')));
        }
    }

    /**
     * Get listings with filters
     */
    public function get_listings($request) {
        $args = array(
            'post_type' => 'market_listing',
            'post_status' => 'publish',
            'posts_per_page' => $request['per_page'],
            'paged' => $request['page'],
            'meta_query' => array(),
        );

        // Filter by status
        if ($request['status']) {
            $args['meta_query'][] = array(
                'key' => 'status',
                'value' => $request['status'],
            );
        }

        // Search
        if ($request['search']) {
            $args['s'] = sanitize_text_field($request['search']);
        }

        // Category filter
        if ($request['category']) {
            $args['tax_query'] = array(
                array(
                    'taxonomy' => 'market_category',
                    'field' => 'slug',
                    'terms' => sanitize_text_field($request['category']),
                ),
            );
        }

        // Price range
        if ($request['price_min'] || $request['price_max']) {
            $price_query = array('key' => 'price', 'type' => 'NUMERIC');
            
            if ($request['price_min'] && $request['price_max']) {
                $price_query['value'] = array($request['price_min'], $request['price_max']);
                $price_query['compare'] = 'BETWEEN';
            } elseif ($request['price_min']) {
                $price_query['value'] = $request['price_min'];
                $price_query['compare'] = '>=';
            } elseif ($request['price_max']) {
                $price_query['value'] = $request['price_max'];
                $price_query['compare'] = '<=';
            }
            
            $args['meta_query'][] = $price_query;
        }

        // Area filter
        if ($request['area']) {
            $args['meta_query'][] = array(
                'key' => 'location_area',
                'value' => sanitize_text_field($request['area']),
                'compare' => 'LIKE',
            );
        }

        // Sorting
        switch ($request['sort']) {
            case 'price_asc':
                $args['meta_key'] = 'price';
                $args['orderby'] = 'meta_value_num';
                $args['order'] = 'ASC';
                break;
            case 'price_desc':
                $args['meta_key'] = 'price';
                $args['orderby'] = 'meta_value_num';
                $args['order'] = 'DESC';
                break;
            default:
                $args['orderby'] = 'date';
                $args['order'] = 'DESC';
        }

        $query = new WP_Query($args);
        $listings = array();

        foreach ($query->posts as $post) {
            $listings[] = $this->format_listing($post);
        }

        return new WP_REST_Response(array(
            'listings' => $listings,
            'total' => $query->found_posts,
            'pages' => $query->max_num_pages,
            'page' => $request['page'],
        ));
    }

    /**
     * Get single listing
     */
    public function get_listing($request) {
        $post = get_post($request['id']);
        
        if (!$post || $post->post_type !== 'market_listing') {
            return new WP_Error('not_found', 'Listing not found', array('status' => 404));
        }

        return new WP_REST_Response($this->format_listing($post));
    }

    /**
     * Format listing for API response
     */
    private function format_listing($post) {
        $images = get_post_meta($post->ID, 'images', true) ?: array();
        $image_urls = array();
        
        foreach ($images as $image_id) {
            $url = wp_get_attachment_image_url($image_id, 'full');
            if ($url) {
                $image_urls[] = array(
                    'id' => $image_id,
                    'url' => $url,
                    'thumbnail' => wp_get_attachment_image_url($image_id, 'thumbnail'),
                );
            }
        }

        $categories = wp_get_post_terms($post->ID, 'market_category');
        $category_names = array_map(function($cat) {
            return $cat->name;
        }, $categories);

        return array(
            'id' => $post->ID,
            'title' => $post->post_title,
            'description' => $post->post_content,
            'price' => (float) get_post_meta($post->ID, 'price', true),
            'currency' => get_post_meta($post->ID, 'currency', true) ?: 'EUR',
            'location_area' => get_post_meta($post->ID, 'location_area', true),
            'images' => $image_urls,
            'status' => get_post_meta($post->ID, 'status', true) ?: 'active',
            'contact_via_messenger' => (bool) get_post_meta($post->ID, 'contact_via_messenger', true),
            'categories' => $category_names,
            'author_id' => $post->post_author,
            'created_at' => $post->post_date_gmt,
            'updated_at' => $post->post_modified_gmt,
        );
    }

    /**
     * Create new listing
     */
    public function create_listing($request) {
        $title = sanitize_text_field($request['title']);
        $content = wp_kses_post($request['description']);
        
        $post_data = array(
            'post_type' => 'market_listing',
            'post_title' => $title,
            'post_content' => $content,
            'post_status' => 'publish',
            'post_author' => get_current_user_id(),
        );

        $post_id = wp_insert_post($post_data);
        
        if (is_wp_error($post_id)) {
            return $post_id;
        }

        // Update meta fields
        if (isset($request['price'])) {
            update_post_meta($post_id, 'price', floatval($request['price']));
        }
        
        if (isset($request['currency'])) {
            update_post_meta($post_id, 'currency', sanitize_text_field($request['currency']));
        }
        
        if (isset($request['location_area'])) {
            update_post_meta($post_id, 'location_area', sanitize_text_field($request['location_area']));
        }
        
        if (isset($request['images']) && is_array($request['images'])) {
            update_post_meta($post_id, 'images', array_map('intval', $request['images']));
        }
        
        if (isset($request['contact_via_messenger'])) {
            update_post_meta($post_id, 'contact_via_messenger', (bool) $request['contact_via_messenger']);
        }

        // Set categories
        if (isset($request['categories']) && is_array($request['categories'])) {
            $category_ids = array();
            foreach ($request['categories'] as $category_name) {
                $term = get_term_by('name', $category_name, 'market_category');
                if ($term) {
                    $category_ids[] = $term->term_id;
                }
            }
            wp_set_post_terms($post_id, $category_ids, 'market_category');
        }

        $post = get_post($post_id);
        return new WP_REST_Response($this->format_listing($post), 201);
    }

    /**
     * Update listing
     */
    public function update_listing($request) {
        $post_id = $request['id'];
        $post = get_post($post_id);
        
        if (!$post || $post->post_type !== 'market_listing') {
            return new WP_Error('not_found', 'Listing not found', array('status' => 404));
        }

        $post_data = array('ID' => $post_id);
        
        if (isset($request['title'])) {
            $post_data['post_title'] = sanitize_text_field($request['title']);
        }
        
        if (isset($request['description'])) {
            $post_data['post_content'] = wp_kses_post($request['description']);
        }

        wp_update_post($post_data);

        // Update meta fields (same as create_listing)
        if (isset($request['price'])) {
            update_post_meta($post_id, 'price', floatval($request['price']));
        }
        
        // ... (other meta field updates same as create_listing)

        $updated_post = get_post($post_id);
        return new WP_REST_Response($this->format_listing($updated_post));
    }

    /**
     * Delete listing
     */
    public function delete_listing($request) {
        $post_id = $request['id'];
        $post = get_post($post_id);
        
        if (!$post || $post->post_type !== 'market_listing') {
            return new WP_Error('not_found', 'Listing not found', array('status' => 404));
        }

        $deleted = wp_delete_post($post_id, true);
        
        if (!$deleted) {
            return new WP_Error('delete_failed', 'Failed to delete listing', array('status' => 500));
        }

        return new WP_REST_Response(array('deleted' => true));
    }

    /**
     * Update listing status
     */
    public function update_listing_status($request) {
        $post_id = $request['id'];
        $status = $this->sanitize_listing_status($request['status']);
        
        update_post_meta($post_id, 'status', $status);
        
        return new WP_REST_Response(array('status' => $status));
    }

    /**
     * Report listing
     */
    public function report_listing($request) {
        $listing_id = $request['id'];
        $reason = sanitize_textarea_field($request['reason']);
        $reporter_id = get_current_user_id();

        $report_data = array(
            'post_type' => 'market_report',
            'post_title' => "Report for Listing #{$listing_id}",
            'post_content' => $reason,
            'post_status' => 'private',
            'meta_input' => array(
                'listing_id' => $listing_id,
                'reporter_id' => $reporter_id,
            ),
        );

        $report_id = wp_insert_post($report_data);
        
        if (is_wp_error($report_id)) {
            return $report_id;
        }

        // Email notification to admin (if configured)
        $admin_email = get_option('admin_email');
        if ($admin_email) {
            wp_mail(
                $admin_email,
                'Marketplace Listing Reported',
                "A listing has been reported. Listing ID: {$listing_id}, Reason: {$reason}"
            );
        }

        return new WP_REST_Response(array('reported' => true));
    }

    /**
     * Toggle favorite listing
     */
    public function toggle_favorite($request) {
        $listing_id = $request['id'];
        $user_id = get_current_user_id();
        
        $favorites = get_user_meta($user_id, 'au_fav_listings', true) ?: array();
        
        if (in_array($listing_id, $favorites)) {
            $favorites = array_diff($favorites, array($listing_id));
            $is_favorite = false;
        } else {
            $favorites[] = $listing_id;
            $is_favorite = true;
        }
        
        update_user_meta($user_id, 'au_fav_listings', $favorites);
        
        return new WP_REST_Response(array(
            'listing_id' => $listing_id,
            'is_favorite' => $is_favorite,
        ));
    }

    /**
     * Get user's favorite listings
     */
    public function get_favorites($request) {
        $user_id = get_current_user_id();
        $favorite_ids = get_user_meta($user_id, 'au_fav_listings', true) ?: array();
        
        if (empty($favorite_ids)) {
            return new WP_REST_Response(array('favorites' => array()));
        }

        $args = array(
            'post_type' => 'market_listing',
            'post_status' => 'publish',
            'post__in' => $favorite_ids,
            'posts_per_page' => -1,
        );

        $query = new WP_Query($args);
        $favorites = array();

        foreach ($query->posts as $post) {
            $favorites[] = $this->format_listing($post);
        }

        return new WP_REST_Response(array('favorites' => $favorites));
    }

    /**
     * Request verification
     */
    public function request_verification($request) {
        $user_id = get_current_user_id();
        $type = sanitize_text_field($request['type']); // resident|business
        $name = sanitize_text_field($request['name']);
        $address = sanitize_text_field($request['address']);

        // Store verification request
        update_user_meta($user_id, 'au_verification_pending', array(
            'type' => $type,
            'name' => $name,
            'address' => $address,
            'requested_at' => current_time('mysql'),
        ));

        // Email notification to admin
        $admin_email = get_option('admin_email');
        if ($admin_email) {
            wp_mail(
                $admin_email,
                'New Verification Request',
                "User {$name} has requested {$type} verification.\nAddress: {$address}"
            );
        }

        return new WP_REST_Response(array(
            'status' => 'pending',
            'message' => 'Verification request submitted',
        ));
    }

    /**
     * Get verification status
     */
    public function get_verification_status($request) {
        $user_id = get_current_user_id();
        
        $verified_resident = get_user_meta($user_id, 'au_verified_resident', true);
        $verified_business = get_user_meta($user_id, 'au_verified_business', true);
        $pending_request = get_user_meta($user_id, 'au_verification_pending', true);
        
        $status = 'none';
        if ($verified_resident || $verified_business) {
            $status = 'verified';
        } elseif ($pending_request) {
            $status = 'pending';
        }

        return new WP_REST_Response(array(
            'status' => $status,
            'verified_resident' => (bool) $verified_resident,
            'verified_business' => (bool) $verified_business,
            'pending_request' => $pending_request,
        ));
    }

    /**
     * Upload image with EXIF stripping
     */
    public function upload_image($request) {
        if (!isset($_FILES['image'])) {
            return new WP_Error('no_file', 'No image file provided', array('status' => 400));
        }

        require_once(ABSPATH . 'wp-admin/includes/image.php');
        require_once(ABSPATH . 'wp-admin/includes/file.php');
        require_once(ABSPATH . 'wp-admin/includes/media.php');

        // Handle the upload
        $attachment_id = media_handle_upload('image', 0);
        
        if (is_wp_error($attachment_id)) {
            return $attachment_id;
        }

        // Strip EXIF data
        $this->strip_exif($attachment_id);

        $url = wp_get_attachment_url($attachment_id);
        
        return new WP_REST_Response(array(
            'id' => $attachment_id,
            'url' => $url,
            'thumbnail' => wp_get_attachment_image_url($attachment_id, 'thumbnail'),
        ));
    }

    /**
     * Strip EXIF data from uploaded image
     */
    private function strip_exif($attachment_id) {
        $file_path = get_attached_file($attachment_id);
        
        if (!$file_path) {
            return;
        }

        $editor = wp_get_image_editor($file_path);
        
        if (is_wp_error($editor)) {
            return;
        }

        // Save without EXIF (this automatically strips metadata)
        $editor->save($file_path);
        
        // Regenerate thumbnails
        wp_generate_attachment_metadata($attachment_id, $file_path);
    }

    /**
     * Hook for community integration when listing is published
     */
    public function on_listing_published($new_status, $old_status, $post) {
        if ($post->post_type !== 'market_listing' || $new_status !== 'publish' || $old_status === 'publish') {
            return;
        }

        // Create community feed event
        $listing_data = $this->format_listing($post);
        
        do_action('au_comm_feed_add', array(
            'type' => 'marketplace_listing',
            'title' => $post->post_title,
            'content' => wp_trim_words($post->post_content, 20),
            'image' => !empty($listing_data['images']) ? $listing_data['images'][0]['url'] : null,
            'price' => $listing_data['price'],
            'currency' => $listing_data['currency'],
            'deep_link' => "/marketplace/{$post->ID}",
            'created_at' => $post->post_date_gmt,
        ));
    }

    /**
     * Enqueue scripts
     */
    public function enqueue_scripts() {
        // Only if needed for frontend
    }
}

// Initialize
new Aukrug_Marketplace();
