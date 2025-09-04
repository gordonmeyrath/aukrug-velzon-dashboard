<?php
/**
 * REST API for Aukrug Connect
 * 
 * Provides endpoints under /wp-json/aukrug/v1/
 */

if (!defined('ABSPATH')) {
    exit;
}

class AukrugREST
{
    private $namespace = 'aukrug/v1';

    public function __construct()
    {
        add_action('rest_api_init', [$this, 'registerRoutes']);
        add_filter('rest_pre_serve_request', [$this, 'addCacheHeaders'], 10, 4);
    }

    public function registerRoutes()
    {
        // GET endpoints for content types
        register_rest_route($this->namespace, '/places', [
            'methods' => 'GET',
            'callback' => [$this, 'getPlaces'],
            'permission_callback' => '__return_true',
            'args' => $this->getListArgs(),
        ]);

        register_rest_route($this->namespace, '/routes', [
            'methods' => 'GET',
            'callback' => [$this, 'getRoutes'],
            'permission_callback' => '__return_true',
            'args' => $this->getListArgs(),
        ]);

        register_rest_route($this->namespace, '/events', [
            'methods' => 'GET',
            'callback' => [$this, 'getEvents'],
            'permission_callback' => '__return_true',
            'args' => $this->getListArgs(),
        ]);

        register_rest_route($this->namespace, '/notices', [
            'methods' => 'GET',
            'callback' => [$this, 'getNotices'],
            'permission_callback' => [$this, 'checkResidentPermission'],
            'args' => $this->getListArgs(),
        ]);

        register_rest_route($this->namespace, '/downloads', [
            'methods' => 'GET',
            'callback' => [$this, 'getDownloads'],
            'permission_callback' => '__return_true',
            'args' => $this->getListArgs(),
        ]);

        // Sync endpoint for delta updates
        register_rest_route($this->namespace, '/sync/changes', [
            'methods' => 'GET',
            'callback' => [$this, 'getSyncChanges'],
            'permission_callback' => '__return_true',
            'args' => [
                'since' => [
                    'description' => 'ISO 8601 timestamp for delta sync',
                    'type' => 'string',
                    'format' => 'date-time',
                ],
                'types' => [
                    'description' => 'Comma-separated list of content types',
                    'type' => 'string',
                    'default' => 'places,routes,events,downloads',
                ],
            ],
        ]);

        // POST endpoint for reports
        register_rest_route($this->namespace, '/reports', [
            'methods' => 'POST',
            'callback' => [$this, 'createReport'],
            'permission_callback' => '__return_true',
            'args' => [
                'title' => [
                    'required' => true,
                    'type' => 'string',
                    'sanitize_callback' => 'sanitize_text_field',
                ],
                'content' => [
                    'required' => true,
                    'type' => 'string',
                    'sanitize_callback' => 'sanitize_textarea_field',
                ],
                'category' => [
                    'type' => 'string',
                    'enum' => ['issue', 'suggestion', 'compliment', 'other'],
                    'default' => 'other',
                ],
                'location' => [
                    'type' => 'object',
                    'properties' => [
                        'latitude' => ['type' => 'number'],
                        'longitude' => ['type' => 'number'],
                        'address' => ['type' => 'string'],
                    ],
                ],
                'media' => [
                    'description' => 'Array of media attachment IDs',
                    'type' => 'array',
                    'items' => ['type' => 'integer'],
                ],
            ],
        ]);
    }

    private function getListArgs()
    {
        return [
            'per_page' => [
                'default' => 20,
                'minimum' => 1,
                'maximum' => 100,
                'type' => 'integer',
            ],
            'page' => [
                'default' => 1,
                'minimum' => 1,
                'type' => 'integer',
            ],
            'audience' => [
                'description' => 'Filter by audience',
                'type' => 'string',
                'enum' => ['tourist', 'resident', 'kita', 'schule'],
            ],
            'category' => [
                'description' => 'Filter by category slug',
                'type' => 'string',
            ],
            'search' => [
                'description' => 'Search query',
                'type' => 'string',
            ],
        ];
    }

