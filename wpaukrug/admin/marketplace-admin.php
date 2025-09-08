<?php
/**
 * Admin UI for Marketplace Management
 */

class Aukrug_Marketplace_Admin {
    
    public function __construct() {
        add_action('admin_menu', array($this, 'add_admin_menu'));
        add_action('admin_enqueue_scripts', array($this, 'enqueue_admin_scripts'));
        add_action('wp_ajax_approve_verification', array($this, 'handle_approve_verification'));
        add_action('wp_ajax_reject_verification', array($this, 'handle_reject_verification'));
        add_action('wp_ajax_get_verification_requests', array($this, 'get_verification_requests'));
        add_action('wp_ajax_get_marketplace_reports', array($this, 'get_marketplace_reports'));
        add_action('wp_ajax_resolve_report', array($this, 'resolve_report'));
    }

    /**
     * Add admin menu page
     */
    public function add_admin_menu() {
        add_submenu_page(
            'aukrug-dashboard',
            'Marketplace',
            'Marketplace',
            'manage_options',
            'aukrug-marketplace',
            array($this, 'admin_page')
        );
    }

    /**
     * Enqueue admin scripts and styles
     */
    public function enqueue_admin_scripts($hook) {
        if ($hook !== 'aukrug_page_aukrug-marketplace') {
            return;
        }

        wp_enqueue_script('aukrug-marketplace-admin', AUKRUG_PLUGIN_URL . 'assets/js/marketplace-admin.js', array('jquery'), AUKRUG_PLUGIN_VERSION, true);
        wp_enqueue_style('aukrug-marketplace-admin', AUKRUG_PLUGIN_URL . 'assets/css/marketplace-admin.css', array(), AUKRUG_PLUGIN_VERSION);
        
        wp_localize_script('aukrug-marketplace-admin', 'aukrugMarketplace', array(
            'ajaxUrl' => admin_url('admin-ajax.php'),
            'nonce' => wp_create_nonce('aukrug_marketplace_admin'),
        ));
    }

