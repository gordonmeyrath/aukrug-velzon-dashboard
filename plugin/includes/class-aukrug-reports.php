<?php
/**
 * Reports handling for Aukrug Connect
 * 
 * Manages user-submitted reports with media support and GDPR compliance
 */

if (!defined('ABSPATH')) {
    exit;
}

class AukrugReports
{
    public function __construct()
    {
        add_action('init', [$this, 'init']);
        add_action('wp_ajax_nopriv_aukrug_upload_media', [$this, 'handleMediaUpload']);
        add_action('wp_ajax_aukrug_upload_media', [$this, 'handleMediaUpload']);
    }

    public function init()
    {
        // Add custom columns to reports list
        add_filter('manage_aukrug_report_posts_columns', [$this, 'addReportColumns']);
        add_action('manage_aukrug_report_posts_custom_column', [$this, 'fillReportColumns'], 10, 2);
    }

    /**
     * Handle media upload for reports
     */
    public function handleMediaUpload()
    {
        // Verify nonce
        if (!wp_verify_nonce($_POST['nonce'] ?? '', 'aukrug_media_upload')) {
            wp_die('Security check failed');
        }

        // Check file upload
        if (!isset($_FILES['media_file'])) {
            wp_send_json_error('No file provided');
        }

        $file = $_FILES['media_file'];
        
        // Validate file type
        $allowed_types = ['image/jpeg', 'image/png', 'image/gif', 'video/mp4', 'video/quicktime'];
        if (!in_array($file['type'], $allowed_types)) {
            wp_send_json_error('File type not allowed');
        }

        // Validate file size (max 10MB)
        if ($file['size'] > 10 * 1024 * 1024) {
            wp_send_json_error('File too large. Maximum 10MB allowed.');
        }

        // Handle upload
        $upload_overrides = [
            'test_form' => false,
            'mimes' => [
                'jpg|jpeg|jpe' => 'image/jpeg',
                'png' => 'image/png',
                'gif' => 'image/gif',
                'mp4' => 'video/mp4',
                'mov' => 'video/quicktime',
            ],
        ];

        $uploaded_file = wp_handle_upload($file, $upload_overrides);

        if (isset($uploaded_file['error'])) {
            wp_send_json_error($uploaded_file['error']);
        }

        // Create attachment
        $attachment = [
            'guid' => $uploaded_file['url'],
            'post_mime_type' => $uploaded_file['type'],
            'post_title' => sanitize_file_name(basename($uploaded_file['file'])),
            'post_content' => '',
            'post_status' => 'inherit',
        ];

        $attachment_id = wp_insert_attachment($attachment, $uploaded_file['file']);

        if (is_wp_error($attachment_id)) {
            wp_send_json_error('Failed to create attachment');
        }

        // Generate metadata
        require_once ABSPATH . 'wp-admin/includes/image.php';
        $attachment_metadata = wp_generate_attachment_metadata($attachment_id, $uploaded_file['file']);
        wp_update_attachment_metadata($attachment_id, $attachment_metadata);

        // Log upload for GDPR compliance
        $this->logAuditEvent('media_uploaded', 'attachment', $attachment_id, [
            'file_type' => $uploaded_file['type'],
            'file_size' => $file['size'],
            'original_name' => $file['name'],
        ]);

        wp_send_json_success([
            'attachment_id' => $attachment_id,
            'url' => $uploaded_file['url'],
            'type' => $uploaded_file['type'],
        ]);
    }

    /**
     * Add custom columns to reports admin list
     */
    public function addReportColumns($columns)
    {
        $new_columns = [];
        $new_columns['cb'] = $columns['cb'];
        $new_columns['title'] = $columns['title'];
        $new_columns['category'] = __('Category', 'aukrug-connect');
        $new_columns['location'] = __('Location', 'aukrug-connect');
        $new_columns['media'] = __('Media', 'aukrug-connect');
        $new_columns['ip_address'] = __('IP Address', 'aukrug-connect');
        $new_columns['date'] = $columns['date'];

        return $new_columns;
    }

    /**
     * Fill custom columns in reports admin list
     */
    public function fillReportColumns($column, $post_id)
    {
        switch ($column) {
            case 'category':
                $category = get_post_meta($post_id, '_aukrug_report_category', true);
                echo esc_html(ucfirst($category ?: 'other'));
                break;

            case 'location':
                $latitude = get_post_meta($post_id, '_aukrug_latitude', true);
                $longitude = get_post_meta($post_id, '_aukrug_longitude', true);
                $address = get_post_meta($post_id, '_aukrug_address', true);

                if ($latitude && $longitude) {
                    printf(
                        '<a href="https://maps.google.com/maps?q=%s,%s" target="_blank" title="%s">📍 %s, %s</a>',
                        esc_attr($latitude),
                        esc_attr($longitude),
                        esc_attr($address ?: 'View on map'),
                        esc_html(number_format($latitude, 6)),
                        esc_html(number_format($longitude, 6))
                    );
                } else {
                    echo '—';
                }
                break;

            case 'media':
                $attachments = get_attached_media('', $post_id);
                $count = count($attachments);
                
                if ($count > 0) {
                    printf('<span class="media-count">%d %s</span>', 
                        $count, 
                        _n('file', 'files', $count, 'aukrug-connect')
                    );
                } else {
                    echo '—';
                }
                break;

            case 'ip_address':
                $ip = get_post_meta($post_id, '_aukrug_report_ip', true);
                echo esc_html($ip ?: 'unknown');
                break;
        }
    }

