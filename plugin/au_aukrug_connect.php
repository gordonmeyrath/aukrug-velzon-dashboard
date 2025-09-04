<?php
/**
 * Plugin Name: Aukrug Connect
 * Plugin URI: https://aukrug.de
 * Description: REST API plugin for Aukrug municipality platform providing tourist and resident services
 * Version: 1.0.0
 * Author: MioWorkx
 * Author URI: https://mioworkx.de
 * Text Domain: aukrug-connect
 * Domain Path: /languages
 * Requires at least: 6.0
 * Tested up to: 6.4
 * Requires PHP: 8.2
 * Network: false
 * License: Proprietary
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

// Plugin constants
define('AUKRUG_CONNECT_VERSION', '1.0.0');
define('AUKRUG_CONNECT_PLUGIN_DIR', plugin_dir_path(__FILE__));
define('AUKRUG_CONNECT_PLUGIN_URL', plugin_dir_url(__FILE__));
define('AUKRUG_CONNECT_TEXT_DOMAIN', 'aukrug-connect');

/**
 * Main plugin class
 */
class AukrugConnect
{
    private static $instance = null;

    public static function getInstance()
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    private function __construct()
    {
        add_action('init', [$this, 'init']);
        register_activation_hook(__FILE__, [$this, 'activate']);
        register_deactivation_hook(__FILE__, [$this, 'deactivate']);
    }

    public function init()
    {
        // Load text domain
        load_plugin_textdomain(
            AUKRUG_CONNECT_TEXT_DOMAIN,
            false,
            dirname(plugin_basename(__FILE__)) . '/languages'
        );

        // Load includes
        $this->loadIncludes();

        // Initialize components
        new AukrugCPT();
        new AukrugREST();
        new AukrugSync();
        new AukrugReports();

        // Admin interface
        if (is_admin()) {
            $this->loadAdmin();
        }
    }

    private function loadIncludes()
    {
        require_once AUKRUG_CONNECT_PLUGIN_DIR . 'includes/class-aukrug-cpt.php';
        require_once AUKRUG_CONNECT_PLUGIN_DIR . 'includes/class-aukrug-rest.php';
        require_once AUKRUG_CONNECT_PLUGIN_DIR . 'includes/class-aukrug-sync.php';
        require_once AUKRUG_CONNECT_PLUGIN_DIR . 'includes/class-aukrug-reports.php';
    }

    private function loadAdmin()
    {
        require_once AUKRUG_CONNECT_PLUGIN_DIR . 'admin/settings-page.php';
        new AukrugSettings();
    }

    public function activate()
    {
        // Create database tables if needed
        $this->createTables();

        // Set default options
        add_option('aukrug_connect_version', AUKRUG_CONNECT_VERSION);
        add_option('aukrug_connect_api_cache_ttl', 3600);

        // Flush rewrite rules
        flush_rewrite_rules();
    }

    public function deactivate()
    {
        // Clean up
        flush_rewrite_rules();
    }

    private function createTables()
    {
        global $wpdb;

        $charset_collate = $wpdb->get_charset_collate();

        // Audit log table for GDPR compliance
        $audit_table = $wpdb->prefix . 'aukrug_audit_log';
        $audit_sql = "CREATE TABLE $audit_table (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            user_id bigint(20) DEFAULT NULL,
            action varchar(255) NOT NULL,
            object_type varchar(255) NOT NULL,
            object_id bigint(20) DEFAULT NULL,
            data longtext DEFAULT NULL,
            ip_address varchar(45) DEFAULT NULL,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY user_id (user_id),
            KEY action (action),
            KEY created_at (created_at)
        ) $charset_collate;";

        require_once ABSPATH . 'wp-admin/includes/upgrade.php';
        dbDelta($audit_sql);
    }
}

// Initialize plugin
AukrugConnect::getInstance();
