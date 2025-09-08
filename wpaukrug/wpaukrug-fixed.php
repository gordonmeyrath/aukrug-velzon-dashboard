<?php
/*
Plugin Name: Aukrug Connect
Plugin URI: https://aukrug.de
Description: WordPress Plugin für Aukrug Connect mit Admin-Dashboard
Version: 1.0.0
Author: MioWorkx
Author URI: https://mioworkx.de
Text Domain: wpaukrug
*/

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

// Plugin-Version definieren
if (!defined('AU_PLUGIN_VERSION')) {
    define('AU_PLUGIN_VERSION', '1.0.0');
}

// Include necessary files
require_once __DIR__ . '/includes/class-aukrug-cpt.php';
require_once __DIR__ . '/includes/class-aukrug-rest.php';
require_once __DIR__ . '/includes/class-aukrug-api.php';
require_once __DIR__ . '/includes/class-aukrug-database.php';
require_once __DIR__ . '/includes/class-aukrug-public-api.php';
require_once __DIR__ . '/admin/aukrug-dashboard-clean.php';

// Health-Route einbinden
require_once __DIR__ . '/includes/class-aukrug-health.php';

// Initialize the plugin
function aukrug_connect_init() {
    if (class_exists('Aukrug_CPT')) new Aukrug_CPT();
    if (class_exists('Aukrug_REST')) new Aukrug_REST();
    if (class_exists('Aukrug_Public_API')) new Aukrug_Public_API();
    
    // Health Route registrieren
    if (class_exists('Aukrug_Health')) {
        Aukrug_Health::register_route();
    }
    
    // Dashboard initialisieren (Singleton-Pattern verhindert doppelte Initialisierung)
    if (class_exists('Aukrug_Dashboard_Clean')) {
        Aukrug_Dashboard_Clean::get_instance();
    }
}
add_action('init', 'aukrug_connect_init');

// Plugin activation hook
register_activation_hook(__FILE__, function() {
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

// Load the real plugin implementation from the same directory (flattened)
if (file_exists(__DIR__ . '/au_aukrug_connect.php')) {
    require_once __DIR__ . '/au_aukrug_connect.php';
}
?>