    /**
     * Get report statistics for admin dashboard
     */
    public function getReportStats()
    {
        global $wpdb;

        $stats = [];

        // Total reports
        $stats['total'] = wp_count_posts('aukrug_report')->publish;

        // Reports by category
        $categories = $wpdb->get_results(
            "SELECT meta_value as category, COUNT(*) as count 
             FROM {$wpdb->postmeta} pm 
             JOIN {$wpdb->posts} p ON pm.post_id = p.ID 
             WHERE pm.meta_key = '_aukrug_report_category' 
             AND p.post_type = 'aukrug_report' 
             AND p.post_status = 'publish'
             GROUP BY meta_value"
        );

        $stats['by_category'] = [];
        foreach ($categories as $cat) {
            $stats['by_category'][$cat->category] = (int) $cat->count;
        }

        // Reports in last 30 days
        $stats['recent'] = (int) $wpdb->get_var(
            $wpdb->prepare(
                "SELECT COUNT(*) FROM {$wpdb->posts} 
                 WHERE post_type = 'aukrug_report' 
                 AND post_status = 'publish' 
                 AND post_date > %s",
                date('Y-m-d H:i:s', strtotime('-30 days'))
            )
        );

        return $stats;
    }

    /**
     * Export reports data for GDPR compliance
     */
    public function exportReportsData($ip_address)
    {
        global $wpdb;

        $reports = $wpdb->get_results(
            $wpdb->prepare(
                "SELECT p.*, pm.meta_value as ip_address 
                 FROM {$wpdb->posts} p 
                 JOIN {$wpdb->postmeta} pm ON p.ID = pm.post_id 
                 WHERE p.post_type = 'aukrug_report' 
                 AND pm.meta_key = '_aukrug_report_ip' 
                 AND pm.meta_value = %s",
                $ip_address
            )
        );

        $export_data = [];
        foreach ($reports as $report) {
            $export_data[] = [
                'id' => $report->ID,
                'title' => $report->post_title,
                'content' => $report->post_content,
                'created_at' => $report->post_date,
                'category' => get_post_meta($report->ID, '_aukrug_report_category', true),
                'location' => [
                    'latitude' => get_post_meta($report->ID, '_aukrug_latitude', true),
                    'longitude' => get_post_meta($report->ID, '_aukrug_longitude', true),
                    'address' => get_post_meta($report->ID, '_aukrug_address', true),
                ],
            ];
        }

        return $export_data;
    }

    /**
     * Delete reports data for GDPR compliance
     */
    public function deleteReportsData($ip_address)
    {
        global $wpdb;

        // Get reports to delete
        $report_ids = $wpdb->get_col(
            $wpdb->prepare(
                "SELECT p.ID 
                 FROM {$wpdb->posts} p 
                 JOIN {$wpdb->postmeta} pm ON p.ID = pm.post_id 
                 WHERE p.post_type = 'aukrug_report' 
                 AND pm.meta_key = '_aukrug_report_ip' 
                 AND pm.meta_value = %s",
                $ip_address
            )
        );

        $deleted_count = 0;
        foreach ($report_ids as $report_id) {
            if (wp_delete_post($report_id, true)) {
                $deleted_count++;
                
                // Log deletion for audit
                $this->logAuditEvent('report_deleted_gdpr', 'aukrug_report', $report_id, [
                    'ip_address' => $ip_address,
                    'reason' => 'GDPR deletion request',
                ]);
            }
        }

        return $deleted_count;
    }

    private function logAuditEvent($action, $object_type, $object_id, $data = [])
    {
        global $wpdb;
        
        $wpdb->insert(
            $wpdb->prefix . 'aukrug_audit_log',
            [
                'user_id' => get_current_user_id() ?: null,
                'action' => $action,
                'object_type' => $object_type,
                'object_id' => $object_id,
                'data' => json_encode($data),
                'ip_address' => $this->getClientIP(),
                'created_at' => current_time('mysql'),
            ]
        );
    }

    private function getClientIP()
    {
        $ip_keys = ['HTTP_CLIENT_IP', 'HTTP_X_FORWARDED_FOR', 'REMOTE_ADDR'];
        foreach ($ip_keys as $key) {
            if (array_key_exists($key, $_SERVER) === true) {
                foreach (explode(',', $_SERVER[$key]) as $ip) {
                    $ip = trim($ip);
                    if (filter_var($ip, FILTER_VALIDATE_IP, FILTER_FLAG_NO_PRIV_RANGE | FILTER_FLAG_NO_RES_RANGE) !== false) {
                        return $ip;
                    }
                }
            }
        }
        return $_SERVER['REMOTE_ADDR'] ?? 'unknown';
    }
}
