<?php
/**
 * Aukrug App REST API Endpoints
 * Provides API endpoints for the Flutter app to consume
 */

// Register API endpoints
add_action('rest_api_init', 'aukrug_register_api_endpoints');

function aukrug_register_api_endpoints() {
    
    // Tourist endpoints
    register_rest_route('aukrug/v1', '/discover', [
        'methods' => WP_REST_Server::READABLE,
        'callback' => 'aukrug_get_discover_items',
        'permission_callback' => '__return_true',
    ]);
    
    register_rest_route('aukrug/v1', '/routes', [
        'methods' => WP_REST_Server::READABLE,
        'callback' => 'aukrug_get_routes',
        'permission_callback' => '__return_true',
    ]);
    
    register_rest_route('aukrug/v1', '/info', [
        'methods' => WP_REST_Server::READABLE,
        'callback' => 'aukrug_get_app_info',
        'permission_callback' => '__return_true',
    ]);
    
    // Resident endpoints
    register_rest_route('aukrug/v1', '/notices', [
        'methods' => WP_REST_Server::READABLE,
        'callback' => 'aukrug_get_notices',
        'permission_callback' => '__return_true',
    ]);
    
    // Settings endpoints
    register_rest_route('aukrug/v1', '/settings', [
        'methods' => WP_REST_Server::READABLE,
        'callback' => 'aukrug_get_app_settings',
        'permission_callback' => '__return_true',
    ]);
    
    // Administrative endpoints
    register_rest_route('aukrug/v1', '/admin/discover', [
        'methods' => ['GET', 'POST', 'PUT', 'DELETE'],
        'callback' => 'aukrug_admin_discover_endpoint',
        'permission_callback' => 'aukrug_admin_permission_check',
    ]);
    
    register_rest_route('aukrug/v1', '/admin/routes', [
        'methods' => ['GET', 'POST', 'PUT', 'DELETE'],
        'callback' => 'aukrug_admin_routes_endpoint',
        'permission_callback' => 'aukrug_admin_permission_check',
    ]);
    
    register_rest_route('aukrug/v1', '/admin/notices', [
        'methods' => ['GET', 'POST', 'PUT', 'DELETE'],
        'callback' => 'aukrug_admin_notices_endpoint',
        'permission_callback' => 'aukrug_admin_permission_check',
    ]);
}

// Permission callback for admin endpoints
function aukrug_admin_permission_check() {
    return current_user_can('manage_options');
}

// Tourist API Endpoints

function aukrug_get_discover_items(WP_REST_Request $request) {
    global $wpdb;
    
    $category = $request->get_param('category');
    $featured = $request->get_param('featured');
    $search = $request->get_param('search');
    
    $table_name = $wpdb->prefix . 'aukrug_discover_items';
    
    $where_clauses = ['1=1'];
    $params = [];
    
    if (!empty($category)) {
        $where_clauses[] = 'category = %s';
        $params[] = $category;
    }
    
    if (!empty($featured) && $featured === 'true') {
        $where_clauses[] = 'is_featured = 1';
    }
    
    if (!empty($search)) {
        $where_clauses[] = '(title LIKE %s OR description LIKE %s)';
        $search_param = '%' . $wpdb->esc_like($search) . '%';
        $params[] = $search_param;
        $params[] = $search_param;
    }
    
    $where_sql = implode(' AND ', $where_clauses);
    
    $query = "SELECT * FROM $table_name WHERE $where_sql ORDER BY is_featured DESC, title ASC";
    
    if (!empty($params)) {
        $query = $wpdb->prepare($query, $params);
    }
    
    $results = $wpdb->get_results($query, ARRAY_A);
    
    if ($results === false) {
        return new WP_Error('database_error', 'Fehler beim Laden der Entdeckungen', ['status' => 500]);
    }
    
    // Transform results to match Flutter model format
    $items = array_map(function($item) {
        return [
            'id' => $item['id'],
            'title' => $item['title'],
            'description' => $item['description'],
            'category' => $item['category'],
            'imageUrl' => $item['image_url'],
            'lat' => (float)$item['lat'],
            'lng' => (float)$item['lng'],
            'isFeatured' => (bool)$item['is_featured'],
            'rating' => (int)$item['rating'],
            'openingHours' => $item['opening_hours'],
            'websiteUrl' => $item['website_url'],
            'phoneNumber' => $item['phone_number'],
        ];
    }, $results);
    
    return rest_ensure_response($items);
}

