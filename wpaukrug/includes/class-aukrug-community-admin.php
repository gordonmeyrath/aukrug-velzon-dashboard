<?php
/**
 * Aukrug Community Admin Dashboard
 * Advanced community management interface inspired by BuddyBoss
 * 
 * @package Aukrug
 * @version 1.0.0
 */

if (!defined('ABSPATH')) {
    exit;
}

class Aukrug_Community_Admin {
    
    private static $instance = null;
    
    public static function get_instance() {
        if (null === self::$instance) {
            self::$instance = new self();
        }
        return self::$instance;
    }
    
    public function __construct() {
        add_action('admin_menu', [$this, 'add_admin_menu']);
        add_action('admin_enqueue_scripts', [$this, 'enqueue_admin_scripts']);
        add_action('wp_ajax_aukrug_community_action', [$this, 'handle_ajax_actions']);
        add_action('admin_init', [$this, 'init_admin']);
    }
    
    public function init_admin() {
        // Register settings
        register_setting('aukrug_community_settings', 'aukrug_community_options');
    }
    
    public function add_admin_menu() {
        // Main Community menu
        add_menu_page(
            'Aukrug Community',
            'Community',
            'manage_options',
            'aukrug-community',
            [$this, 'render_dashboard_page'],
            'dashicons-groups',
            30
        );
        
        // Sub-menus
        add_submenu_page(
            'aukrug-community',
            'Community Dashboard',
            'Dashboard',
            'manage_options',
            'aukrug-community',
            [$this, 'render_dashboard_page']
        );
        
        add_submenu_page(
            'aukrug-community',
            'User Management',
            'Users',
            'manage_options',
            'aukrug-community-users',
            [$this, 'render_users_page']
        );
        
        add_submenu_page(
            'aukrug-community',
            'Groups Management',
            'Groups',
            'manage_options',
            'aukrug-community-groups',
            [$this, 'render_groups_page']
        );
        
        add_submenu_page(
            'aukrug-community',
            'Content Moderation',
            'Moderation',
            'manage_options',
            'aukrug-community-moderation',
            [$this, 'render_moderation_page']
        );
        
        add_submenu_page(
            'aukrug-community',
            'Events Management',
            'Events',
            'manage_options',
            'aukrug-community-events',
            [$this, 'render_events_page']
        );
        
        add_submenu_page(
            'aukrug-community',
            'Marketplace',
            'Marketplace',
            'manage_options',
            'aukrug-community-marketplace',
            [$this, 'render_marketplace_page']
        );
        
        add_submenu_page(
            'aukrug-community',
            'Analytics',
            'Analytics',
            'manage_options',
            'aukrug-community-analytics',
            [$this, 'render_analytics_page']
        );
        
        add_submenu_page(
            'aukrug-community',
            'Settings',
            'Settings',
            'manage_options',
            'aukrug-community-settings',
            [$this, 'render_settings_page']
        );
    }
    
    public function enqueue_admin_scripts($hook) {
        if (strpos($hook, 'aukrug-community') === false) {
            return;
        }
        
        wp_enqueue_script('jquery');
        wp_enqueue_script('jquery-ui-core');
        wp_enqueue_script('jquery-ui-sortable');
        wp_enqueue_script('chart-js', 'https://cdn.jsdelivr.net/npm/chart.js', [], '3.9.1', true);
        
        wp_enqueue_script(
            'aukrug-community-admin',
            plugin_dir_url(__FILE__) . '../assets/js/community-admin.js',
            ['jquery', 'chart-js'],
            '1.0.0',
            true
        );
        
        wp_enqueue_style(
            'aukrug-community-admin',
            plugin_dir_url(__FILE__) . '../assets/css/community-admin.css',
            [],
            '1.0.0'
        );
        
        wp_localize_script('aukrug-community-admin', 'aukrugCommunity', [
            'ajaxUrl' => admin_url('admin-ajax.php'),
            'nonce' => wp_create_nonce('aukrug_community_nonce'),
            'confirmDelete' => __('Are you sure you want to delete this item?', 'aukrug'),
            'loading' => __('Loading...', 'aukrug')
        ]);
    }
    