    public function getPlaces($request)
    {
        return $this->getPostsResponse('aukrug_place', $request);
    }

    public function getRoutes($request)
    {
        return $this->getPostsResponse('aukrug_route', $request);
    }

    public function getEvents($request)
    {
        return $this->getPostsResponse('aukrug_event', $request);
    }

    public function getNotices($request)
    {
        return $this->getPostsResponse('aukrug_notice', $request);
    }

    public function getDownloads($request)
    {
        return $this->getPostsResponse('aukrug_download', $request);
    }

    private function getPostsResponse($post_type, $request)
    {
        $args = [
            'post_type' => $post_type,
            'post_status' => 'publish',
            'posts_per_page' => $request->get_param('per_page'),
            'paged' => $request->get_param('page'),
            'meta_query' => [],
            'tax_query' => [],
        ];

        // Add audience filter
        if ($audience = $request->get_param('audience')) {
            $args['tax_query'][] = [
                'taxonomy' => 'aukrug_audience',
                'field' => 'slug',
                'terms' => $audience,
            ];
        }

        // Add category filter
        if ($category = $request->get_param('category')) {
            $args['tax_query'][] = [
                'taxonomy' => 'aukrug_category',
                'field' => 'slug',
                'terms' => $category,
            ];
        }

        // Add search
        if ($search = $request->get_param('search')) {
            $args['s'] = $search;
        }

        $query = new WP_Query($args);
        $posts = [];

        foreach ($query->posts as $post) {
            $posts[] = $this->formatPostForAPI($post);
        }

        $response = rest_ensure_response([
            'data' => $posts,
            'pagination' => [
                'total' => $query->found_posts,
                'total_pages' => $query->max_num_pages,
                'current_page' => $request->get_param('page'),
                'per_page' => $request->get_param('per_page'),
            ],
        ]);

        // Add cache headers
        $last_modified = $this->getLastModified($post_type);
        if ($last_modified) {
            $response->header('Last-Modified', $last_modified);
            $response->header('ETag', md5($last_modified . serialize($posts)));
        }

        return $response;
    }

    private function formatPostForAPI($post)
    {
        $data = [
            'id' => $post->ID,
            'title' => $post->post_title,
            'content' => $post->post_content,
            'excerpt' => $post->post_excerpt,
            'date_created' => $post->post_date_gmt,
            'date_modified' => $post->post_modified_gmt,
            'status' => $post->post_status,
            'meta' => [],
            'taxonomy' => [],
        ];

        // Add location data if available
        $latitude = get_post_meta($post->ID, '_aukrug_latitude', true);
        $longitude = get_post_meta($post->ID, '_aukrug_longitude', true);
        $address = get_post_meta($post->ID, '_aukrug_address', true);

        if ($latitude && $longitude) {
            $data['location'] = [
                'latitude' => floatval($latitude),
                'longitude' => floatval($longitude),
                'address' => $address ?: '',
            ];
        }

        // Add taxonomies
        $taxonomies = ['aukrug_audience', 'aukrug_category'];
        foreach ($taxonomies as $taxonomy) {
            $terms = wp_get_post_terms($post->ID, $taxonomy, ['fields' => 'slugs']);
            if (!is_wp_error($terms)) {
                $data['taxonomy'][str_replace('aukrug_', '', $taxonomy)] = $terms;
            }
        }

        // Add featured image
        if ($thumbnail_id = get_post_thumbnail_id($post->ID)) {
            $data['featured_image'] = wp_get_attachment_image_src($thumbnail_id, 'large');
        }

        return $data;
    }

    public function getSyncChanges($request)
    {
        $since = $request->get_param('since');
        $types = explode(',', $request->get_param('types'));
        
        $changes = [
            'timestamp' => current_time('mysql', true),
            'changes' => [],
        ];

        foreach ($types as $type) {
            $post_type = 'aukrug_' . trim($type);
            
            if (!post_type_exists($post_type)) {
                continue;
            }

            $args = [
                'post_type' => $post_type,
                'post_status' => ['publish', 'trash'],
                'posts_per_page' => -1,
                'fields' => 'ids',
            ];

            if ($since) {
                $args['date_query'] = [
                    [
                        'after' => $since,
                        'column' => 'post_modified_gmt',
                        'inclusive' => false,
                    ],
                ];
            }

            $posts = get_posts($args);
            
            if (!empty($posts)) {
                $changes['changes'][$type] = $posts;
            }
        }

        return rest_ensure_response($changes);
    }

