<?php
/**
 * Community Database Setup für Aukrug App
 * 
 * @package Aukrug
 * @since 1.0.0
 */

if (!defined('ABSPATH')) {
    exit;
}

/**
 * Community Database Manager
 */
class Aukrug_Community_Database {
    
    /**
     * Create all community tables
     */
    public static function create_tables() {
        global $wpdb;
        
        $charset_collate = $wpdb->get_charset_collate();
        
        // App Users Table - separate from WordPress users for app-specific data
        $table_app_users = $wpdb->prefix . 'aukrug_app_users';
        $sql_app_users = "CREATE TABLE $table_app_users (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            wp_user_id bigint(20) DEFAULT NULL,
            display_name varchar(100) NOT NULL,
            email varchar(100) NOT NULL,
            phone varchar(20) DEFAULT NULL,
            avatar_url text DEFAULT NULL,
            bio text DEFAULT NULL,
            location varchar(255) DEFAULT NULL,
            birth_date date DEFAULT NULL,
            status enum('active','inactive','suspended','pending') DEFAULT 'active',
            privacy_settings json DEFAULT NULL,
            push_token varchar(255) DEFAULT NULL,
            last_activity datetime DEFAULT CURRENT_TIMESTAMP,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY email (email),
            KEY wp_user_id (wp_user_id),
            KEY status (status),
            KEY last_activity (last_activity)
        ) $charset_collate;";
        
