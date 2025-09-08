<?php
/*
Plugin Name: Aukrug Connect
Plugin URI: https://aukrug.de
Description: WordPress Plugin für Aukrug Connect mit Advanced Community Management
Version: 1.0.0
Author: MioWorkx
Author URI: https://mioworkx.de
Text Domain: wpaukrug
Network: false
Requires PHP: 7.4
*/

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

// Plugin constants
define('AUKRUG_PLUGIN_VERSION', '1.0.0');
define('AUKRUG_PLUGIN_FILE', __FILE__);
define('AUKRUG_PLUGIN_DIR', plugin_dir_path(__FILE__));
define('AUKRUG_PLUGIN_URL', plugin_dir_url(__FILE__));

// Include necessary files
require_once AUKRUG_PLUGIN_DIR . 'includes/class-aukrug-cpt.php';
require_once AUKRUG_PLUGIN_DIR . 'includes/class-aukrug-rest.php';
require_once AUKRUG_PLUGIN_DIR . 'includes/class-aukrug-api.php';
require_once AUKRUG_PLUGIN_DIR . 'includes/class-aukrug-database.php';
require_once AUKRUG_PLUGIN_DIR . 'includes/class-aukrug-public-api.php';
require_once AUKRUG_PLUGIN_DIR . 'includes/class-aukrug-community-database.php';
require_once AUKRUG_PLUGIN_DIR . 'includes/class-aukrug-community-config.php';
require_once AUKRUG_PLUGIN_DIR . 'includes/class-aukrug-marketplace.php';
require_once AUKRUG_PLUGIN_DIR . 'admin/aukrug-dashboard-clean.php';
require_once AUKRUG_PLUGIN_DIR . 'admin/community-dashboard.php';
require_once AUKRUG_PLUGIN_DIR . 'admin/marketplace-admin.php';

// Health-Route einbinden
require_once AUKRUG_PLUGIN_DIR . 'includes/class-aukrug-health.php';

// Initialize the plugin
function aukrug_connect_init() {
    // Existing components
    if (class_exists('Aukrug_CPT')) new Aukrug_CPT();
    if (class_exists('Aukrug_REST')) new Aukrug_REST();
    if (class_exists('Aukrug_Public_API')) new Aukrug_Public_API();
    
    // Community System
    if (class_exists('Aukrug_Community')) {
        Aukrug_Community::get_instance();
    }
    
    // Marketplace System
    if (class_exists('Aukrug_Marketplace')) {
        new Aukrug_Marketplace();
    }
    
    // Dashboard initialisieren
    if (class_exists('Aukrug_Dashboard_Clean')) {
        Aukrug_Dashboard_Clean::get_instance();
    }
    
    // Health route
    add_action('rest_api_init', ['Aukrug_Health', 'register_route']);
}

add_action('init', 'aukrug_connect_init');

// Plugin activation hook for database setup
register_activation_hook(__FILE__, function() {
    // Activate community system
    if (class_exists('Aukrug_Community')) {
        $community = Aukrug_Community::get_instance();
        $community->create_database_tables();
        $community->create_user_roles();
    }
    
    // Check database version
    if (function_exists('aukrug_check_database_version')) {
        aukrug_check_database_version();
    }
});

// Database version check on plugin load
add_action('plugins_loaded', function() {
    if (function_exists('aukrug_check_database_version')) {
        aukrug_check_database_version();
    }
});

// Community system innovative features
add_action('wp_loaded', function() {
    if (class_exists('Aukrug_Community')) {
        // Enable real-time notifications
        do_action('aukrug_enable_realtime_features');
        
        // Setup innovative community features
        do_action('aukrug_setup_ai_moderation');
        do_action('aukrug_setup_smart_recommendations');
        do_action('aukrug_setup_gamification');
    }
});
// Siehe admin/aukrug-dashboard-new.php

// Load the real plugin implementation from the same directory (flattened)
if (file_exists(__DIR__ . '/au_aukrug_connect.php')) {
    require_once __DIR__ . '/au_aukrug_connect.php';
}