function aukrug_get_routes(WP_REST_Request $request) {
    global $wpdb;
    
    $type = $request->get_param('type');
    $difficulty = $request->get_param('difficulty');
    
    $table_name = $wpdb->prefix . 'aukrug_routes';
    
    $where_clauses = ['1=1'];
    $params = [];
    
    if (!empty($type)) {
        $where_clauses[] = 'type = %s';
        $params[] = $type;
    }
    
    if (!empty($difficulty)) {
        $where_clauses[] = 'difficulty = %s';
        $params[] = $difficulty;
    }
    
    $where_sql = implode(' AND ', $where_clauses);
    
    $query = "SELECT * FROM $table_name WHERE $where_sql ORDER BY name ASC";
    
    if (!empty($params)) {
        $query = $wpdb->prepare($query, $params);
    }
    
    $results = $wpdb->get_results($query, ARRAY_A);
    
    if ($results === false) {
        return new WP_Error('database_error', 'Fehler beim Laden der Routen', ['status' => 500]);
    }
    
    // Transform results to match Flutter model format
    $routes = array_map(function($route) {
        return [
            'id' => $route['id'],
            'name' => $route['name'],
            'description' => $route['description'],
            'type' => $route['type'],
            'difficulty' => $route['difficulty'],
            'distance' => (float)$route['distance'],
            'duration' => (int)$route['duration'],
            'elevationGain' => (int)$route['elevation_gain'],
            'startLat' => (float)$route['start_lat'],
            'startLng' => (float)$route['start_lng'],
            'endLat' => (float)$route['end_lat'],
            'endLng' => (float)$route['end_lng'],
            'gpxUrl' => $route['gpx_url'],
            'imageUrl' => $route['image_url'],
        ];
    }, $results);
    
    return rest_ensure_response($routes);
}

function aukrug_get_app_info(WP_REST_Request $request) {
    $info_settings = get_option('aukrug_info_settings', []);
    
    $default_info = [
        'contactAddress' => "Hauptstraße 17\n24613 Aukrug",
        'contactPhone' => '+49 4873 8779-0',
        'contactEmail' => 'info@aukrug.de',
        'contactWebsite' => 'https://www.aukrug.de',
        'openingHours' => "Montag: 08:00 - 12:00\nDienstag: 08:00 - 12:00, 14:00 - 18:00\nMittwoch: 08:00 - 12:00\nDonnerstag: 08:00 - 12:00, 14:00 - 16:00\nFreitag: 08:00 - 12:00\nSamstag: Geschlossen\nSonntag: Geschlossen",
        'appDescription' => "Die offizielle App der Gemeinde Aukrug.\n\nEntwickelt für die Bürgerinnen und Bürger von Aukrug.",
        'appVersion' => '1.0.0',
        'emergencyNumbers' => [
            ['name' => 'Polizei', 'number' => '110'],
            ['name' => 'Feuerwehr / Rettungsdienst', 'number' => '112'],
            ['name' => 'Giftnotruf', 'number' => '+49 551 19240'],
        ],
    ];
    
    // Merge with saved settings
    $info = array_merge($default_info, $info_settings);
    
    return rest_ensure_response($info);
}

// Resident API Endpoints

function aukrug_get_notices(WP_REST_Request $request) {
    global $wpdb;
    
    $category = $request->get_param('category');
    $importance = $request->get_param('importance');
    $search = $request->get_param('search');
    $pinned_only = $request->get_param('pinned');
    
    $table_name = $wpdb->prefix . 'aukrug_notices';
    
    $where_clauses = ['valid_until >= CURDATE()'];
    $params = [];
    
    if (!empty($category)) {
        $where_clauses[] = 'category = %s';
        $params[] = $category;
    }
    
    if (!empty($importance)) {
        $where_clauses[] = 'importance = %s';
        $params[] = $importance;
    }
    
    if (!empty($search)) {
        $where_clauses[] = '(title LIKE %s OR content LIKE %s)';
        $search_param = '%' . $wpdb->esc_like($search) . '%';
        $params[] = $search_param;
        $params[] = $search_param;
    }
    
    if (!empty($pinned_only) && $pinned_only === 'true') {
        $where_clauses[] = 'is_pinned = 1';
    }
    
    $where_sql = implode(' AND ', $where_clauses);
    
    $query = "SELECT * FROM $table_name WHERE $where_sql ORDER BY is_pinned DESC, published_date DESC";
    
    if (!empty($params)) {
        $query = $wpdb->prepare($query, $params);
    }
    
    $results = $wpdb->get_results($query, ARRAY_A);
    
    if ($results === false) {
        return new WP_Error('database_error', 'Fehler beim Laden der Bekanntmachungen', ['status' => 500]);
    }
    
    // Transform results to match Flutter model format
    $notices = array_map(function($notice) {
        return [
            'id' => $notice['id'],
            'title' => $notice['title'],
            'content' => $notice['content'],
            'category' => $notice['category'],
            'importance' => $notice['importance'],
            'publishedDate' => $notice['published_date'],
            'validUntil' => $notice['valid_until'],
            'isPinned' => (bool)$notice['is_pinned'],
        ];
    }, $results);
    
    return rest_ensure_response($notices);
}

