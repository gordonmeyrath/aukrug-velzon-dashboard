<?php
/**
 * PHPUnit bootstrap file for Aukrug Plugin tests
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    define('ABSPATH', dirname(__FILE__) . '/../../../');
}

// Define WordPress test environment
define('WP_TESTS_FORCE_KNOWN_BUGS', true);

// Load WordPress testing framework (if available)
$_tests_dir = getenv('WP_TESTS_DIR');
if (!$_tests_dir) {
    $_tests_dir = '/tmp/wordpress-tests-lib';
}

// Mock WordPress functions for basic testing
if (!function_exists('add_action')) {
    function add_action($hook, $function, $priority = 10, $accepted_args = 1) {
        // Mock function
        return true;
    }
}

if (!function_exists('add_filter')) {
    function add_filter($hook, $function, $priority = 10, $accepted_args = 1) {
        // Mock function
        return true;
    }
}

if (!function_exists('register_post_type')) {
    function register_post_type($post_type, $args = []) {
        // Mock function
        return true;
    }
}

if (!function_exists('__')) {
    function __($text, $domain = 'default') {
        return $text;
    }
}

if (!function_exists('_e')) {
    function _e($text, $domain = 'default') {
        echo $text;
    }
}

// Load plugin files
require_once dirname(__FILE__) . '/../au_aukrug_connect.php';
