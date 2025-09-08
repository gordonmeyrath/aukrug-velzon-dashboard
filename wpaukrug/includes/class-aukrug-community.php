<?php
/**
 * Aukrug Community Management System
 * Inspired by BuddyBoss features for comprehensive community functionality
 * 
 * @package Aukrug
 * @version 1.0.0
 */

if (!defined('ABSPATH')) {
    exit;
}

class Aukrug_Community {
    
    private static $instance = null;
    
    public static function get_instance() {
        if (null === self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }
    
    public function __construct() {
        add_action('init', [$this, 'init']);
        add_action('rest_api_init', [$this, 'register_rest_routes']);
        add_action('wp_enqueue_scripts', [$this, 'enqueue_scripts']);
    }
    
    public function init() {
        $this->create_database_tables();
        $this->register_post_types();
        $this->register_user_roles();
    }
    
    /**
     * Create comprehensive community database tables
     */
    private function create_database_tables() {
        global $wpdb;
        
        $charset_collate = $wpdb->get_charset_collate();
        
        // Users extended profile table
        $users_profile_table = $wpdb->prefix . 'aukrug_user_profiles';
        $sql_users = "CREATE TABLE $users_profile_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            user_id bigint(20) unsigned NOT NULL,
            avatar_url varchar(255) DEFAULT NULL,
            cover_photo_url varchar(255) DEFAULT NULL,
            bio longtext DEFAULT NULL,
            location varchar(255) DEFAULT NULL,
            phone varchar(50) DEFAULT NULL,
            website varchar(255) DEFAULT NULL,
            social_links json DEFAULT NULL,
            privacy_settings json DEFAULT NULL,
            notification_settings json DEFAULT NULL,
            verification_status enum('unverified','pending','verified') DEFAULT 'unverified',
            verification_date datetime DEFAULT NULL,
            last_activity datetime DEFAULT CURRENT_TIMESTAMP,
            points int(11) DEFAULT 0,
            level varchar(50) DEFAULT 'newcomer',
            badges json DEFAULT NULL,
            interests json DEFAULT NULL,
            skills json DEFAULT NULL,
            availability json DEFAULT NULL,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY user_id (user_id),
            KEY last_activity (last_activity),
            KEY verification_status (verification_status)
        ) $charset_collate;";
        
        // Community Groups table
        $groups_table = $wpdb->prefix . 'aukrug_groups';
        $sql_groups = "CREATE TABLE $groups_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            name varchar(255) NOT NULL,
            slug varchar(255) NOT NULL,
            description longtext DEFAULT NULL,
            cover_image varchar(255) DEFAULT NULL,
            type enum('public','private','secret') DEFAULT 'public',
            status enum('active','inactive','archived') DEFAULT 'active',
            creator_id bigint(20) unsigned NOT NULL,
            category varchar(100) DEFAULT NULL,
            tags json DEFAULT NULL,
            location varchar(255) DEFAULT NULL,
            max_members int(11) DEFAULT NULL,
            join_policy enum('open','request','invite_only') DEFAULT 'open',
            settings json DEFAULT NULL,
            statistics json DEFAULT NULL,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY slug (slug),
            KEY creator_id (creator_id),
            KEY type (type),
            KEY status (status),
            KEY category (category)
        ) $charset_collate;";
        