function aukrug_get_app_settings(WP_REST_Request $request) {
    $resident_settings = get_option('aukrug_resident_settings', []);
    
    $default_settings = [
        'defaultNotices' => true,
        'defaultEmergency' => true,
        'defaultEvents' => true,
        'defaultTheme' => 'system',
        'cacheDuration' => 24,
        'enableFeedback' => true,
        'feedbackEmail' => 'feedback@aukrug.de',
    ];
    
    // Merge with saved settings
    $settings = array_merge($default_settings, $resident_settings);
    
    return rest_ensure_response($settings);
}

// Administrative API Endpoints

function aukrug_admin_discover_endpoint(WP_REST_Request $request) {
    global $wpdb;
    $table_name = $wpdb->prefix . 'aukrug_discover_items';
    
    $method = $request->get_method();
    $id = $request->get_param('id');
    
    switch ($method) {
        case 'GET':
            if ($id) {
                $item = $wpdb->get_row($wpdb->prepare("SELECT * FROM $table_name WHERE id = %d", $id), ARRAY_A);
                return $item ? rest_ensure_response($item) : new WP_Error('not_found', 'Item nicht gefunden', ['status' => 404]);
            } else {
                return aukrug_get_discover_items($request);
            }
            
        case 'POST':
            $data = $request->get_json_params();
            
            $result = $wpdb->insert(
                $table_name,
                [
                    'title' => sanitize_text_field($data['title']),
                    'description' => sanitize_textarea_field($data['description']),
                    'category' => sanitize_text_field($data['category']),
                    'image_url' => esc_url_raw($data['imageUrl'] ?? ''),
                    'lat' => floatval($data['lat']),
                    'lng' => floatval($data['lng']),
                    'is_featured' => !empty($data['isFeatured']) ? 1 : 0,
                    'rating' => intval($data['rating'] ?? 0),
                    'opening_hours' => sanitize_text_field($data['openingHours'] ?? ''),
                    'website_url' => esc_url_raw($data['websiteUrl'] ?? ''),
                    'phone_number' => sanitize_text_field($data['phoneNumber'] ?? ''),
                ]
            );
            
            if ($result === false) {
                return new WP_Error('database_error', 'Fehler beim Erstellen', ['status' => 500]);
            }
            
            return rest_ensure_response(['id' => $wpdb->insert_id, 'message' => 'Erfolgreich erstellt']);
            
        case 'PUT':
            if (!$id) {
                return new WP_Error('missing_id', 'ID erforderlich', ['status' => 400]);
            }
            
            $data = $request->get_json_params();
            
            $result = $wpdb->update(
                $table_name,
                [
                    'title' => sanitize_text_field($data['title']),
                    'description' => sanitize_textarea_field($data['description']),
                    'category' => sanitize_text_field($data['category']),
                    'image_url' => esc_url_raw($data['imageUrl'] ?? ''),
                    'lat' => floatval($data['lat']),
                    'lng' => floatval($data['lng']),
                    'is_featured' => !empty($data['isFeatured']) ? 1 : 0,
                    'rating' => intval($data['rating'] ?? 0),
                    'opening_hours' => sanitize_text_field($data['openingHours'] ?? ''),
                    'website_url' => esc_url_raw($data['websiteUrl'] ?? ''),
                    'phone_number' => sanitize_text_field($data['phoneNumber'] ?? ''),
                ],
                ['id' => $id]
            );
            
            if ($result === false) {
                return new WP_Error('database_error', 'Fehler beim Aktualisieren', ['status' => 500]);
            }
            
            return rest_ensure_response(['message' => 'Erfolgreich aktualisiert']);
            
        case 'DELETE':
            if (!$id) {
                return new WP_Error('missing_id', 'ID erforderlich', ['status' => 400]);
            }
            
            $result = $wpdb->delete($table_name, ['id' => $id]);
            
            if ($result === false) {
                return new WP_Error('database_error', 'Fehler beim Löschen', ['status' => 500]);
            }
            
            return rest_ensure_response(['message' => 'Erfolgreich gelöscht']);
    }
}

