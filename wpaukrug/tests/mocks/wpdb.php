<?php
/**
 * Mock wpdb class for testing
 */
class wpdb {
    public $users = 'wp_users';
    public $posts = 'wp_posts';
    public $postmeta = 'wp_postmeta';
    
    public function get_var($query) {
        return 5;
    }
    
    public function get_results($query) {
        return array();
    }
}