        // Group Members table
        $group_members_table = $wpdb->prefix . 'aukrug_group_members';
        $sql_group_members = "CREATE TABLE $group_members_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            group_id bigint(20) unsigned NOT NULL,
            user_id bigint(20) unsigned NOT NULL,
            role enum('member','moderator','admin') DEFAULT 'member',
            status enum('active','pending','banned','left') DEFAULT 'active',
            joined_at datetime DEFAULT CURRENT_TIMESTAMP,
            last_activity datetime DEFAULT CURRENT_TIMESTAMP,
            invitation_accepted_at datetime DEFAULT NULL,
            invited_by bigint(20) unsigned DEFAULT NULL,
            PRIMARY KEY (id),
            UNIQUE KEY group_user (group_id, user_id),
            KEY user_id (user_id),
            KEY role (role),
            KEY status (status)
        ) $charset_collate;";
        
        // Community Posts table
        $posts_table = $wpdb->prefix . 'aukrug_community_posts';
        $sql_posts = "CREATE TABLE $posts_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            author_id bigint(20) unsigned NOT NULL,
            group_id bigint(20) unsigned DEFAULT NULL,
            parent_id bigint(20) unsigned DEFAULT NULL,
            type enum('text','image','video','link','poll','event','marketplace','announcement') DEFAULT 'text',
            title varchar(255) DEFAULT NULL,
            content longtext NOT NULL,
            media_urls json DEFAULT NULL,
            tags json DEFAULT NULL,
            location varchar(255) DEFAULT NULL,
            privacy enum('public','friends','group','private') DEFAULT 'public',
            status enum('published','draft','pending','archived','deleted') DEFAULT 'published',
            featured boolean DEFAULT FALSE,
            pinned boolean DEFAULT FALSE,
            comments_enabled boolean DEFAULT TRUE,
            likes_count int(11) DEFAULT 0,
            comments_count int(11) DEFAULT 0,
            shares_count int(11) DEFAULT 0,
            views_count int(11) DEFAULT 0,
            poll_data json DEFAULT NULL,
            event_data json DEFAULT NULL,
            marketplace_data json DEFAULT NULL,
            scheduled_at datetime DEFAULT NULL,
            published_at datetime DEFAULT CURRENT_TIMESTAMP,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY author_id (author_id),
            KEY group_id (group_id),
            KEY parent_id (parent_id),
            KEY type (type),
            KEY privacy (privacy),
            KEY status (status),
            KEY featured (featured),
            KEY published_at (published_at)
        ) $charset_collate;";
        
        // Post Interactions table (likes, reactions, etc.)
        $interactions_table = $wpdb->prefix . 'aukrug_post_interactions';
        $sql_interactions = "CREATE TABLE $interactions_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            post_id bigint(20) unsigned NOT NULL,
            user_id bigint(20) unsigned NOT NULL,
            type enum('like','love','laugh','angry','sad','wow','dislike') DEFAULT 'like',
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            UNIQUE KEY post_user_type (post_id, user_id, type),
            KEY user_id (user_id),
            KEY type (type)
        ) $charset_collate;";
        
        // Comments table
        $comments_table = $wpdb->prefix . 'aukrug_community_comments';
        $sql_comments = "CREATE TABLE $comments_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            post_id bigint(20) unsigned NOT NULL,
            parent_id bigint(20) unsigned DEFAULT NULL,
            author_id bigint(20) unsigned NOT NULL,
            content longtext NOT NULL,
            media_urls json DEFAULT NULL,
            mentions json DEFAULT NULL,
            likes_count int(11) DEFAULT 0,
            status enum('published','pending','spam','deleted') DEFAULT 'published',
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY post_id (post_id),
            KEY parent_id (parent_id),
            KEY author_id (author_id),
            KEY status (status)
        ) $charset_collate;";
        
        // Direct Messages table
        $messages_table = $wpdb->prefix . 'aukrug_messages';
        $sql_messages = "CREATE TABLE $messages_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            conversation_id varchar(255) NOT NULL,
            sender_id bigint(20) unsigned NOT NULL,
            content longtext NOT NULL,
            message_type enum('text','image','video','file','location','poll') DEFAULT 'text',
            media_urls json DEFAULT NULL,
            mentions json DEFAULT NULL,
            read_by json DEFAULT NULL,
            delivered_to json DEFAULT NULL,
            edited boolean DEFAULT FALSE,
            deleted boolean DEFAULT FALSE,
            reply_to bigint(20) unsigned DEFAULT NULL,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY conversation_id (conversation_id),
            KEY sender_id (sender_id),
            KEY created_at (created_at)
        ) $charset_collate;";
        
        // Conversation Participants table
        $participants_table = $wpdb->prefix . 'aukrug_conversation_participants';
        $sql_participants = "CREATE TABLE $participants_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            conversation_id varchar(255) NOT NULL,
            user_id bigint(20) unsigned NOT NULL,
            role enum('member','admin') DEFAULT 'member',
            joined_at datetime DEFAULT CURRENT_TIMESTAMP,
            last_read datetime DEFAULT NULL,
            notifications_enabled boolean DEFAULT TRUE,
            PRIMARY KEY (id),
            UNIQUE KEY conversation_user (conversation_id, user_id),
            KEY user_id (user_id)
        ) $charset_collate;";
        
        // Events table
        $events_table = $wpdb->prefix . 'aukrug_events';
        $sql_events = "CREATE TABLE $events_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            organizer_id bigint(20) unsigned NOT NULL,
            group_id bigint(20) unsigned DEFAULT NULL,
            title varchar(255) NOT NULL,
            description longtext DEFAULT NULL,
            cover_image varchar(255) DEFAULT NULL,
            event_type enum('online','offline','hybrid') DEFAULT 'offline',
            category varchar(100) DEFAULT NULL,
            start_datetime datetime NOT NULL,
            end_datetime datetime DEFAULT NULL,
            timezone varchar(100) DEFAULT 'Europe/Berlin',
            location_name varchar(255) DEFAULT NULL,
            address longtext DEFAULT NULL,
            latitude decimal(10,8) DEFAULT NULL,
            longitude decimal(11,8) DEFAULT NULL,
            online_link varchar(255) DEFAULT NULL,
            max_attendees int(11) DEFAULT NULL,
            price decimal(10,2) DEFAULT 0.00,
            currency varchar(3) DEFAULT 'EUR',
            requires_approval boolean DEFAULT FALSE,
            is_public boolean DEFAULT TRUE,
            recurring_pattern json DEFAULT NULL,
            custom_fields json DEFAULT NULL,
            status enum('draft','published','cancelled','postponed','completed') DEFAULT 'draft',
            attendees_count int(11) DEFAULT 0,
            views_count int(11) DEFAULT 0,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY organizer_id (organizer_id),
            KEY group_id (group_id),
            KEY event_type (event_type),
            KEY start_datetime (start_datetime),
            KEY status (status),
            KEY is_public (is_public)
        ) $charset_collate;";
        
        // Event Attendees table
        $attendees_table = $wpdb->prefix . 'aukrug_event_attendees';
        $sql_attendees = "CREATE TABLE $attendees_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            event_id bigint(20) unsigned NOT NULL,
            user_id bigint(20) unsigned NOT NULL,
            status enum('going','maybe','not_going','pending') DEFAULT 'going',
            rsvp_date datetime DEFAULT CURRENT_TIMESTAMP,
            plus_ones int(11) DEFAULT 0,
            notes longtext DEFAULT NULL,
            payment_status enum('pending','paid','refunded') DEFAULT 'pending',
            payment_id varchar(255) DEFAULT NULL,
            checked_in boolean DEFAULT FALSE,
            checked_in_at datetime DEFAULT NULL,
            PRIMARY KEY (id),
            UNIQUE KEY event_user (event_id, user_id),
            KEY user_id (user_id),
            KEY status (status),
            KEY payment_status (payment_status)
        ) $charset_collate;";
        
        // Friendships/Connections table
        $friendships_table = $wpdb->prefix . 'aukrug_friendships';
        $sql_friendships = "CREATE TABLE $friendships_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            requester_id bigint(20) unsigned NOT NULL,
            requested_id bigint(20) unsigned NOT NULL,
            status enum('pending','accepted','blocked','declined') DEFAULT 'pending',
            type enum('friend','follow','block') DEFAULT 'follow',
            requested_at datetime DEFAULT CURRENT_TIMESTAMP,
            responded_at datetime DEFAULT NULL,
            PRIMARY KEY (id),
            UNIQUE KEY requester_requested (requester_id, requested_id),
            KEY requested_id (requested_id),
            KEY status (status),
            KEY type (type)
        ) $charset_collate;";
        
        // Notifications table
        $notifications_table = $wpdb->prefix . 'aukrug_notifications';
        $sql_notifications = "CREATE TABLE $notifications_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            user_id bigint(20) unsigned NOT NULL,
            type varchar(100) NOT NULL,
            title varchar(255) NOT NULL,
            message longtext NOT NULL,
            action_url varchar(255) DEFAULT NULL,
            data json DEFAULT NULL,
            read_status boolean DEFAULT FALSE,
            read_at datetime DEFAULT NULL,
            sent_via json DEFAULT NULL,
            scheduled_for datetime DEFAULT NULL,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY user_id (user_id),
            KEY type (type),
            KEY read_status (read_status),
            KEY created_at (created_at)
        ) $charset_collate;";
        
        // Activity Feed table
        $activity_table = $wpdb->prefix . 'aukrug_activity';
        $sql_activity = "CREATE TABLE $activity_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            user_id bigint(20) unsigned NOT NULL,
            action_type varchar(100) NOT NULL,
            object_type varchar(100) NOT NULL,
            object_id bigint(20) unsigned NOT NULL,
            secondary_object_type varchar(100) DEFAULT NULL,
            secondary_object_id bigint(20) unsigned DEFAULT NULL,
            content longtext DEFAULT NULL,
            privacy enum('public','friends','group','private') DEFAULT 'public',
            hide_sitewide boolean DEFAULT FALSE,
            metadata json DEFAULT NULL,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY user_id (user_id),
            KEY action_type (action_type),
            KEY object_type (object_type),
            KEY object_id (object_id),
            KEY privacy (privacy),
            KEY created_at (created_at)
        ) $charset_collate;";
        
        // Marketplace table for buy/sell posts
        $marketplace_table = $wpdb->prefix . 'aukrug_marketplace';
        $sql_marketplace = "CREATE TABLE $marketplace_table (
            id bigint(20) unsigned NOT NULL AUTO_INCREMENT,
            seller_id bigint(20) unsigned NOT NULL,
            post_id bigint(20) unsigned DEFAULT NULL,
            title varchar(255) NOT NULL,
            description longtext DEFAULT NULL,
            category varchar(100) DEFAULT NULL,
            condition_type enum('new','like_new','good','fair','poor') DEFAULT 'good',
            price decimal(10,2) NOT NULL,
            currency varchar(3) DEFAULT 'EUR',
            negotiable boolean DEFAULT TRUE,
            images json DEFAULT NULL,
            location varchar(255) DEFAULT NULL,
            delivery_options json DEFAULT NULL,
            payment_methods json DEFAULT NULL,
            status enum('available','sold','reserved','expired') DEFAULT 'available',
            views_count int(11) DEFAULT 0,
            favorites_count int(11) DEFAULT 0,
            sold_to bigint(20) unsigned DEFAULT NULL,
            sold_at datetime DEFAULT NULL,
            expires_at datetime DEFAULT NULL,
            created_at datetime DEFAULT CURRENT_TIMESTAMP,
            updated_at datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (id),
            KEY seller_id (seller_id),
            KEY post_id (post_id),
            KEY category (category),
            KEY status (status),
            KEY price (price)
        ) $charset_collate;";
        
        require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
        
        dbDelta($sql_users);
        dbDelta($sql_groups);
        dbDelta($sql_group_members);
        dbDelta($sql_posts);
        dbDelta($sql_interactions);
        dbDelta($sql_comments);
        dbDelta($sql_messages);
        dbDelta($sql_participants);
        dbDelta($sql_events);
        dbDelta($sql_attendees);
        dbDelta($sql_friendships);
        dbDelta($sql_notifications);
        dbDelta($sql_activity);
        dbDelta($sql_marketplace);
    }
    
    /**
     * Register custom post types
     */
    private function register_post_types() {
        // Forum Topics
        register_post_type('aukrug_topic', [
            'labels' => [
                'name' => 'Forum Topics',
                'singular_name' => 'Forum Topic'
            ],
            'public' => true,
            'has_archive' => true,
            'show_in_rest' => true,
            'supports' => ['title', 'editor', 'author', 'thumbnail', 'comments']
        ]);
        
        // Forum Replies
        register_post_type('aukrug_reply', [
            'labels' => [
                'name' => 'Forum Replies',
                'singular_name' => 'Forum Reply'
            ],
            'public' => true,
            'show_in_rest' => true,
            'supports' => ['editor', 'author']
        ]);
        
        // Knowledge Base
        register_post_type('aukrug_knowledge', [
            'labels' => [
                'name' => 'Knowledge Base',
                'singular_name' => 'Knowledge Article'
            ],
            'public' => true,
            'has_archive' => true,
            'show_in_rest' => true,
            'supports' => ['title', 'editor', 'author', 'thumbnail']
        ]);
    }
    
    /**
     * Register custom user roles
     */
    private function register_user_roles() {
        // Community Moderator
        add_role('community_moderator', 'Community Moderator', [
            'read' => true,
            'edit_posts' => true,
            'moderate_comments' => true,
            'manage_community' => true
        ]);
        
        // Group Leader
        add_role('group_leader', 'Group Leader', [
            'read' => true,
            'edit_posts' => true,
            'manage_groups' => true
        ]);
        
        // Verified Resident
        add_role('verified_resident', 'Verified Resident', [
            'read' => true,
            'edit_posts' => true,
            'create_events' => true,
            'join_private_groups' => true
        ]);
    }
    
    /**
     * Register REST API routes
     */
    public function register_rest_routes() {
        // User Profiles
        register_rest_route('aukrug/v1', '/community/profiles', [
            'methods' => 'GET',
            'callback' => [$this, 'get_user_profiles'],
            'permission_callback' => '__return_true'
        ]);
        
        register_rest_route('aukrug/v1', '/community/profiles/(?P<user_id>\d+)', [
            'methods' => ['GET', 'PUT'],
            'callback' => [$this, 'handle_user_profile'],
            'permission_callback' => [$this, 'check_user_permission']
        ]);
        
        // Groups
        register_rest_route('aukrug/v1', '/community/groups', [
            'methods' => ['GET', 'POST'],
            'callback' => [$this, 'handle_groups'],
            'permission_callback' => '__return_true'
        ]);
        
        register_rest_route('aukrug/v1', '/community/groups/(?P<group_id>\d+)', [
            'methods' => ['GET', 'PUT', 'DELETE'],
            'callback' => [$this, 'handle_group'],
            'permission_callback' => [$this, 'check_group_permission']
        ]);
        
        register_rest_route('aukrug/v1', '/community/groups/(?P<group_id>\d+)/members', [
            'methods' => ['GET', 'POST', 'DELETE'],
            'callback' => [$this, 'handle_group_members'],
            'permission_callback' => [$this, 'check_group_member_permission']
        ]);
        
        // Posts/Feed
        register_rest_route('aukrug/v1', '/community/posts', [
            'methods' => ['GET', 'POST'],
            'callback' => [$this, 'handle_posts'],
            'permission_callback' => '__return_true'
        ]);
        
        register_rest_route('aukrug/v1', '/community/posts/(?P<post_id>\d+)', [
            'methods' => ['GET', 'PUT', 'DELETE'],
            'callback' => [$this, 'handle_post'],
            'permission_callback' => [$this, 'check_post_permission']
        ]);
        
        register_rest_route('aukrug/v1', '/community/posts/(?P<post_id>\d+)/interactions', [
            'methods' => ['GET', 'POST', 'DELETE'],
            'callback' => [$this, 'handle_post_interactions'],
            'permission_callback' => [$this, 'check_user_permission']
        ]);
        
        register_rest_route('aukrug/v1', '/community/posts/(?P<post_id>\d+)/comments', [
            'methods' => ['GET', 'POST'],
            'callback' => [$this, 'handle_post_comments'],
            'permission_callback' => '__return_true'
        ]);
        
        // Messages
        register_rest_route('aukrug/v1', '/community/messages', [
            'methods' => ['GET', 'POST'],
            'callback' => [$this, 'handle_messages'],
            'permission_callback' => [$this, 'check_user_permission']
        ]);
        
        register_rest_route('aukrug/v1', '/community/conversations', [
            'methods' => ['GET', 'POST'],
            'callback' => [$this, 'handle_conversations'],
            'permission_callback' => [$this, 'check_user_permission']
        ]);
        
        // Events
        register_rest_route('aukrug/v1', '/community/events', [
            'methods' => ['GET', 'POST'],
            'callback' => [$this, 'handle_events'],
            'permission_callback' => '__return_true'
        ]);
        
        register_rest_route('aukrug/v1', '/community/events/(?P<event_id>\d+)', [
            'methods' => ['GET', 'PUT', 'DELETE'],
            'callback' => [$this, 'handle_event'],
            'permission_callback' => [$this, 'check_event_permission']
        ]);
        
        register_rest_route('aukrug/v1', '/community/events/(?P<event_id>\d+)/attendees', [
            'methods' => ['GET', 'POST', 'DELETE'],
            'callback' => [$this, 'handle_event_attendees'],
            'permission_callback' => [$this, 'check_user_permission']
        ]);
        
        // Friendships/Connections
        register_rest_route('aukrug/v1', '/community/connections', [
            'methods' => ['GET', 'POST'],
            'callback' => [$this, 'handle_connections'],
            'permission_callback' => [$this, 'check_user_permission']
        ]);
        
        register_rest_route('aukrug/v1', '/community/connections/(?P<connection_id>\d+)', [
            'methods' => ['PUT', 'DELETE'],
            'callback' => [$this, 'handle_connection'],
            'permission_callback' => [$this, 'check_connection_permission']
        ]);
        
        // Notifications
        register_rest_route('aukrug/v1', '/community/notifications', [
            'methods' => ['GET', 'PUT'],
            'callback' => [$this, 'handle_notifications'],
            'permission_callback' => [$this, 'check_user_permission']
        ]);
        
        // Activity Feed
        register_rest_route('aukrug/v1', '/community/activity', [
            'methods' => 'GET',
            'callback' => [$this, 'get_activity_feed'],
            'permission_callback' => '__return_true'
        ]);
        
        // Marketplace
        register_rest_route('aukrug/v1', '/community/marketplace', [
            'methods' => ['GET', 'POST'],
            'callback' => [$this, 'handle_marketplace'],
            'permission_callback' => '__return_true'
        ]);
        
        register_rest_route('aukrug/v1', '/community/marketplace/(?P<item_id>\d+)', [
            'methods' => ['GET', 'PUT', 'DELETE'],
            'callback' => [$this, 'handle_marketplace_item'],
            'permission_callback' => [$this, 'check_marketplace_permission']
        ]);
        
        // Search
        register_rest_route('aukrug/v1', '/community/search', [
            'methods' => 'GET',
            'callback' => [$this, 'search_community'],
            'permission_callback' => '__return_true'
        ]);
        
        // Analytics Dashboard
        register_rest_route('aukrug/v1', '/community/analytics', [
            'methods' => 'GET',
            'callback' => [$this, 'get_community_analytics'],
            'permission_callback' => [$this, 'check_admin_permission']
        ]);
    }
    
    // REST API Handler Methods would go here...
    // For brevity, I'll add key methods
    
    public function handle_groups($request) {
        if ($request->get_method() === 'GET') {
            return $this->get_groups($request);
        } else if ($request->get_method() === 'POST') {
            return $this->create_group($request);
        }
    }
    
    private function get_groups($request) {
        global $wpdb;
        
        $page = $request->get_param('page') ?: 1;
        $per_page = min($request->get_param('per_page') ?: 20, 100);
        $offset = ($page - 1) * $per_page;
        
        $type = $request->get_param('type');
        $category = $request->get_param('category');
        $search = $request->get_param('search');
        
        $where_conditions = ['g.status = "active"'];
        
        if ($type) {
            $where_conditions[] = $wpdb->prepare('g.type = %s', $type);
        }
        
        if ($category) {
            $where_conditions[] = $wpdb->prepare('g.category = %s', $category);
        }
        
        if ($search) {
            $where_conditions[] = $wpdb->prepare('(g.name LIKE %s OR g.description LIKE %s)', 
                '%' . $search . '%', '%' . $search . '%');
        }
        
        $where_clause = implode(' AND ', $where_conditions);
        
        $groups_table = $wpdb->prefix . 'aukrug_groups';
        $members_table = $wpdb->prefix . 'aukrug_group_members';
        
        $query = $wpdb->prepare("
            SELECT g.*, 
                   COUNT(m.id) as member_count,
                   u.display_name as creator_name
            FROM $groups_table g
            LEFT JOIN $members_table m ON g.id = m.group_id AND m.status = 'active'
            LEFT JOIN {$wpdb->users} u ON g.creator_id = u.ID
            WHERE $where_clause
            GROUP BY g.id
            ORDER BY g.created_at DESC
            LIMIT %d OFFSET %d
        ", $per_page, $offset);
        
        $groups = $wpdb->get_results($query);
        
        return rest_ensure_response([
            'groups' => $groups,
            'page' => $page,
            'per_page' => $per_page,
            'total' => $this->get_groups_count($where_clause)
        ]);
    }
    
    private function create_group($request) {
        global $wpdb;
        
        $current_user_id = get_current_user_id();
        if (!$current_user_id) {
            return new WP_Error('unauthorized', 'Authentication required', ['status' => 401]);
        }
        
        $data = [
            'name' => sanitize_text_field($request->get_param('name')),
            'slug' => sanitize_title($request->get_param('name')),
            'description' => wp_kses_post($request->get_param('description')),
            'type' => sanitize_text_field($request->get_param('type') ?: 'public'),
            'category' => sanitize_text_field($request->get_param('category')),
            'location' => sanitize_text_field($request->get_param('location')),
            'creator_id' => $current_user_id,
            'join_policy' => sanitize_text_field($request->get_param('join_policy') ?: 'open'),
            'max_members' => intval($request->get_param('max_members')),
            'tags' => json_encode($request->get_param('tags') ?: []),
            'settings' => json_encode($request->get_param('settings') ?: [])
        ];
        
        // Check if slug exists
        $existing = $wpdb->get_var($wpdb->prepare(
            "SELECT id FROM {$wpdb->prefix}aukrug_groups WHERE slug = %s",
            $data['slug']
        ));
        
        if ($existing) {
            $data['slug'] .= '-' . time();
        }
        
        $groups_table = $wpdb->prefix . 'aukrug_groups';
        $result = $wpdb->insert($groups_table, $data);
        
        if ($result === false) {
            return new WP_Error('database_error', 'Failed to create group', ['status' => 500]);
        }
        
        $group_id = $wpdb->insert_id;
        
        // Add creator as admin member
        $wpdb->insert($wpdb->prefix . 'aukrug_group_members', [
            'group_id' => $group_id,
            'user_id' => $current_user_id,
            'role' => 'admin',
            'status' => 'active'
        ]);
        
        // Log activity
        $this->log_activity($current_user_id, 'created_group', 'group', $group_id);
        
        return rest_ensure_response([
            'success' => true,
            'group_id' => $group_id,
            'message' => 'Group created successfully'
        ]);
    }
    
    // Permission check methods
    public function check_user_permission($request) {
        return is_user_logged_in();
    }
    
    public function check_admin_permission($request) {
        return current_user_can('manage_options');
    }
    
    public function check_group_permission($request) {
        // Implementation for group-specific permissions
        return $this->check_user_permission($request);
    }
    
    public function check_post_permission($request) {
        // Implementation for post-specific permissions
        return $this->check_user_permission($request);
    }
    
    public function check_event_permission($request) {
        // Implementation for event-specific permissions
        return $this->check_user_permission($request);
    }
    
    public function check_connection_permission($request) {
        // Implementation for connection-specific permissions
        return $this->check_user_permission($request);
    }
    
    public function check_marketplace_permission($request) {
        // Implementation for marketplace-specific permissions
        return $this->check_user_permission($request);
    }
    
    // Helper methods
    private function log_activity($user_id, $action, $object_type, $object_id, $secondary_object_type = null, $secondary_object_id = null) {
        global $wpdb;
        
        $wpdb->insert($wpdb->prefix . 'aukrug_activity', [
            'user_id' => $user_id,
            'action_type' => $action,
            'object_type' => $object_type,
            'object_id' => $object_id,
            'secondary_object_type' => $secondary_object_type,
            'secondary_object_id' => $secondary_object_id
        ]);
    }
    
    private function get_groups_count($where_clause) {
        global $wpdb;
        return $wpdb->get_var("SELECT COUNT(*) FROM {$wpdb->prefix}aukrug_groups g WHERE $where_clause");
    }
    
    public function enqueue_scripts() {
        if (is_admin()) {
            wp_enqueue_script('aukrug-community-admin', plugin_dir_url(__FILE__) . '../assets/js/community-admin.js', ['jquery'], '1.0.0', true);
            wp_enqueue_style('aukrug-community-admin', plugin_dir_url(__FILE__) . '../assets/css/community-admin.css', [], '1.0.0');
        }
    }
}

// Initialize the community system
Aukrug_Community::get_instance();
