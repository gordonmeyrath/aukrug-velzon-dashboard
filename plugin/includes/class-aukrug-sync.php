<?php
/**
 * Sync utilities for Aukrug Connect
 * 
 * Handles delta synchronization and ETag/Last-Modified helpers
 */

if (!defined('ABSPATH')) {
    exit;
}

class AukrugSync
{
    public function __construct()
    {
        add_action('post_updated', [$this, 'updateSyncTimestamp'], 10, 3);
        add_action('wp_insert_post', [$this, 'updateSyncTimestamp'], 10, 3);
        add_action('delete_post', [$this, 'updateSyncTimestamp']);
    }

    /**
     * Update sync timestamp when content changes
     */
    public function updateSyncTimestamp($post_id, $post_after = null, $post_before = null)
    {
        if (wp_is_post_revision($post_id)) {
            return;
        }

        $post_type = get_post_type($post_id);
        if (strpos($post_type, 'aukrug_') !== 0) {
            return;
        }

        // Update global sync timestamp
        update_option('aukrug_sync_timestamp', current_time('mysql', true));
        
        // Update per-type sync timestamp
        $type = str_replace('aukrug_', '', $post_type);
        update_option("aukrug_sync_timestamp_{$type}", current_time('mysql', true));
    }

    /**
     * Get last modification timestamp for content type
     */
    public function getLastModified($post_type)
    {
        $posts = get_posts([
            'post_type' => $post_type,
            'posts_per_page' => 1,
            'orderby' => 'modified',
            'order' => 'DESC',
            'post_status' => 'any',
        ]);

        if (!empty($posts)) {
            return $posts[0]->post_modified_gmt;
        }

        return null;
    }

    /**
     * Generate ETag for content
     */
    public function generateETag($data)
    {
        return md5(serialize($data) . get_option('aukrug_sync_timestamp', ''));
    }

    /**
     * Check if content has been modified since given timestamp
     */
    public function isModifiedSince($post_type, $since_timestamp)
    {
        $last_modified = $this->getLastModified($post_type);
        
        if (!$last_modified || !$since_timestamp) {
            return true;
        }

        return strtotime($last_modified) > strtotime($since_timestamp);
    }

    /**
     * Get changed post IDs since timestamp
     */
    public function getChangedPostIds($post_type, $since_timestamp)
    {
        global $wpdb;

        if (!$since_timestamp) {
            return [];
        }

        $sql = $wpdb->prepare(
            "SELECT ID FROM {$wpdb->posts} 
             WHERE post_type = %s 
             AND post_modified_gmt > %s 
             ORDER BY post_modified_gmt DESC",
            $post_type,
            $since_timestamp
        );

        return $wpdb->get_col($sql);
    }

    /**
     * Get deleted post IDs (from audit log)
     */
    public function getDeletedPostIds($post_type, $since_timestamp)
    {
        global $wpdb;

        if (!$since_timestamp) {
            return [];
        }

        $audit_table = $wpdb->prefix . 'aukrug_audit_log';
        
        $sql = $wpdb->prepare(
            "SELECT object_id FROM {$audit_table} 
             WHERE action = 'post_deleted' 
             AND object_type = %s 
             AND created_at > %s 
             ORDER BY created_at DESC",
            $post_type,
            $since_timestamp
        );

        return $wpdb->get_col($sql);
    }

    /**
     * Build delta response for sync endpoint
     */
    public function buildDeltaResponse($post_types, $since_timestamp)
    {
        $response = [
            'timestamp' => current_time('mysql', true),
            'changes' => [],
            'deletions' => [],
        ];

        foreach ($post_types as $post_type_short) {
            $post_type = 'aukrug_' . $post_type_short;
            
            if (!post_type_exists($post_type)) {
                continue;
            }

            // Get changed posts
            $changed_ids = $this->getChangedPostIds($post_type, $since_timestamp);
            if (!empty($changed_ids)) {
                $response['changes'][$post_type_short] = $changed_ids;
            }

            // Get deleted posts
            $deleted_ids = $this->getDeletedPostIds($post_type, $since_timestamp);
            if (!empty($deleted_ids)) {
                $response['deletions'][$post_type_short] = $deleted_ids;
            }
        }

        return $response;
    }
}
