<?php
/**
 * LEGACY FILE - DO NOT USE
 * This file is outdated. Use the wpaukrug plugin instead.
 */

// Prevent any execution
if (!defined('ABSPATH')) {
    exit;
}

// Display admin notice that this plugin is deprecated
add_action('admin_notices', function() {
    if (current_user_can('activate_plugins')) {
        echo '<div class="notice notice-error"><p><strong>DEPRECATED:</strong> The standalone "Aukrug Connect" plugin is outdated. Please use the "wpaukrug" plugin instead and deactivate this one.</p></div>';
    }
});
