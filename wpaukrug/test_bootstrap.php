<?php
/**
 * Simple WordPress Mock for testing plugin bootstrap
 */

// Mock WordPress functions that the plugin uses
function add_action($hook, $callback, $priority = 10, $accepted_args = 1) {
    echo "add_action called for hook: $hook\n";
    if (is_callable($callback)) {
        call_user_func($callback);
    }
}

define('ABSPATH', __DIR__ . '/');

// Load the plugin
require_once 'au_aukrug_connect.php';

echo "Plugin bootstrap test completed successfully!\n";
