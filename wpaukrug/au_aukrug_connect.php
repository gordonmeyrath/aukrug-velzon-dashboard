<?php
/**
 * Aukrug Connect – internal bootstrap (loaded by wpaukrug/wpaukrug.php)
 * Note: No plugin header here to avoid being detected as a separate plugin.
 */

// Exit if accessed directly via web; allow CLI (e.g., PHPUnit) to include this file.
if (!defined('ABSPATH')) {
    if (PHP_SAPI !== 'cli' && PHP_SAPI !== 'phpdbg') {
        exit;
    }
}

// Define plugin constants (guarded for idempotency when loaded via wrapper).
if (!defined('AUKRUG_CONNECT_VERSION')) {
    define('AUKRUG_CONNECT_VERSION', '0.1.1');
}
if (!defined('AUKRUG_CONNECT_FILE')) {
    define('AUKRUG_CONNECT_FILE', __FILE__);
}
if (!defined('AUKRUG_CONNECT_DIR')) {
    define('AUKRUG_CONNECT_DIR', function_exists('plugin_dir_path') ? (string) \call_user_func('plugin_dir_path', __FILE__) : (__DIR__ . '/'));
}
if (!defined('AUKRUG_CONNECT_URL')) {
    // Point directly to this /plugin/ directory for assets
    if (function_exists('plugin_dir_url')) {
        define('AUKRUG_CONNECT_URL', (string) \call_user_func('plugin_dir_url', __FILE__));
    } else {
        define('AUKRUG_CONNECT_URL', '');
    }
}

// Load Composer autoloader if present.
$autoload = AUKRUG_CONNECT_DIR . 'vendor/autoload.php';
if (file_exists($autoload)) {
    require_once $autoload;
}

// Fallback autoload: map core classes to their files if Composer isn't installed yet.
spl_autoload_register(function ($class) {
    if (strpos($class, 'Aukrug\\Connect\\') !== 0) {
        return;
    }
    $short = substr($class, strlen('Aukrug\\Connect\\'));
    $map = [
        'Cpt' => 'class-aukrug-cpt.php',
        'Rest' => 'class-aukrug-rest.php',
        'Health' => 'class-aukrug-health.php',
        'RestComplete' => 'class-aukrug-rest.php',
    ];
    $file = $map[$short] ?? null;
    if ($file) {
        $path = AUKRUG_CONNECT_DIR . 'includes/' . $file;
        if (file_exists($path)) {
            require_once $path;
        }
    }
});

// Bootstrap the plugin components directly since we're using a simplified structure.
if (function_exists('add_action')) {
    \call_user_func('add_action', 'init', function () {
        // Load Public API first
        require_once AUKRUG_CONNECT_DIR . 'includes/class-aukrug-public-api.php';
        
        // Initialize Custom Post Types
        if (class_exists('Aukrug_CPT')) {
            new Aukrug_CPT();
        }
        
        // Initialize REST API
        if (class_exists('Aukrug_Rest')) {
            new Aukrug_Rest();
        }
        
        // Initialize Health endpoints
        if (class_exists('Aukrug_Health')) {
            new Aukrug_Health();
        }
        
        // Initialize Public API for Flutter App
        if (class_exists('Aukrug_Public_API')) {
            new Aukrug_Public_API();
        }
    });
}