    public function createReport($request)
    {
        $title = $request->get_param('title');
        $content = $request->get_param('content');
        $category = $request->get_param('category');
        $location = $request->get_param('location');
        $media = $request->get_param('media');

        // Create report post
        $post_id = wp_insert_post([
            'post_title' => $title,
            'post_content' => $content,
            'post_type' => 'aukrug_report',
            'post_status' => 'publish',
            'meta_input' => [
                '_aukrug_report_category' => $category,
                '_aukrug_report_ip' => $this->getClientIP(),
                '_aukrug_report_user_agent' => $_SERVER['HTTP_USER_AGENT'] ?? '',
            ],
        ]);

        if (is_wp_error($post_id)) {
            return new WP_Error('report_creation_failed', 'Failed to create report', ['status' => 500]);
        }

        // Add location data
        if ($location && isset($location['latitude'], $location['longitude'])) {
            update_post_meta($post_id, '_aukrug_latitude', $location['latitude']);
            update_post_meta($post_id, '_aukrug_longitude', $location['longitude']);
            if (isset($location['address'])) {
                update_post_meta($post_id, '_aukrug_address', $location['address']);
            }
        }

        // Associate media
        if ($media && is_array($media)) {
            foreach ($media as $attachment_id) {
                wp_update_post([
                    'ID' => $attachment_id,
                    'post_parent' => $post_id,
                ]);
            }
        }

        // Log for GDPR compliance
        $this->logAuditEvent('report_created', 'aukrug_report', $post_id, [
            'category' => $category,
            'has_location' => !empty($location),
            'media_count' => count($media ?: []),
        ]);

        return rest_ensure_response([
            'id' => $post_id,
            'status' => 'created',
            'message' => __('Report submitted successfully', 'aukrug-connect'),
        ]);
    }

    public function checkResidentPermission($request)
    {
        // TODO: Implement JWT token validation for resident-only content
        // For now, allow all requests
        return true;
    }

    public function addCacheHeaders($served, $result, $request, $server)
    {
        if (strpos($request->get_route(), '/aukrug/v1/') === 0) {
            $server->send_header('Cache-Control', 'public, max-age=300'); // 5 minutes
        }
        return $served;
    }

    private function getLastModified($post_type)
    {
        $posts = get_posts([
            'post_type' => $post_type,
            'posts_per_page' => 1,
            'orderby' => 'modified',
            'order' => 'DESC',
            'fields' => 'ids',
        ]);

        if (!empty($posts)) {
            return get_post_modified_time('D, d M Y H:i:s', true, $posts[0]) . ' GMT';
        }

        return null;
    }

    private function getClientIP()
    {
        $ip_keys = ['HTTP_CLIENT_IP', 'HTTP_X_FORWARDED_FOR', 'REMOTE_ADDR'];
        foreach ($ip_keys as $key) {
            if (array_key_exists($key, $_SERVER) === true) {
                foreach (explode(',', $_SERVER[$key]) as $ip) {
                    $ip = trim($ip);
                    if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE) !== false) {
                        return $ip;
                    }
                }
            }
        }
        return $_SERVER['REMOTE_ADDR'] ?? 'unknown';
    }

    private function logAuditEvent($action, $object_type, $object_id, $data = [])
    {
        global $wpdb;
        
        $wpdb->insert(
            $wpdb->prefix . 'aukrug_audit_log',
            [
                'user_id' => get_current_user_id() ?: null,
                'action' => $action,
                'object_type' => $object_type,
                'object_id' => $object_id,
                'data' => json_encode($data),
                'ip_address' => $this->getClientIP(),
                'created_at' => current_time('mysql'),
            ]
        );
    }
}
