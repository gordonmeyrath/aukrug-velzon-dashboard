<?php
class Aukrug_Health {
    public static function register_route() {
        add_action('rest_api_init', [__CLASS__, 'add_route']);
    }
    public static function add_route() {
        register_rest_route('aukrug/v1', '/health', [
            'methods' => 'GET',
            'callback' => [__CLASS__, 'ping'],
            'permission_callback' => '__return_true',
        ]);
        register_rest_route('aukrug/v1', '/admin/counts', [
            'methods' => 'GET',
            'callback' => [__CLASS__, 'admin_counts'],
            'permission_callback' => function() {
                return current_user_can('manage_options');
            },
            'args' => [
                'types' => [
                    'description' => 'Comma-separated list of KPI types',
                    'type' => 'string',
                    'default' => 'places,events,downloads,groups,reports,changes,deleted,devices,appcaches,okapi_public',
                ],
            ],
        ]);
    }
    public static function ping($request) {
        return [
            'ok' => true,
            'plugin' => 'Aukrug Connect',
            'version' => defined('AU_PLUGIN_VERSION') ? AU_PLUGIN_VERSION : '1.0.0',
            'loaded_from' => __DIR__,
            'time' => current_time('mysql'),
        ];
    }
    public static function admin_counts($request) {
        $types = explode(',', $request->get_param('types'));
        $counts = [];
        foreach ($types as $type) {
            $counts[trim($type)] = 0; // Initial stub values
        }
        return $counts;
    }
}