    /**
     * Admin page HTML
     */
    public function admin_page() {
        ?>
        <div class="wrap">
            <h1>Marketplace Management</h1>
            
            <div class="aukrug-marketplace-admin">
                <nav class="nav-tab-wrapper">
                    <a href="#listings" class="nav-tab nav-tab-active" data-tab="listings">Listings</a>
                    <a href="#categories" class="nav-tab" data-tab="categories">Categories</a>
                    <a href="#verification" class="nav-tab" data-tab="verification">Verification</a>
                    <a href="#reports" class="nav-tab" data-tab="reports">Reports</a>
                    <a href="#settings" class="nav-tab" data-tab="settings">Settings</a>
                </nav>

                <!-- Listings Tab -->
                <div id="tab-listings" class="tab-content active">
                    <h2>Marketplace Listings</h2>
                    <div class="listings-filters">
                        <select id="status-filter">
                            <option value="">All Status</option>
                            <option value="active">Active</option>
                            <option value="paused">Paused</option>
                            <option value="sold">Sold</option>
                        </select>
                        <select id="category-filter">
                            <option value="">All Categories</option>
                            <?php
                            $categories = get_terms(array('taxonomy' => 'market_category', 'hide_empty' => false));
                            foreach ($categories as $category) {
                                echo '<option value="' . esc_attr($category->slug) . '">' . esc_html($category->name) . '</option>';
                            }
                            ?>
                        </select>
                        <input type="text" id="search-listings" placeholder="Search listings...">
                        <button id="filter-listings" class="button">Filter</button>
                    </div>
                    
                    <div id="listings-table"></div>
                </div>

                <!-- Categories Tab -->
                <div id="tab-categories" class="tab-content">
                    <h2>Marketplace Categories</h2>
                    <div class="category-form">
                        <h3>Add New Category</h3>
                        <form id="add-category-form">
                            <table class="form-table">
                                <tr>
                                    <th scope="row">Name</th>
                                    <td><input type="text" id="category-name" required></td>
                                </tr>
                                <tr>
                                    <th scope="row">Description</th>
                                    <td><textarea id="category-description"></textarea></td>
                                </tr>
                                <tr>
                                    <th scope="row">Parent Category</th>
                                    <td>
                                        <select id="category-parent">
                                            <option value="">None</option>
                                            <?php
                                            foreach ($categories as $category) {
                                                echo '<option value="' . esc_attr($category->term_id) . '">' . esc_html($category->name) . '</option>';
                                            }
                                            ?>
                                        </select>
                                    </td>
                                </tr>
                            </table>
                            <button type="submit" class="button button-primary">Add Category</button>
                        </form>
                    </div>
                    
                    <div class="categories-list">
                        <h3>Existing Categories</h3>
                        <table class="wp-list-table widefat fixed striped">
                            <thead>
                                <tr>
                                    <th>Name</th>
                                    <th>Description</th>
                                    <th>Parent</th>
                                    <th>Count</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <?php foreach ($categories as $category): ?>
                                <tr>
                                    <td><?php echo esc_html($category->name); ?></td>
                                    <td><?php echo esc_html($category->description); ?></td>
                                    <td>
                                        <?php 
                                        if ($category->parent) {
                                            $parent = get_term($category->parent);
                                            echo esc_html($parent->name);
                                        } else {
                                            echo '-';
                                        }
                                        ?>
                                    </td>
                                    <td><?php echo $category->count; ?></td>
                                    <td>
                                        <button class="button edit-category" data-id="<?php echo $category->term_id; ?>">Edit</button>
                                        <button class="button delete-category" data-id="<?php echo $category->term_id; ?>">Delete</button>
                                    </td>
                                </tr>
                                <?php endforeach; ?>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Verification Tab -->
                <div id="tab-verification" class="tab-content">
                    <h2>User Verification</h2>
                    <div id="verification-requests">
                        <h3>Pending Requests</h3>
                        <div id="verification-table"></div>
                    </div>
                </div>

                <!-- Reports Tab -->
                <div id="tab-reports" class="tab-content">
                    <h2>Abuse Reports</h2>
                    <div id="reports-table"></div>
                </div>

                <!-- Settings Tab -->
                <div id="tab-settings" class="tab-content">
                    <h2>Marketplace Settings</h2>
                    <form id="marketplace-settings-form">
                        <table class="form-table">
                            <tr>
                                <th scope="row">Rate Limits</th>
                                <td>
                                    <label>Max listings per day: <input type="number" name="max_listings_per_day" value="5"></label><br>
                                    <label>Max edits per day: <input type="number" name="max_edits_per_day" value="20"></label>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Moderation</th>
                                <td>
                                    <label><input type="checkbox" name="auto_publish"> Auto-publish listings</label><br>
                                    <label><input type="checkbox" name="require_image"> Require at least one image</label><br>
                                    <label><input type="checkbox" name="strip_exif" checked> Strip EXIF data from images</label>
                                </td>
                            </tr>
                            <tr>
                                <th scope="row">Notifications</th>
                                <td>
                                    <label>Admin email for reports: <input type="email" name="report_email" value="<?php echo get_option('admin_email'); ?>"></label><br>
                                    <label><input type="checkbox" name="email_on_report" checked> Email admin on new reports</label>
                                </td>
                            </tr>
                        </table>
                        <button type="submit" class="button button-primary">Save Settings</button>
                    </form>
                </div>
            </div>
        </div>

        <style>
        .aukrug-marketplace-admin .tab-content {
            display: none;
            padding: 20px 0;
        }
        
        .aukrug-marketplace-admin .tab-content.active {
            display: block;
        }
        
        .listings-filters {
            margin: 20px 0;
            padding: 15px;
            background: #f9f9f9;
            border: 1px solid #ddd;
        }
        
        .listings-filters > * {
            margin-right: 10px;
        }
        
        .verification-item {
            background: #fff;
            border: 1px solid #ddd;
            padding: 15px;
            margin: 10px 0;
        }
        
        .verification-actions {
            margin-top: 10px;
        }
        
        .verification-actions .button {
            margin-right: 5px;
        }
        </style>

        <script>
        jQuery(document).ready(function($) {
            // Tab switching
            $('.nav-tab').click(function(e) {
                e.preventDefault();
                
                $('.nav-tab').removeClass('nav-tab-active');
                $('.tab-content').removeClass('active');
                
                $(this).addClass('nav-tab-active');
                $('#tab-' + $(this).data('tab')).addClass('active');
            });
            
            // Load verification requests
            loadVerificationRequests();
            
            // Load reports
            loadReports();
            
            function loadVerificationRequests() {
                $.post(ajaxurl, {
                    action: 'get_verification_requests',
                    nonce: aukrugMarketplace.nonce
                }, function(response) {
                    if (response.success) {
                        var html = '';
                        response.data.forEach(function(request) {
                            html += '<div class="verification-item">';
                            html += '<h4>' + request.name + ' (' + request.type + ')</h4>';
                            html += '<p><strong>Address:</strong> ' + request.address + '</p>';
                            html += '<p><strong>Requested:</strong> ' + request.requested_at + '</p>';
                            html += '<div class="verification-actions">';
                            html += '<button class="button button-primary approve-verification" data-user-id="' + request.user_id + '" data-type="' + request.type + '">Approve</button>';
                            html += '<button class="button reject-verification" data-user-id="' + request.user_id + '">Reject</button>';
                            html += '</div>';
                            html += '</div>';
                        });
                        $('#verification-table').html(html || '<p>No pending requests</p>');
                    }
                });
            }
            
            function loadReports() {
                $.post(ajaxurl, {
                    action: 'get_marketplace_reports',
                    nonce: aukrugMarketplace.nonce
                }, function(response) {
                    if (response.success) {
                        var html = '<table class="wp-list-table widefat fixed striped"><thead><tr><th>Listing</th><th>Reporter</th><th>Reason</th><th>Date</th><th>Actions</th></tr></thead><tbody>';
                        response.data.forEach(function(report) {
                            html += '<tr>';
                            html += '<td><a href="' + report.listing_url + '">' + report.listing_title + '</a></td>';
                            html += '<td>' + report.reporter_name + '</td>';
                            html += '<td>' + report.reason + '</td>';
                            html += '<td>' + report.date + '</td>';
                            html += '<td><button class="button resolve-report" data-report-id="' + report.id + '">Resolve</button></td>';
                            html += '</tr>';
                        });
                        html += '</tbody></table>';
                        $('#reports-table').html(html || '<p>No reports</p>');
                    }
                });
            }
            
            // Handle verification approval
            $(document).on('click', '.approve-verification', function() {
                var userId = $(this).data('user-id');
                var type = $(this).data('type');
                
                $.post(ajaxurl, {
                    action: 'approve_verification',
                    user_id: userId,
                    type: type,
                    nonce: aukrugMarketplace.nonce
                }, function(response) {
                    if (response.success) {
                        alert('Verification approved');
                        loadVerificationRequests();
                    } else {
                        alert('Error: ' + response.data);
                    }
                });
            });
            
            // Handle verification rejection
            $(document).on('click', '.reject-verification', function() {
                var userId = $(this).data('user-id');
                
                $.post(ajaxurl, {
                    action: 'reject_verification',
                    user_id: userId,
                    nonce: aukrugMarketplace.nonce
                }, function(response) {
                    if (response.success) {
                        alert('Verification rejected');
                        loadVerificationRequests();
                    } else {
                        alert('Error: ' + response.data);
                    }
                });
            });
            
            // Handle report resolution
            $(document).on('click', '.resolve-report', function() {
                var reportId = $(this).data('report-id');
                
                $.post(ajaxurl, {
                    action: 'resolve_report',
                    report_id: reportId,
                    nonce: aukrugMarketplace.nonce
                }, function(response) {
                    if (response.success) {
                        alert('Report resolved');
                        loadReports();
                    } else {
                        alert('Error: ' + response.data);
                    }
                });
            });
        });
        </script>
        <?php
    }