    public function render_dashboard_page() {
        $analytics = $this->get_community_analytics();
        ?>
        <div class="wrap aukrug-community-admin">
            <h1>
                <span class="dashicons dashicons-groups"></span>
                Community Dashboard
                <span class="aukrug-badge">PRO</span>
            </h1>
            
            <div class="aukrug-dashboard-grid">
                <!-- Quick Stats -->
                <div class="aukrug-card aukrug-stats-grid">
                    <h2>Community Overview</h2>
                    <div class="stats-container">
                        <div class="stat-item">
                            <div class="stat-number"><?php echo number_format($analytics['total_users']); ?></div>
                            <div class="stat-label">Total Users</div>
                            <div class="stat-change positive">+<?php echo $analytics['new_users_this_month']; ?> this month</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number"><?php echo number_format($analytics['active_groups']); ?></div>
                            <div class="stat-label">Active Groups</div>
                            <div class="stat-change positive">+<?php echo $analytics['new_groups_this_month']; ?> this month</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number"><?php echo number_format($analytics['total_posts']); ?></div>
                            <div class="stat-label">Community Posts</div>
                            <div class="stat-change positive">+<?php echo $analytics['new_posts_this_week']; ?> this week</div>
                        </div>
                        <div class="stat-item">
                            <div class="stat-number"><?php echo number_format($analytics['upcoming_events']); ?></div>
                            <div class="stat-label">Upcoming Events</div>
                            <div class="stat-change neutral">Next 30 days</div>
                        </div>
                    </div>
                </div>
                
                <!-- Recent Activity -->
                <div class="aukrug-card">
                    <h2>Recent Community Activity</h2>
                    <div class="activity-list">
                        <?php 
                        $recent_activities = $this->get_recent_activities(10);
                        foreach ($recent_activities as $activity): 
                        ?>
                        <div class="activity-item">
                            <div class="activity-avatar">
                                <?php echo get_avatar($activity->user_id, 32); ?>
                            </div>
                            <div class="activity-content">
                                <div class="activity-text">
                                    <strong><?php echo get_userdata($activity->user_id)->display_name; ?></strong>
                                    <?php echo $this->format_activity_text($activity); ?>
                                </div>
                                <div class="activity-time"><?php echo human_time_diff(strtotime($activity->created_at)); ?> ago</div>
                            </div>
                        </div>
                        <?php endforeach; ?>
                    </div>
                </div>
                
                <!-- Quick Actions -->
                <div class="aukrug-card">
                    <h2>Quick Actions</h2>
                    <div class="quick-actions">
                        <a href="<?php echo admin_url('admin.php?page=aukrug-community-users'); ?>" class="action-button">
                            <span class="dashicons dashicons-admin-users"></span>
                            Manage Users
                        </a>
                        <a href="<?php echo admin_url('admin.php?page=aukrug-community-groups'); ?>" class="action-button">
                            <span class="dashicons dashicons-groups"></span>
                            Create Group
                        </a>
                        <a href="<?php echo admin_url('admin.php?page=aukrug-community-events'); ?>" class="action-button">
                            <span class="dashicons dashicons-calendar-alt"></span>
                            Add Event
                        </a>
                        <a href="<?php echo admin_url('admin.php?page=aukrug-community-moderation'); ?>" class="action-button">
                            <span class="dashicons dashicons-shield"></span>
                            Moderation Queue
                        </a>
                    </div>
                </div>
                
                <!-- System Health -->
                <div class="aukrug-card">
                    <h2>System Health</h2>
                    <div class="health-indicators">
                        <div class="health-item">
                            <span class="health-status good"></span>
                            <span>Database Connection</span>
                        </div>
                        <div class="health-item">
                            <span class="health-status good"></span>
                            <span>API Endpoints</span>
                        </div>
                        <div class="health-item">
                            <span class="health-status warning"></span>
                            <span>Storage Usage (78%)</span>
                        </div>
                        <div class="health-item">
                            <span class="health-status good"></span>
                            <span>Notification Service</span>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- Charts Section -->
            <div class="aukrug-charts-section">
                <div class="aukrug-card chart-card">
                    <h2>User Engagement (Last 30 Days)</h2>
                    <canvas id="engagementChart" width="400" height="200"></canvas>
                </div>
                <div class="aukrug-card chart-card">
                    <h2>Content Growth</h2>
                    <canvas id="contentChart" width="400" height="200"></canvas>
                </div>
            </div>
        </div>
        
        <script>
        jQuery(document).ready(function($) {
            // Initialize engagement chart
            const engagementCtx = document.getElementById('engagementChart').getContext('2d');
            new Chart(engagementCtx, {
                type: 'line',
                data: {
                    labels: <?php echo json_encode($analytics['engagement_labels']); ?>,
                    datasets: [{
                        label: 'Active Users',
                        data: <?php echo json_encode($analytics['engagement_data']); ?>,
                        borderColor: '#2196F3',
                        backgroundColor: 'rgba(33, 150, 243, 0.1)',
                        tension: 0.4
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
            
            // Initialize content chart
            const contentCtx = document.getElementById('contentChart').getContext('2d');
            new Chart(contentCtx, {
                type: 'bar',
                data: {
                    labels: ['Posts', 'Comments', 'Events', 'Groups'],
                    datasets: [{
                        label: 'Content Items',
                        data: <?php echo json_encode($analytics['content_data']); ?>,
                        backgroundColor: ['#4CAF50', '#FF9800', '#9C27B0', '#F44336']
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false
                }
            });
        });
        </script>
        <?php
    }
    
    public function render_users_page() {
        ?>
        <div class="wrap aukrug-community-admin">
            <h1>
                <span class="dashicons dashicons-admin-users"></span>
                User Management
            </h1>
            
            <div class="aukrug-toolbar">
                <div class="toolbar-left">
                    <select id="user-filter">
                        <option value="">All Users</option>
                        <option value="verified_resident">Verified Residents</option>
                        <option value="group_leader">Group Leaders</option>
                        <option value="community_moderator">Moderators</option>
                        <option value="pending_verification">Pending Verification</option>
                    </select>
                    <input type="search" id="user-search" placeholder="Search users...">
                    <button type="button" class="button" id="search-users">Search</button>
                </div>
                <div class="toolbar-right">
                    <button type="button" class="button button-primary" id="bulk-verify-users">
                        Bulk Verify
                    </button>
                    <button type="button" class="button" id="export-users">
                        Export Users
                    </button>
                </div>
            </div>
            
            <div class="aukrug-card">
                <div class="user-stats-bar">
                    <div class="stat">
                        <span class="number"><?php echo $this->get_user_count(); ?></span>
                        <span class="label">Total Users</span>
                    </div>
                    <div class="stat">
                        <span class="number"><?php echo $this->get_user_count('verified_resident'); ?></span>
                        <span class="label">Verified</span>
                    </div>
                    <div class="stat">
                        <span class="number"><?php echo $this->get_user_count('pending'); ?></span>
                        <span class="label">Pending</span>
                    </div>
                    <div class="stat">
                        <span class="number"><?php echo $this->get_active_users_count(30); ?></span>
                        <span class="label">Active (30d)</span>
                    </div>
                </div>
                
                <div id="users-table-container">
                    <?php $this->render_users_table(); ?>
                </div>
            </div>
        </div>
        <?php
    }
    
    public function render_groups_page() {
        ?>
        <div class="wrap aukrug-community-admin">
            <h1>
                <span class="dashicons dashicons-groups"></span>
                Groups Management
                <a href="#" class="page-title-action" id="create-group">Add New Group</a>
            </h1>
            
            <div class="aukrug-dashboard-grid">
                <div class="aukrug-card">
                    <h2>Group Categories</h2>
                    <div class="category-list">
                        <?php
                        $categories = $this->get_group_categories();
                        foreach ($categories as $category):
                        ?>
                        <div class="category-item">
                            <span class="category-name"><?php echo esc_html($category->name); ?></span>
                            <span class="category-count"><?php echo $category->count; ?> groups</span>
                        </div>
                        <?php endforeach; ?>
                    </div>
                    <button type="button" class="button" id="manage-categories">Manage Categories</button>
                </div>
                
                <div class="aukrug-card">
                    <h2>Group Statistics</h2>
                    <canvas id="groupStatsChart" width="400" height="200"></canvas>
                </div>
            </div>
            
            <div class="aukrug-card">
                <h2>All Groups</h2>
                <div id="groups-table-container">
                    <?php $this->render_groups_table(); ?>
                </div>
            </div>
            
            <!-- Create Group Modal -->
            <div id="group-modal" class="aukrug-modal" style="display: none;">
                <div class="modal-content">
                    <h2>Create New Group</h2>
                    <form id="create-group-form">
                        <table class="form-table">
                            <tr>
                                <th scope="row">Group Name</th>
                                <td><input type="text" name="name" required class="regular-text"></td>
                            </tr>
                            <tr>
                                <th scope="row">Description</th>
                                <td><textarea name="description" rows="4" class="large-text"></textarea></td>
                            </tr>
                            <tr>
                                <th scope="row">Type</th>
                                <td>
                                    <select name="type">
                                        <option value="public">Public</option>
                                        <option value="private">Private</option>
                                        <option value="secret">Secret</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Category</th>
                                <td>
                                    <select name="category">
                                        <option value="">Select Category</option>
                                        <?php foreach ($categories as $cat): ?>
                                        <option value="<?php echo esc_attr($cat->name); ?>"><?php echo esc_html($cat->name); ?></option>
                                        <?php endforeach; ?>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Location</th>
                                <td><input type="text" name="location" class="regular-text"></td>
                            </tr>
                        </table>
                        <p class="submit">
                            <button type="submit" class="button button-primary">Create Group</button>
                            <button type="button" class="button" onclick="jQuery('#group-modal').hide()">Cancel</button>
                        </p>
                    </form>
                </div>
            </div>
        </div>
        <?php
    }
    
    public function render_analytics_page() {
        $analytics = $this->get_detailed_analytics();
        ?>
        <div class="wrap aukrug-community-admin">
            <h1>
                <span class="dashicons dashicons-chart-bar"></span>
                Community Analytics
            </h1>
            
            <div class="aukrug-analytics-filters">
                <select id="analytics-period">
                    <option value="7">Last 7 days</option>
                    <option value="30" selected>Last 30 days</option>
                    <option value="90">Last 90 days</option>
                    <option value="365">Last year</option>
                </select>
                <button type="button" class="button" id="export-analytics">Export Report</button>
            </div>
            
            <div class="aukrug-analytics-grid">
                <div class="aukrug-card">
                    <h2>User Engagement</h2>
                    <canvas id="userEngagementChart"></canvas>
                </div>
                <div class="aukrug-card">
                    <h2>Content Activity</h2>
                    <canvas id="contentActivityChart"></canvas>
                </div>
                <div class="aukrug-card">
                    <h2>Popular Groups</h2>
                    <div class="popular-groups-list">
                        <?php foreach ($analytics['popular_groups'] as $group): ?>
                        <div class="group-item">
                            <span class="group-name"><?php echo esc_html($group->name); ?></span>
                            <span class="group-members"><?php echo $group->member_count; ?> members</span>
                        </div>
                        <?php endforeach; ?>
                    </div>
                </div>
                <div class="aukrug-card">
                    <h2>Active Users (Top 10)</h2>
                    <div class="active-users-list">
                        <?php foreach ($analytics['active_users'] as $user): ?>
                        <div class="user-item">
                            <?php echo get_avatar($user->user_id, 32); ?>
                            <span class="user-name"><?php echo esc_html($user->display_name); ?></span>
                            <span class="user-activity"><?php echo $user->activity_count; ?> activities</span>
                        </div>
                        <?php endforeach; ?>
                    </div>
                </div>
            </div>
        </div>
        <?php
    }
    
    public function render_settings_page() {
        if (isset($_POST['submit'])) {
            $this->save_community_settings();
            echo '<div class="notice notice-success"><p>Settings saved successfully!</p></div>';
        }
        
        $options = get_option('aukrug_community_options', []);
        ?>
        <div class="wrap aukrug-community-admin">
            <h1>
                <span class="dashicons dashicons-admin-settings"></span>
                Community Settings
            </h1>
            
            <form method="post" action="">
                <?php wp_nonce_field('aukrug_community_settings'); ?>
                
                <div class="aukrug-settings-tabs">
                    <nav class="nav-tab-wrapper">
                        <a href="#general" class="nav-tab nav-tab-active">General</a>
                        <a href="#permissions" class="nav-tab">Permissions</a>
                        <a href="#notifications" class="nav-tab">Notifications</a>
                        <a href="#moderation" class="nav-tab">Moderation</a>
                        <a href="#integrations" class="nav-tab">Integrations</a>
                    </nav>
                    
                    <div id="general" class="tab-content active">
                        <h2>General Settings</h2>
                        <table class="form-table">
                            <tr>
                                <th scope="row">Community Name</th>
                                <td>
                                    <input type="text" name="community_name" value="<?php echo esc_attr($options['community_name'] ?? 'Aukrug Community'); ?>" class="regular-text">
                                    <p class="description">The name of your community platform</p>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Registration</th>
                                <td>
                                    <label>
                                        <input type="checkbox" name="allow_registration" <?php checked($options['allow_registration'] ?? true); ?>>
                                        Allow user registration
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Default User Role</th>
                                <td>
                                    <select name="default_user_role">
                                        <option value="subscriber" <?php selected($options['default_user_role'] ?? 'subscriber', 'subscriber'); ?>>Subscriber</option>
                                        <option value="verified_resident" <?php selected($options['default_user_role'] ?? 'subscriber', 'verified_resident'); ?>>Verified Resident</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </div>
                    
                    <div id="permissions" class="tab-content">
                        <h2>Permission Settings</h2>
                        <table class="form-table">
                            <tr>
                                <th scope="row">Group Creation</th>
                                <td>
                                    <select name="who_can_create_groups">
                                        <option value="all" <?php selected($options['who_can_create_groups'] ?? 'verified', 'all'); ?>>All Users</option>
                                        <option value="verified" <?php selected($options['who_can_create_groups'] ?? 'verified', 'verified'); ?>>Verified Users Only</option>
                                        <option value="admin" <?php selected($options['who_can_create_groups'] ?? 'verified', 'admin'); ?>>Admins Only</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Event Creation</th>
                                <td>
                                    <select name="who_can_create_events">
                                        <option value="all" <?php selected($options['who_can_create_events'] ?? 'verified', 'all'); ?>>All Users</option>
                                        <option value="verified" <?php selected($options['who_can_create_events'] ?? 'verified', 'verified'); ?>>Verified Users Only</option>
                                        <option value="group_leaders" <?php selected($options['who_can_create_events'] ?? 'verified', 'group_leaders'); ?>>Group Leaders Only</option>
                                    </select>
                                </td>
                            </tr>
                        </table>
                    </div>
                    
                    <div id="notifications" class="tab-content">
                        <h2>Notification Settings</h2>
                        <table class="form-table">
                            <tr>
                                <th scope="row">Email Notifications</th>
                                <td>
                                    <label>
                                        <input type="checkbox" name="enable_email_notifications" <?php checked($options['enable_email_notifications'] ?? true); ?>>
                                        Enable email notifications
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Push Notifications</th>
                                <td>
                                    <label>
                                        <input type="checkbox" name="enable_push_notifications" <?php checked($options['enable_push_notifications'] ?? false); ?>>
                                        Enable push notifications (requires setup)
                                    </label>
                                </td>
                            </tr>
                        </table>
                    </div>
                    
                    <div id="moderation" class="tab-content">
                        <h2>Content Moderation</h2>
                        <table class="form-table">
                            <tr>
                                <th scope="row">Auto-moderation</th>
                                <td>
                                    <label>
                                        <input type="checkbox" name="enable_auto_moderation" <?php checked($options['enable_auto_moderation'] ?? false); ?>>
                                        Enable automatic content moderation
                                    </label>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Blocked Words</th>
                                <td>
                                    <textarea name="blocked_words" rows="5" class="large-text"><?php echo esc_textarea($options['blocked_words'] ?? ''); ?></textarea>
                                    <p class="description">One word per line</p>
                                </td>
                            </tr>
                        </table>
                    </div>
                    
                    <div id="integrations" class="tab-content">
                        <h2>Third-party Integrations</h2>
                        <table class="form-table">
                            <tr>
                                <th scope="row">Google Maps API Key</th>
                                <td>
                                    <input type="text" name="google_maps_api" value="<?php echo esc_attr($options['google_maps_api'] ?? ''); ?>" class="regular-text">
                                    <p class="description">For location-based features</p>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Firebase Server Key</th>
                                <td>
                                    <input type="text" name="firebase_server_key" value="<?php echo esc_attr($options['firebase_server_key'] ?? ''); ?>" class="regular-text">
                                    <p class="description">For push notifications</p>
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
                
                <?php submit_button(); ?>
            </form>
        </div>
        <?php
    }
    
    // Helper methods for data retrieval
    private function get_community_analytics() {
        global $wpdb;
        
        // Mock data for demo - replace with actual database queries
        return [
            'total_users' => 1247,
            'new_users_this_month' => 156,
            'active_groups' => 23,
            'new_groups_this_month' => 4,
            'total_posts' => 2891,
            'new_posts_this_week' => 67,
            'upcoming_events' => 12,
            'engagement_labels' => ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
            'engagement_data' => [120, 145, 160, 178, 195, 210],
            'content_data' => [2891, 1456, 234, 23]
        ];
    }
    
    private function get_recent_activities($limit = 10) {
        global $wpdb;
        
        $table = $wpdb->prefix . 'aukrug_activity';
        return $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $table ORDER BY created_at DESC LIMIT %d",
            $limit
        ));
    }
    
    private function format_activity_text($activity) {
        $actions = [
            'created_group' => 'created a new group',
            'joined_group' => 'joined a group',
            'created_post' => 'created a new post',
            'created_event' => 'created an event',
            'liked_post' => 'liked a post'
        ];
        
        return $actions[$activity->action_type] ?? 'performed an action';
    }
    
    private function get_user_count($type = '') {
        global $wpdb;
        
        if (empty($type)) {
            return $wpdb->get_var("SELECT COUNT(*) FROM {$wpdb->users}");
        }
        
        // Add specific counting logic for different user types
        return rand(50, 500); // Mock data
    }
    
    private function get_active_users_count($days = 30) {
        // Mock data - implement actual logic
        return rand(100, 300);
    }
    
    private function get_group_categories() {
        global $wpdb;
        
        // Mock data - implement actual database query
        return [
            (object)['name' => 'Sports & Fitness', 'count' => 8],
            (object)['name' => 'Arts & Culture', 'count' => 5],
            (object)['name' => 'Local Business', 'count' => 12],
            (object)['name' => 'Community Service', 'count' => 4]
        ];
    }
    
    private function get_detailed_analytics() {
        // Mock data for detailed analytics
        return [
            'popular_groups' => [
                (object)['name' => 'Aukrug Sports Club', 'member_count' => 156],
                (object)['name' => 'Local Artists', 'member_count' => 89],
                (object)['name' => 'Neighborhood Watch', 'member_count' => 67]
            ],
            'active_users' => [
                (object)['user_id' => 1, 'display_name' => 'Max Mustermann', 'activity_count' => 45],
                (object)['user_id' => 2, 'display_name' => 'Anna Schmidt', 'activity_count' => 38],
                (object)['user_id' => 3, 'display_name' => 'Hans Weber', 'activity_count' => 32]
            ]
        ];
    }
    
    private function render_users_table() {
        // Placeholder for users table
        echo '<div class="users-table-placeholder">Users table will load here via AJAX</div>';
    }
    
    private function render_groups_table() {
        // Placeholder for groups table
        echo '<div class="groups-table-placeholder">Groups table will load here via AJAX</div>';
    }
    
    private function save_community_settings() {
        if (!wp_verify_nonce($_POST['_wpnonce'], 'aukrug_community_settings')) {
            return;
        }
        
        $options = [
            'community_name' => sanitize_text_field($_POST['community_name'] ?? ''),
            'allow_registration' => !empty($_POST['allow_registration']),
            'default_user_role' => sanitize_text_field($_POST['default_user_role'] ?? 'subscriber'),
            'who_can_create_groups' => sanitize_text_field($_POST['who_can_create_groups'] ?? 'verified'),
            'who_can_create_events' => sanitize_text_field($_POST['who_can_create_events'] ?? 'verified'),
            'enable_email_notifications' => !empty($_POST['enable_email_notifications']),
            'enable_push_notifications' => !empty($_POST['enable_push_notifications']),
            'enable_auto_moderation' => !empty($_POST['enable_auto_moderation']),
            'blocked_words' => sanitize_textarea_field($_POST['blocked_words'] ?? ''),
            'google_maps_api' => sanitize_text_field($_POST['google_maps_api'] ?? ''),
            'firebase_server_key' => sanitize_text_field($_POST['firebase_server_key'] ?? '')
        ];
        
        update_option('aukrug_community_options', $options);
    }
    
    public function handle_ajax_actions() {
        if (!wp_verify_nonce($_POST['nonce'], 'aukrug_community_nonce')) {
            wp_die('Security check failed');
        }
        
        $action = $_POST['community_action'] ?? '';
        
        switch ($action) {
            case 'load_users':
                $this->ajax_load_users();
                break;
            case 'verify_user':
                $this->ajax_verify_user();
                break;
            case 'load_groups':
                $this->ajax_load_groups();
                break;
            case 'create_group':
                $this->ajax_create_group();
                break;
            default:
                wp_send_json_error('Unknown action');
        }
    }
    
    private function ajax_load_users() {
        // Implementation for loading users via AJAX
        wp_send_json_success(['html' => '<div>Users data loaded</div>']);
    }
    
    private function ajax_verify_user() {
        // Implementation for user verification
        wp_send_json_success(['message' => 'User verified successfully']);
    }
    
    private function ajax_load_groups() {
        // Implementation for loading groups via AJAX
        wp_send_json_success(['html' => '<div>Groups data loaded</div>']);
    }
    
    private function ajax_create_group() {
        // Implementation for creating groups via AJAX
        wp_send_json_success(['message' => 'Group created successfully']);
    }
    
    public function render_moderation_page() {
        echo '<div class="wrap"><h1>Content Moderation</h1><p>Moderation interface will be implemented here.</p></div>';
    }
    
    public function render_events_page() {
        echo '<div class="wrap"><h1>Events Management</h1><p>Events management interface will be implemented here.</p></div>';
    }
    
    public function render_marketplace_page() {
        echo '<div class="wrap"><h1>Marketplace</h1><p>Marketplace management interface will be implemented here.</p></div>';
    }
}

// Initialize the admin interface
if (is_admin()) {
    Aukrug_Community_Admin::get_instance();
}