        // Community Groups Table
        $table_groups = $wpdb->prefix . 'aukrug_community_groups';
        $sql_groups = "CREATE TABLE $table_groups (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            name varchar(255) NOT NULL,
            description text DEFAULT NULL,
            image_url text DEFAULT NULL,
            type enum('public','private','secret') DEFAULT 'public',
            category varchar(100) DEFAULT NULL,
            creator_id bigint(20) NOT NULL,
            admin_ids json DEFAULT NULL,
            member_limit int DEFAULT NULL,
            location varchar(255) DEFAULT NULL,
            rules text DEFAULT NULL,
            status enum('active','inactive','suspended') DEFAULT 'active',
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY creator_id (creator_id),
            KEY type (type),
            KEY status (status),
            KEY category (category),
            FULLTEXT(name, description)
        ) $charset_collate;";
        
        // Group Members Table
        $table_group_members = $wpdb->prefix . 'aukrug_community_group_members';
        $sql_group_members = "CREATE TABLE $table_group_members (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            group_id bigint(20) NOT NULL,
            user_id bigint(20) NOT NULL,
            role enum('member','admin','moderator') DEFAULT 'member',
            status enum('active','pending','banned') DEFAULT 'active',
            joined_at datetime DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY unique_membership (group_id, user_id),
            KEY group_id (group_id),
            KEY user_id (user_id),
            KEY status (status)
        ) $charset_collate;";
        
        // Community Posts Table
        $table_posts = $wpdb->prefix . 'aukrug_community_posts';
        $sql_posts = "CREATE TABLE $table_posts (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            author_id bigint(20) NOT NULL,
            group_id bigint(20) DEFAULT NULL,
            parent_id bigint(20) DEFAULT NULL,
            title varchar(255) DEFAULT NULL,
            content text NOT NULL,
            post_type enum('text','image','video','link','poll','event') DEFAULT 'text',
            media_urls json DEFAULT NULL,
            metadata json DEFAULT NULL,
            location varchar(255) DEFAULT NULL,
            visibility enum('public','group','friends','private') DEFAULT 'public',
            status enum('published','draft','pending','approved','rejected') DEFAULT 'published',
            like_count int DEFAULT 0,
            comment_count int DEFAULT 0,
            share_count int DEFAULT 0,
            is_pinned tinyint(1) DEFAULT 0,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY author_id (author_id),
            KEY group_id (group_id),
            KEY parent_id (parent_id),
            KEY post_type (post_type),
            KEY status (status),
            KEY visibility (visibility),
            KEY created_at (created_at),
            FULLTEXT(title, content)
        ) $charset_collate;";
        
        // Community Comments Table
        $table_comments = $wpdb->prefix . 'aukrug_community_comments';
        $sql_comments = "CREATE TABLE $table_comments (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            post_id bigint(20) NOT NULL,
            author_id bigint(20) NOT NULL,
            parent_id bigint(20) DEFAULT NULL,
            content text NOT NULL,
            media_url text DEFAULT NULL,
            like_count int DEFAULT 0,
            status enum('approved','pending','rejected','spam') DEFAULT 'approved',
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY post_id (post_id),
            KEY author_id (author_id),
            KEY parent_id (parent_id),
            KEY status (status),
            KEY created_at (created_at)
        ) $charset_collate;";
        
        // Community Events Table
        $table_events = $wpdb->prefix . 'aukrug_community_events';
        $sql_events = "CREATE TABLE $table_events (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            organizer_id bigint(20) NOT NULL,
            group_id bigint(20) DEFAULT NULL,
            title varchar(255) NOT NULL,
            description text DEFAULT NULL,
            image_url text DEFAULT NULL,
            event_date datetime NOT NULL,
            end_date datetime DEFAULT NULL,
            location varchar(255) DEFAULT NULL,
            latitude decimal(10,8) DEFAULT NULL,
            longitude decimal(11,8) DEFAULT NULL,
            max_attendees int DEFAULT NULL,
            price decimal(10,2) DEFAULT 0.00,
            category varchar(100) DEFAULT NULL,
            tags json DEFAULT NULL,
            requirements text DEFAULT NULL,
            status enum('draft','published','cancelled','completed') DEFAULT 'published',
            visibility enum('public','group','private') DEFAULT 'public',
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY organizer_id (organizer_id),
            KEY group_id (group_id),
            KEY event_date (event_date),
            KEY status (status),
            KEY visibility (visibility),
            KEY category (category),
            FULLTEXT(title, description)
        ) $charset_collate;";
        
        // Event Attendees Table
        $table_event_attendees = $wpdb->prefix . 'aukrug_community_event_attendees';
        $sql_event_attendees = "CREATE TABLE $table_event_attendees (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            event_id bigint(20) NOT NULL,
            user_id bigint(20) NOT NULL,
            status enum('going','maybe','not_going','invited') DEFAULT 'going',
            registered_at datetime DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY unique_attendance (event_id, user_id),
            KEY event_id (event_id),
            KEY user_id (user_id),
            KEY status (status)
        ) $charset_collate;";
        
        // Marketplace Listings Table
        $table_marketplace = $wpdb->prefix . 'aukrug_marketplace_listings';
        $sql_marketplace = "CREATE TABLE $table_marketplace (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            seller_id bigint(20) NOT NULL,
            title varchar(255) NOT NULL,
            description text DEFAULT NULL,
            category varchar(100) NOT NULL,
            price decimal(10,2) NOT NULL,
            currency varchar(3) DEFAULT 'EUR',
            condition_type enum('new','like_new','good','fair','poor') DEFAULT 'good',
            images json DEFAULT NULL,
            location varchar(255) DEFAULT NULL,
            latitude decimal(10,8) DEFAULT NULL,
            longitude decimal(11,8) DEFAULT NULL,
            delivery_options json DEFAULT NULL,
            payment_options json DEFAULT NULL,
            status enum('active','sold','expired','suspended') DEFAULT 'active',
            featured tinyint(1) DEFAULT 0,
            view_count int DEFAULT 0,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            expires_at datetime DEFAULT NULL,
            PRIMARY KEY (id),
            KEY seller_id (seller_id),
            KEY category (category),
            KEY status (status),
            KEY price (price),
            KEY created_at (created_at),
            KEY expires_at (expires_at),
            FULLTEXT(title, description)
        ) $charset_collate;";
        
        // Community Messages Table (Private Messaging)
        $table_messages = $wpdb->prefix . 'aukrug_community_messages';
        $sql_messages = "CREATE TABLE $table_messages (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            sender_id bigint(20) NOT NULL,
            receiver_id bigint(20) NOT NULL,
            conversation_id varchar(255) NOT NULL,
            content text NOT NULL,
            message_type enum('text','image','video','audio','file') DEFAULT 'text',
            media_url text DEFAULT NULL,
            is_read tinyint(1) DEFAULT 0,
            read_at datetime DEFAULT NULL,
            status enum('sent','delivered','read','deleted') DEFAULT 'sent',
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY sender_id (sender_id),
            KEY receiver_id (receiver_id),
            KEY conversation_id (conversation_id),
            KEY is_read (is_read),
            KEY status (status),
            KEY created_at (created_at)
        ) $charset_collate;";
        
        // User Interactions Table (Likes, Follows, etc.)
        $table_interactions = $wpdb->prefix . 'aukrug_community_interactions';
        $sql_interactions = "CREATE TABLE $table_interactions (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            user_id bigint(20) NOT NULL,
            target_id bigint(20) NOT NULL,
            target_type enum('post','comment','user','group','event','listing') NOT NULL,
            interaction_type enum('like','dislike','follow','unfollow','save','report','share') NOT NULL,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY unique_interaction (user_id, target_id, target_type, interaction_type),
            KEY user_id (user_id),
            KEY target_id (target_id),
            KEY target_type (target_type),
            KEY interaction_type (interaction_type)
        ) $charset_collate;";
        
        // Content Reports Table
        $table_reports = $wpdb->prefix . 'aukrug_community_reports';
        $sql_reports = "CREATE TABLE $table_reports (
            id bigint(20) NOT NULL AUTO_INCREMENT,
            reporter_id bigint(20) NOT NULL,
            content_id bigint(20) NOT NULL,
            content_type enum('post','comment','user','group','event','listing','message') NOT NULL,
            reason enum('spam','harassment','inappropriate','copyright','fake','other') NOT NULL,
            description text DEFAULT NULL,
            status enum('pending','reviewed','resolved','dismissed') DEFAULT 'pending',
            moderator_id bigint(20) DEFAULT NULL,
            moderator_notes text DEFAULT NULL,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY reporter_id (reporter_id),
            KEY content_id (content_id),
            KEY content_type (content_type),
            KEY status (status),
            KEY moderator_id (moderator_id)
        ) $charset_collate;";
        
        require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
        
        // Create all tables
        dbDelta($sql_app_users);
        dbDelta($sql_groups);
        dbDelta($sql_group_members);
        dbDelta($sql_posts);
        dbDelta($sql_comments);
        dbDelta($sql_events);
        dbDelta($sql_event_attendees);
        dbDelta($sql_marketplace);
        dbDelta($sql_messages);
        dbDelta($sql_interactions);
        dbDelta($sql_reports);
        
        // Set database version
        update_option('aukrug_community_db_version', '1.0.0');
    }
    
    /**
     * Check if tables exist and create them if not
     */
    public static function ensure_tables_exist() {
        global $wpdb;
        
        $table_name = $wpdb->prefix . 'aukrug_app_users';
        $table_exists = $wpdb->get_var("SHOW TABLES LIKE '$table_name'") === $table_name;
        
        if (!$table_exists) {
            self::create_tables();
        }
    }
    
    /**
     * Drop all community tables (for uninstall)
     */
    public static function drop_tables() {
        global $wpdb;
        
        $tables = array(
            'aukrug_community_reports',
            'aukrug_community_interactions', 
            'aukrug_community_messages',
            'aukrug_marketplace_listings',
            'aukrug_community_event_attendees',
            'aukrug_community_events',
            'aukrug_community_comments',
            'aukrug_community_posts',
            'aukrug_community_group_members',
            'aukrug_community_groups',
            'aukrug_app_users'
        );
        
        foreach ($tables as $table) {
            $wpdb->query("DROP TABLE IF EXISTS {$wpdb->prefix}$table");
        }
        
        delete_option('aukrug_community_db_version');
    }
}

/**
 * Initialize database setup on plugin activation
 */
function aukrug_community_setup_database() {
    Aukrug_Community_Database::create_tables();
}

// Hook for plugin activation
register_activation_hook(AUKRUG_PLUGIN_DIR . 'wpaukrug.php', 'aukrug_community_setup_database');

// Ensure tables exist on admin init
add_action('admin_init', function() {
    Aukrug_Community_Database::ensure_tables_exist();
});