    /**
     * Get verification requests
     */
    public function get_verification_requests() {
        check_ajax_referer('aukrug_marketplace_admin', 'nonce');
        
        if (!current_user_can('manage_options')) {
            wp_die('Unauthorized');
        }

        global $wpdb;
        
        $requests = $wpdb->get_results("
            SELECT u.ID as user_id, u.display_name, um.meta_value as verification_data
            FROM {$wpdb->users} u
            JOIN {$wpdb->usermeta} um ON u.ID = um.user_id
            WHERE um.meta_key = 'au_verification_pending'
        ");

        $formatted_requests = array();
        
        foreach ($requests as $request) {
            $verification_data = maybe_unserialize($request->verification_data);
            
            $formatted_requests[] = array(
                'user_id' => $request->user_id,
                'name' => $verification_data['name'],
                'type' => $verification_data['type'],
                'address' => $verification_data['address'],
                'requested_at' => $verification_data['requested_at'],
            );
        }

        wp_send_json_success($formatted_requests);
    }

    /**
     * Get marketplace reports
     */
    public function get_marketplace_reports() {
        check_ajax_referer('aukrug_marketplace_admin', 'nonce');
        
        if (!current_user_can('manage_options')) {
            wp_die('Unauthorized');
        }

        $reports = get_posts(array(
            'post_type' => 'market_report',
            'post_status' => 'private',
            'posts_per_page' => 50,
        ));

        $formatted_reports = array();
        
        foreach ($reports as $report) {
            $listing_id = get_post_meta($report->ID, 'listing_id', true);
            $reporter_id = get_post_meta($report->ID, 'reporter_id', true);
            
            $listing = get_post($listing_id);
            $reporter = get_user_by('ID', $reporter_id);
            
            $formatted_reports[] = array(
                'id' => $report->ID,
                'listing_title' => $listing ? $listing->post_title : 'Unknown',
                'listing_url' => $listing ? get_edit_post_link($listing_id) : '#',
                'reporter_name' => $reporter ? $reporter->display_name : 'Unknown',
                'reason' => $report->post_content,
                'date' => $report->post_date,
            );
        }

        wp_send_json_success($formatted_reports);
    }

    /**
     * Handle verification approval
     */
    public function handle_approve_verification() {
        check_ajax_referer('aukrug_marketplace_admin', 'nonce');
        
        if (!current_user_can('manage_options')) {
            wp_die('Unauthorized');
        }

        $user_id = intval($_POST['user_id']);
        $type = sanitize_text_field($_POST['type']);

        if ($type === 'resident') {
            update_user_meta($user_id, 'au_verified_resident', true);
        } elseif ($type === 'business') {
            update_user_meta($user_id, 'au_verified_business', true);
        }

        // Remove pending request
        delete_user_meta($user_id, 'au_verification_pending');

        // Send notification email to user
        $user = get_user_by('ID', $user_id);
        if ($user) {
            wp_mail(
                $user->user_email,
                'Verification Approved - Aukrug Marketplace',
                'Your verification request has been approved. You can now create marketplace listings.'
            );
        }

        wp_send_json_success();
    }

    /**
     * Handle verification rejection
     */
    public function handle_reject_verification() {
        check_ajax_referer('aukrug_marketplace_admin', 'nonce');
        
        if (!current_user_can('manage_options')) {
            wp_die('Unauthorized');
        }

        $user_id = intval($_POST['user_id']);
        
        // Remove pending request
        delete_user_meta($user_id, 'au_verification_pending');

        // Send notification email to user
        $user = get_user_by('ID', $user_id);
        if ($user) {
            wp_mail(
                $user->user_email,
                'Verification Request - Aukrug Marketplace',
                'Your verification request has been reviewed. Please contact us if you have questions.'
            );
        }

        wp_send_json_success();
    }

    /**
     * Resolve report
     */
    public function resolve_report() {
        check_ajax_referer('aukrug_marketplace_admin', 'nonce');
        
        if (!current_user_can('manage_options')) {
            wp_die('Unauthorized');
        }

        $report_id = intval($_POST['report_id']);
        
        // Delete the report
        wp_delete_post($report_id, true);

        wp_send_json_success();
    }
}

// Initialize admin
if (is_admin()) {
    new Aukrug_Marketplace_Admin();
}
