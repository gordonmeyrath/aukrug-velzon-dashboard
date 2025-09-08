<?php
/**
 * Aukrug Community Management System - Fixed Version
 * Advanced community features inspired by BuddyBoss platform
 * 
 * @package Aukrug
 * @version 1.0.0
 */

if (!defined('ABSPATH')) {
    exit;
}

class Aukrug_Community {
    
    private static $instance = null;
    private $table_prefix;
    
    public static function get_instance() {
        if (null === self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }
    
    public function __construct() {
        global $wpdb;
        $this->table_prefix = $wpdb->prefix . 'aukrug_';
        
        // Hook into WordPress initialization - functions will be available
        add_action('init', [$this, 'init']);
        add_action('rest_api_init', [$this, 'register_rest_routes']);
        add_action('wp_enqueue_scripts', [$this, 'enqueue_scripts']);
        
        // Database setup on activation
        register_activation_hook(AUKRUG_PLUGIN_FILE, [$this, 'create_database_tables']);
        register_activation_hook(AUKRUG_PLUGIN_FILE, [$this, 'create_user_roles']);
    }
    
    public function init() {
        $this->register_post_types();
        
        // Set up community permissions
        $this->setup_permissions();
        
        // Initialize community features if database exists
        if ($this->check_database_tables()) {
            $this->setup_community_features();
        }
    }
    
    /**
     * Register custom post types for community
     */
    public function register_post_types() {
        // Community Groups
        register_post_type('aukrug_group', [
            'label' => 'Community Groups',
            'public' => true,
            'publicly_queryable' => true,
            'show_ui' => true,
            'show_in_menu' => false,
            'show_in_rest' => true,
            'capability_type' => 'post',
            'hierarchical' => false,
            'supports' => ['title', 'editor', 'thumbnail', 'custom-fields'],
            'labels' => [
                'name' => 'Groups',
                'singular_name' => 'Group',
                'add_new' => 'Add New Group',
                'add_new_item' => 'Add New Group',
                'edit_item' => 'Edit Group',
                'new_item' => 'New Group',
                'view_item' => 'View Group'
            ]
        ]);
        
        // Community Events
        register_post_type('aukrug_event', [
            'label' => 'Community Events',
            'public' => true,
            'publicly_queryable' => true,
            'show_ui' => true,
            'show_in_menu' => false,
            'show_in_rest' => true,
            'capability_type' => 'post',
            'hierarchical' => false,
            'supports' => ['title', 'editor', 'thumbnail', 'custom-fields'],
            'labels' => [
                'name' => 'Events',
                'singular_name' => 'Event',
                'add_new' => 'Add New Event',
                'add_new_item' => 'Add New Event',
                'edit_item' => 'Edit Event',
                'new_item' => 'New Event',
                'view_item' => 'View Event'
            ]
        ]);
        
        // Marketplace Items
        register_post_type('aukrug_marketplace', [
            'label' => 'Marketplace',
            'public' => true,
            'publicly_queryable' => true,
            'show_ui' => true,
            'show_in_menu' => false,
            'show_in_rest' => true,
            'capability_type' => 'post',
            'hierarchical' => false,
            'supports' => ['title', 'editor', 'thumbnail', 'custom-fields'],
            'labels' => [
                'name' => 'Marketplace Items',
                'singular_name' => 'Item',
                'add_new' => 'Add New Item',
                'add_new_item' => 'Add New Item',
                'edit_item' => 'Edit Item',
                'new_item' => 'New Item',
                'view_item' => 'View Item'
            ]
        ]);
    }
    
    /**
     * Create custom user roles for community
     */
    public function create_user_roles() {
        // Verified Resident Role
        add_role('verified_resident', 'Verified Resident', [
            'read' => true,
            'edit_posts' => false,
            'delete_posts' => false,
            'upload_files' => true,
            'aukrug_create_groups' => true,
            'aukrug_create_events' => true,
            'aukrug_join_groups' => true,
            'aukrug_comment_posts' => true,
            'aukrug_use_marketplace' => true
        ]);
        
        // Group Leader Role
        add_role('group_leader', 'Group Leader', [
            'read' => true,
            'edit_posts' => true,
            'delete_posts' => false,
            'upload_files' => true,
            'aukrug_create_groups' => true,
            'aukrug_create_events' => true,
            'aukrug_manage_groups' => true,
            'aukrug_moderate_content' => true,
            'aukrug_join_groups' => true,
            'aukrug_comment_posts' => true,
            'aukrug_use_marketplace' => true
        ]);
        
        // Community Moderator Role
        add_role('community_moderator', 'Community Moderator', [
            'read' => true,
            'edit_posts' => true,
            'delete_posts' => true,
            'edit_others_posts' => true,
            'delete_others_posts' => true,
            'upload_files' => true,
            'aukrug_create_groups' => true,
            'aukrug_create_events' => true,
            'aukrug_manage_groups' => true,
            'aukrug_moderate_content' => true,
            'aukrug_manage_users' => true,
            'aukrug_join_groups' => true,
            'aukrug_comment_posts' => true,
            'aukrug_use_marketplace' => true
        ]);
    }
    
    /**
     * Create database tables for community features
     */
    public function create_database_tables() {
        global $wpdb;
        
        require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
        
        $charset_collate = $wpdb->get_charset_collate();
        
        // User Profiles Extended
        $table_name = $this->table_prefix . 'user_profiles';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            user_id bigint(20) unsigned NOT NULL,
            bio text,
            location varchar(255),
            website varchar(255),
            phone varchar(50),
            address text,
            verification_status enum('pending','verified','rejected') DEFAULT 'pending',
            verification_document varchar(255),
            privacy_settings text,
            notification_settings text,
            social_links text,
            interests text,
            skills text,
            created_at timestamp DEFAULT CURRENT_TIMESTAMP,
            updated_at timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY user_id (user_id),
            KEY verification_status (verification_status)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Groups
        $table_name = $this->table_prefix . 'groups';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            name varchar(255) NOT NULL,
            description text,
            type enum('public','private','secret') DEFAULT 'public',
            status enum('active','inactive','suspended') DEFAULT 'active',
            category varchar(100),
            location varchar(255),
            cover_image varchar(255),
            creator_id bigint(20) unsigned NOT NULL,
            member_count int(11) DEFAULT 0,
            post_count int(11) DEFAULT 0,
            settings text,
            created_at timestamp DEFAULT CURRENT_TIMESTAMP,
            updated_at timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY creator_id (creator_id),
            KEY type (type),
            KEY status (status),
            KEY category (category)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Group Members
        $table_name = $this->table_prefix . 'group_members';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            group_id bigint(20) unsigned NOT NULL,
            user_id bigint(20) unsigned NOT NULL,
            role enum('member','moderator','admin') DEFAULT 'member',
            status enum('active','banned','pending') DEFAULT 'active',
            joined_at timestamp DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY group_user (group_id, user_id),
            KEY group_id (group_id),
            KEY user_id (user_id),
            KEY role (role),
            KEY status (status)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Community Posts
        $table_name = $this->table_prefix . 'posts';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            user_id bigint(20) unsigned NOT NULL,
            group_id bigint(20) unsigned NULL,
            content text NOT NULL,
            type enum('text','image','video','link','poll','event') DEFAULT 'text',
            attachments text,
            visibility enum('public','friends','group','private') DEFAULT 'public',
            location varchar(255),
            tags text,
            status enum('published','draft','moderated','deleted') DEFAULT 'published',
            like_count int(11) DEFAULT 0,
            comment_count int(11) DEFAULT 0,
            share_count int(11) DEFAULT 0,
            created_at timestamp DEFAULT CURRENT_TIMESTAMP,
            updated_at timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY user_id (user_id),
            KEY group_id (group_id),
            KEY type (type),
            KEY visibility (visibility),
            KEY status (status),
            KEY created_at (created_at)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Comments
        $table_name = $this->table_prefix . 'comments';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            post_id bigint(20) unsigned NOT NULL,
            user_id bigint(20) unsigned NOT NULL,
            parent_id bigint(20) unsigned NULL,
            content text NOT NULL,
            attachments text,
            status enum('approved','pending','spam','deleted') DEFAULT 'approved',
            like_count int(11) DEFAULT 0,
            created_at timestamp DEFAULT CURRENT_TIMESTAMP,
            updated_at timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY post_id (post_id),
            KEY user_id (user_id),
            KEY parent_id (parent_id),
            KEY status (status)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Events
        $table_name = $this->table_prefix . 'events';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            title varchar(255) NOT NULL,
            description text,
            organizer_id bigint(20) unsigned NOT NULL,
            group_id bigint(20) unsigned NULL,
            start_date datetime NOT NULL,
            end_date datetime NOT NULL,
            location varchar(255),
            address text,
            latitude decimal(10,8),
            longitude decimal(11,8),
            type enum('public','private','group') DEFAULT 'public',
            category varchar(100),
            max_attendees int(11),
            attendee_count int(11) DEFAULT 0,
            status enum('draft','published','cancelled','completed') DEFAULT 'draft',
            cover_image varchar(255),
            settings text,
            created_at timestamp DEFAULT CURRENT_TIMESTAMP,
            updated_at timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY organizer_id (organizer_id),
            KEY group_id (group_id),
            KEY start_date (start_date),
            KEY type (type),
            KEY status (status)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Event Attendees
        $table_name = $this->table_prefix . 'event_attendees';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            event_id bigint(20) unsigned NOT NULL,
            user_id bigint(20) unsigned NOT NULL,
            status enum('going','maybe','not_going','invited') DEFAULT 'going',
            registered_at timestamp DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY event_user (event_id, user_id),
            KEY event_id (event_id),
            KEY user_id (user_id),
            KEY status (status)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Messages
        $table_name = $this->table_prefix . 'messages';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            conversation_id bigint(20) unsigned NOT NULL,
            sender_id bigint(20) unsigned NOT NULL,
            content text NOT NULL,
            message_type enum('text','image','file','location') DEFAULT 'text',
            attachments text,
            status enum('sent','delivered','read','deleted') DEFAULT 'sent',
            created_at timestamp DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY conversation_id (conversation_id),
            KEY sender_id (sender_id),
            KEY status (status),
            KEY created_at (created_at)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Conversations
        $table_name = $this->table_prefix . 'conversations';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            type enum('private','group') DEFAULT 'private',
            title varchar(255),
            created_by bigint(20) unsigned NOT NULL,
            last_message_id bigint(20) unsigned NULL,
            last_activity datetime DEFAULT CURRENT_TIMESTAMP,
            status enum('active','archived','deleted') DEFAULT 'active',
            created_at timestamp DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY created_by (created_by),
            KEY last_activity (last_activity),
            KEY status (status)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Conversation Participants
        $table_name = $this->table_prefix . 'conversation_participants';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            conversation_id bigint(20) unsigned NOT NULL,
            user_id bigint(20) unsigned NOT NULL,
            joined_at timestamp DEFAULT CURRENT_TIMESTAMP,
            last_read_message_id bigint(20) unsigned NULL,
            status enum('active','left','removed') DEFAULT 'active',
            PRIMARY KEY (id),
            UNIQUE KEY conversation_user (conversation_id, user_id),
            KEY conversation_id (conversation_id),
            KEY user_id (user_id)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Friendships/Connections
        $table_name = $this->table_prefix . 'friendships';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            initiator_id bigint(20) unsigned NOT NULL,
            friend_id bigint(20) unsigned NOT NULL,
            status enum('pending','accepted','blocked','declined') DEFAULT 'pending',
            created_at timestamp DEFAULT CURRENT_TIMESTAMP,
            accepted_at timestamp NULL,
            PRIMARY KEY (id),
            UNIQUE KEY friendship_pair (initiator_id, friend_id),
            KEY initiator_id (initiator_id),
            KEY friend_id (friend_id),
            KEY status (status)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Notifications
        $table_name = $this->table_prefix . 'notifications';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            user_id bigint(20) unsigned NOT NULL,
            type varchar(50) NOT NULL,
            title varchar(255) NOT NULL,
            content text,
            related_id bigint(20) unsigned NULL,
            related_type varchar(50) NULL,
            sender_id bigint(20) unsigned NULL,
            status enum('unread','read','archived') DEFAULT 'unread',
            created_at timestamp DEFAULT CURRENT_TIMESTAMP,
            read_at timestamp NULL,
            PRIMARY KEY (id),
            KEY user_id (user_id),
            KEY type (type),
            KEY status (status),
            KEY created_at (created_at)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Activity Feed
        $table_name = $this->table_prefix . 'activity';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            user_id bigint(20) unsigned NOT NULL,
            action_type varchar(50) NOT NULL,
            object_type varchar(50),
            object_id bigint(20) unsigned NULL,
            visibility enum('public','friends','group','private') DEFAULT 'public',
            content text,
            metadata text,
            created_at timestamp DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY user_id (user_id),
            KEY action_type (action_type),
            KEY object_type (object_type),
            KEY visibility (visibility),
            KEY created_at (created_at)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Marketplace
        $table_name = $this->table_prefix . 'marketplace';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            seller_id bigint(20) unsigned NOT NULL,
            title varchar(255) NOT NULL,
            description text,
            category varchar(100),
            price decimal(10,2),
            currency varchar(3) DEFAULT 'EUR',
            condition_type enum('new','like_new','good','fair','poor') DEFAULT 'good',
            location varchar(255),
            images text,
            status enum('available','sold','reserved','expired') DEFAULT 'available',
            views int(11) DEFAULT 0,
            created_at timestamp DEFAULT CURRENT_TIMESTAMP,
            updated_at timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            expires_at timestamp NULL,
            PRIMARY KEY (id),
            KEY seller_id (seller_id),
            KEY category (category),
            KEY status (status),
            KEY created_at (created_at)
        ) $charset_collate;";
        dbDelta($sql);
        
        // Likes/Reactions
        $table_name = $this->table_prefix . 'reactions';
        $sql = "CREATE TABLE $table_name (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            user_id bigint(20) unsigned NOT NULL,
            object_type enum('post','comment','event','marketplace') NOT NULL,
            object_id bigint(20) unsigned NOT NULL,
            reaction_type enum('like','love','laugh','angry','sad') DEFAULT 'like',
            created_at timestamp DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY user_object (user_id, object_type, object_id),
            KEY object_type_id (object_type, object_id),
            KEY user_id (user_id)
        ) $charset_collate;";
        dbDelta($sql);
    }
    
    /**
     * Check if database tables exist
     */
    private function check_database_tables() {
        global $wpdb;
        $table_name = $this->table_prefix . 'user_profiles';
        return $wpdb->get_var("SHOW TABLES LIKE '$table_name'") === $table_name;
    }
    
    /**
     * Setup community permissions
     */
    private function setup_permissions() {
        // Add capabilities to existing roles
        $admin = get_role('administrator');
        if ($admin) {
            $admin->add_cap('aukrug_manage_community');
            $admin->add_cap('aukrug_moderate_content');
            $admin->add_cap('aukrug_manage_users');
            $admin->add_cap('aukrug_manage_groups');
            $admin->add_cap('aukrug_create_groups');
            $admin->add_cap('aukrug_create_events');
        }
        
        $editor = get_role('editor');
        if ($editor) {
            $editor->add_cap('aukrug_moderate_content');
            $editor->add_cap('aukrug_create_groups');
            $editor->add_cap('aukrug_create_events');
        }
    }
    
    /**
     * Setup community features
     */
    private function setup_community_features() {
        // Initialize feature modules here
        $this->init_activity_tracking();
        $this->init_notification_system();
    }
    
    /**
     * Initialize activity tracking
     */
    private function init_activity_tracking() {
        // Track user activities
        add_action('wp_insert_post', [$this, 'track_post_activity']);
        add_action('wp_insert_comment', [$this, 'track_comment_activity']);
    }
    
    /**
     * Initialize notification system
     */
    private function init_notification_system() {
        // Setup notification triggers
        add_action('aukrug_new_friend_request', [$this, 'send_friend_request_notification']);
        add_action('aukrug_group_invitation', [$this, 'send_group_invitation_notification']);
    }
    
    /**
     * Track post activity
     */
    public function track_post_activity($post_id) {
        $post = get_post($post_id);
        if ($post && $post->post_status === 'publish') {
            $this->create_activity_entry($post->post_author, 'created_post', 'post', $post_id);
        }
    }
    
    /**
     * Track comment activity
     */
    public function track_comment_activity($comment_id) {
        $comment = get_comment($comment_id);
        if ($comment && $comment->comment_approved === '1') {
            $this->create_activity_entry($comment->user_id, 'created_comment', 'comment', $comment_id);
        }
    }
    
    /**
     * Create activity entry
     */
    private function create_activity_entry($user_id, $action_type, $object_type = null, $object_id = null) {
        global $wpdb;
        
        $table_name = $this->table_prefix . 'activity';
        
        $wpdb->insert(
            $table_name,
            [
                'user_id' => $user_id,
                'action_type' => $action_type,
                'object_type' => $object_type,
                'object_id' => $object_id,
                'created_at' => current_time('mysql')
            ]
        );
    }
    
    /**
     * Register REST API routes
     */
    public function register_rest_routes() {
        $namespace = 'aukrug/v1';
        
        // User Profile Routes
        register_rest_route($namespace, '/profiles/(?P<user_id>\d+)', [
            'methods' => 'GET',
            'callback' => [$this, 'get_user_profile'],
            'permission_callback' => [$this, 'check_read_permission']
        ]);
        
        register_rest_route($namespace, '/profiles/(?P<user_id>\d+)', [
            'methods' => 'PUT',
            'callback' => [$this, 'update_user_profile'],
            'permission_callback' => [$this, 'check_edit_profile_permission']
        ]);
        
        // Groups Routes
        register_rest_route($namespace, '/groups', [
            'methods' => 'GET',
            'callback' => [$this, 'get_groups'],
            'permission_callback' => [$this, 'check_read_permission']
        ]);
        
        register_rest_route($namespace, '/groups', [
            'methods' => 'POST',
            'callback' => [$this, 'create_group'],
            'permission_callback' => [$this, 'check_create_group_permission']
        ]);
        
        register_rest_route($namespace, '/groups/(?P<group_id>\d+)', [
            'methods' => 'GET',
            'callback' => [$this, 'get_group'],
            'permission_callback' => [$this, 'check_read_permission']
        ]);
        
        register_rest_route($namespace, '/groups/(?P<group_id>\d+)/join', [
            'methods' => 'POST',
            'callback' => [$this, 'join_group'],
            'permission_callback' => [$this, 'check_join_group_permission']
        ]);
        
        // Posts Routes
        register_rest_route($namespace, '/posts', [
            'methods' => 'GET',
            'callback' => [$this, 'get_posts'],
            'permission_callback' => [$this, 'check_read_permission']
        ]);
        
        register_rest_route($namespace, '/posts', [
            'methods' => 'POST',
            'callback' => [$this, 'create_post'],
            'permission_callback' => [$this, 'check_create_post_permission']
        ]);
        
        // Events Routes
        register_rest_route($namespace, '/events', [
            'methods' => 'GET',
            'callback' => [$this, 'get_events'],
            'permission_callback' => [$this, 'check_read_permission']
        ]);
        
        register_rest_route($namespace, '/events', [
            'methods' => 'POST',
            'callback' => [$this, 'create_event'],
            'permission_callback' => [$this, 'check_create_event_permission']
        ]);
        
        // Messages Routes
        register_rest_route($namespace, '/messages/conversations', [
            'methods' => 'GET',
            'callback' => [$this, 'get_conversations'],
            'permission_callback' => [$this, 'check_message_permission']
        ]);
        
        register_rest_route($namespace, '/messages/(?P<conversation_id>\d+)', [
            'methods' => 'GET',
            'callback' => [$this, 'get_messages'],
            'permission_callback' => [$this, 'check_message_permission']
        ]);
        
        register_rest_route($namespace, '/messages', [
            'methods' => 'POST',
            'callback' => [$this, 'send_message'],
            'permission_callback' => [$this, 'check_message_permission']
        ]);
        
        // Activity Routes
        register_rest_route($namespace, '/activity', [
            'methods' => 'GET',
            'callback' => [$this, 'get_activity_feed'],
            'permission_callback' => [$this, 'check_read_permission']
        ]);
        
        // Notifications Routes
        register_rest_route($namespace, '/notifications', [
            'methods' => 'GET',
            'callback' => [$this, 'get_notifications'],
            'permission_callback' => [$this, 'check_notification_permission']
        ]);
        
        // Marketplace Routes
        register_rest_route($namespace, '/marketplace', [
            'methods' => 'GET',
            'callback' => [$this, 'get_marketplace_items'],
            'permission_callback' => [$this, 'check_read_permission']
        ]);
        
        register_rest_route($namespace, '/marketplace', [
            'methods' => 'POST',
            'callback' => [$this, 'create_marketplace_item'],
            'permission_callback' => [$this, 'check_marketplace_permission']
        ]);
    }
    
    /**
     * Permission callback functions
     */
    public function check_read_permission() {
        return is_user_logged_in();
    }
    
    public function check_edit_profile_permission($request) {
        $current_user_id = get_current_user_id();
        $target_user_id = $request->get_param('user_id');
        
        return $current_user_id === (int)$target_user_id || current_user_can('aukrug_manage_users');
    }
    
    public function check_create_group_permission() {
        return current_user_can('aukrug_create_groups');
    }
    
    public function check_join_group_permission() {
        return current_user_can('aukrug_join_groups');
    }
    
    public function check_create_post_permission() {
        return current_user_can('aukrug_comment_posts');
    }
    
    public function check_create_event_permission() {
        return current_user_can('aukrug_create_events');
    }
    
    public function check_message_permission() {
        return is_user_logged_in();
    }
    
    public function check_notification_permission() {
        return is_user_logged_in();
    }
    
    public function check_marketplace_permission() {
        return current_user_can('aukrug_use_marketplace');
    }
    
    /**
     * REST API Handlers - Placeholder implementations
     */
    public function get_user_profile($request) {
        $user_id = $request->get_param('user_id');
        // Implementation here
        return rest_ensure_response(['user_id' => $user_id, 'status' => 'success']);
    }
    
    public function update_user_profile($request) {
        // Implementation here
        return rest_ensure_response(['status' => 'updated']);
    }
    
    public function get_groups($request) {
        // Implementation here
        return rest_ensure_response(['groups' => []]);
    }
    
    public function create_group($request) {
        // Implementation here
        return rest_ensure_response(['status' => 'created']);
    }
    
    public function get_group($request) {
        $group_id = $request->get_param('group_id');
        // Implementation here
        return rest_ensure_response(['group_id' => $group_id]);
    }
    
    public function join_group($request) {
        // Implementation here
        return rest_ensure_response(['status' => 'joined']);
    }
    
    public function get_posts($request) {
        // Implementation here
        return rest_ensure_response(['posts' => []]);
    }
    
    public function create_post($request) {
        // Implementation here
        return rest_ensure_response(['status' => 'created']);
    }
    
    public function get_events($request) {
        // Implementation here
        return rest_ensure_response(['events' => []]);
    }
    
    public function create_event($request) {
        // Implementation here
        return rest_ensure_response(['status' => 'created']);
    }
    
    public function get_conversations($request) {
        // Implementation here
        return rest_ensure_response(['conversations' => []]);
    }
    
    public function get_messages($request) {
        // Implementation here
        return rest_ensure_response(['messages' => []]);
    }
    
    public function send_message($request) {
        // Implementation here
        return rest_ensure_response(['status' => 'sent']);
    }
    
    public function get_activity_feed($request) {
        // Implementation here
        return rest_ensure_response(['activities' => []]);
    }
    
    public function get_notifications($request) {
        // Implementation here
        return rest_ensure_response(['notifications' => []]);
    }
    
    public function get_marketplace_items($request) {
        // Implementation here
        return rest_ensure_response(['items' => []]);
    }
    
    public function create_marketplace_item($request) {
        // Implementation here
        return rest_ensure_response(['status' => 'created']);
    }
    
    /**
     * Enqueue frontend scripts
     */
    public function enqueue_scripts() {
        if (is_user_logged_in()) {
            wp_enqueue_script(
                'aukrug-community',
                plugin_dir_url(__FILE__) . '../assets/js/community.js',
                ['jquery'],
                '1.0.0',
                true
            );
            
            wp_localize_script('aukrug-community', 'aukrugCommunity', [
                'apiUrl' => rest_url('aukrug/v1/'),
                'nonce' => wp_create_nonce('wp_rest'),
                'userId' => get_current_user_id()
            ]);
        }
    }
    
    /**
     * Notification helper functions
     */
    public function send_friend_request_notification($data) {
        // Implementation for friend request notifications
    }
    
    public function send_group_invitation_notification($data) {
        // Implementation for group invitation notifications
    }
}

// Initialize the community system
Aukrug_Community::get_instance();