function aukrug_admin_routes_endpoint(WP_REST_Request $request) {
    global $wpdb;
    $table_name = $wpdb->prefix . 'aukrug_routes';
    
    $method = $request->get_method();
    $id = $request->get_param('id');
    
    switch ($method) {
        case 'GET':
            if ($id) {
                $route = $wpdb->get_row($wpdb->prepare("SELECT * FROM $table_name WHERE id = %d", $id), ARRAY_A);
                return $route ? rest_ensure_response($route) : new WP_Error('not_found', 'Route nicht gefunden', ['status' => 404]);
            } else {
                return aukrug_get_routes($request);
            }
            
        case 'POST':
            $data = $request->get_json_params();
            
            $result = $wpdb->insert(
                $table_name,
                [
                    'name' => sanitize_text_field($data['name']),
                    'description' => sanitize_textarea_field($data['description']),
                    'type' => sanitize_text_field($data['type']),
                    'difficulty' => sanitize_text_field($data['difficulty']),
                    'distance' => floatval($data['distance']),
                    'duration' => intval($data['duration']),
                    'elevation_gain' => intval($data['elevationGain'] ?? 0),
                    'start_lat' => floatval($data['startLat']),
                    'start_lng' => floatval($data['startLng']),
                    'end_lat' => floatval($data['endLat']),
                    'end_lng' => floatval($data['endLng']),
                    'gpx_url' => esc_url_raw($data['gpxUrl'] ?? ''),
                    'image_url' => esc_url_raw($data['imageUrl'] ?? ''),
                ]
            );
            
            if ($result === false) {
                return new WP_Error('database_error', 'Fehler beim Erstellen', ['status' => 500]);
            }
            
            return rest_ensure_response(['id' => $wpdb->insert_id, 'message' => 'Route erfolgreich erstellt']);
            
        // Similar PUT and DELETE implementations...
        default:
            return new WP_Error('method_not_allowed', 'Methode nicht erlaubt', ['status' => 405]);
    }
}

function aukrug_admin_notices_endpoint(WP_REST_Request $request) {
    global $wpdb;
    $table_name = $wpdb->prefix . 'aukrug_notices';
    
    $method = $request->get_method();
    $id = $request->get_param('id');
    
    switch ($method) {
        case 'GET':
            if ($id) {
                $notice = $wpdb->get_row($wpdb->prepare("SELECT * FROM $table_name WHERE id = %d", $id), ARRAY_A);
                return $notice ? rest_ensure_response($notice) : new WP_Error('not_found', 'Bekanntmachung nicht gefunden', ['status' => 404]);
            } else {
                return aukrug_get_notices($request);
            }
            
        case 'POST':
            $data = $request->get_json_params();
            
            $result = $wpdb->insert(
                $table_name,
                [
                    'title' => sanitize_text_field($data['title']),
                    'content' => sanitize_textarea_field($data['content']),
                    'category' => sanitize_text_field($data['category']),
                    'importance' => sanitize_text_field($data['importance']),
                    'published_date' => sanitize_text_field($data['publishedDate']),
                    'valid_until' => sanitize_text_field($data['validUntil']),
                    'is_pinned' => !empty($data['isPinned']) ? 1 : 0,
                ]
            );
            
            if ($result === false) {
                return new WP_Error('database_error', 'Fehler beim Erstellen', ['status' => 500]);
            }
            
            return rest_ensure_response(['id' => $wpdb->insert_id, 'message' => 'Bekanntmachung erfolgreich erstellt']);
            
        // Similar PUT and DELETE implementations...
        default:
            return new WP_Error('method_not_allowed', 'Methode nicht erlaubt', ['status' => 405]);
    }
}
?>
