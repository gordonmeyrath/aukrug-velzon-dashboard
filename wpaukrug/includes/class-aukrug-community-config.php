<?php
/**
 * Community Configuration für Aukrug App
 * 
 * @package Aukrug
 * @since 1.0.0
 */

if (!defined('ABSPATH')) {
    exit;
}

/**
 * Community Feature Configuration
 */
class Aukrug_Community_Config {
    
    /**
     * Get community settings
     */
    public static function get_settings() {
        return array(
            'features' => array(
                'user_profiles' => true,
                'groups' => true,
                'posts' => true,
                'comments' => true,
                'events' => true,
                'marketplace' => true,
                'messaging' => true,
                'moderation' => true,
                'analytics' => true
            ),
            'limits' => array(
                'max_groups_per_user' => 50,
                'max_events_per_user' => 20,
                'max_listings_per_user' => 10,
                'max_post_length' => 5000,
                'max_comment_length' => 1000,
                'max_group_members' => 1000,
                'max_event_attendees' => 500
            ),
            'moderation' => array(
                'auto_approve_posts' => true,
                'auto_approve_comments' => true,
                'require_email_verification' => true,
                'allow_user_reports' => true,
                'enable_ai_moderation' => false
            ),
            'notifications' => array(
                'push_notifications' => true,
                'email_notifications' => true,
                'in_app_notifications' => true
            ),
            'privacy' => array(
                'default_post_visibility' => 'public',
                'allow_private_groups' => true,
                'allow_private_messaging' => true,
                'data_retention_days' => 365
            )
        );
    }
    
    /**
     * Update community settings
     */
    public static function update_settings($settings) {
        return update_option('aukrug_community_settings', $settings);
    }
    
    /**
     * Get feature status
     */
    public static function is_feature_enabled($feature) {
        $settings = self::get_settings();
        return isset($settings['features'][$feature]) ? $settings['features'][$feature] : false;
    }
    
    /**
     * Get limit value
     */
    public static function get_limit($limit) {
        $settings = self::get_settings();
        return isset($settings['limits'][$limit]) ? $settings['limits'][$limit] : 0;
    }
}

/**
 * Initialize community configuration
 */
function aukrug_community_init_config() {
    // Set default settings if not exist
    if (!get_option('aukrug_community_settings')) {
        update_option('aukrug_community_settings', Aukrug_Community_Config::get_settings());
    }
}

add_action('init', 'aukrug_community_init_config');
