<?php
/**
 * Custom Post Types for Aukrug Connect
 * 
 * Registers CPTs: place, route, event, notice, download, provider, report
 * Taxonomies: audience (tourist, resident, kita, schule), category
 */

if (!defined('ABSPATH')) {
    exit;
}

class AukrugCPT
{
    public function __construct()
    {
        add_action('init', [$this, 'registerPostTypes']);
        add_action('init', [$this, 'registerTaxonomies']);
        add_action('add_meta_boxes', [$this, 'addMetaBoxes']);
        add_action('save_post', [$this, 'saveMetaData']);
    }

    public function registerPostTypes()
    {
        // Place CPT
        register_post_type('aukrug_place', [
            'labels' => [
                'name' => __('Places', 'aukrug-connect'),
                'singular_name' => __('Place', 'aukrug-connect'),
                'add_new_item' => __('Add New Place', 'aukrug-connect'),
                'edit_item' => __('Edit Place', 'aukrug-connect'),
                'view_item' => __('View Place', 'aukrug-connect'),
            ],
            'public' => false,
            'show_ui' => true,
            'show_in_rest' => true,
            'supports' => ['title', 'editor', 'thumbnail', 'custom-fields'],
            'has_archive' => false,
            'rewrite' => false,
            'capability_type' => 'post',
        ]);

        // Route CPT
        register_post_type('aukrug_route', [
            'labels' => [
                'name' => __('Routes', 'aukrug-connect'),
                'singular_name' => __('Route', 'aukrug-connect'),
                'add_new_item' => __('Add New Route', 'aukrug-connect'),
                'edit_item' => __('Edit Route', 'aukrug-connect'),
                'view_item' => __('View Route', 'aukrug-connect'),
            ],
            'public' => false,
            'show_ui' => true,
            'show_in_rest' => true,
            'supports' => ['title', 'editor', 'thumbnail', 'custom-fields'],
            'has_archive' => false,
            'rewrite' => false,
        ]);

        // Event CPT
        register_post_type('aukrug_event', [
            'labels' => [
                'name' => __('Events', 'aukrug-connect'),
                'singular_name' => __('Event', 'aukrug-connect'),
                'add_new_item' => __('Add New Event', 'aukrug-connect'),
                'edit_item' => __('Edit Event', 'aukrug-connect'),
                'view_item' => __('View Event', 'aukrug-connect'),
            ],
            'public' => false,
            'show_ui' => true,
            'show_in_rest' => true,
            'supports' => ['title', 'editor', 'thumbnail', 'custom-fields'],
            'has_archive' => false,
            'rewrite' => false,
        ]);

        // Notice CPT
        register_post_type('aukrug_notice', [
            'labels' => [
                'name' => __('Notices', 'aukrug-connect'),
                'singular_name' => __('Notice', 'aukrug-connect'),
                'add_new_item' => __('Add New Notice', 'aukrug-connect'),
                'edit_item' => __('Edit Notice', 'aukrug-connect'),
                'view_item' => __('View Notice', 'aukrug-connect'),
            ],
            'public' => false,
            'show_ui' => true,
            'show_in_rest' => true,
            'supports' => ['title', 'editor', 'thumbnail', 'custom-fields'],
            'has_archive' => false,
            'rewrite' => false,
        ]);

        // Download CPT
        register_post_type('aukrug_download', [
            'labels' => [
                'name' => __('Downloads', 'aukrug-connect'),
                'singular_name' => __('Download', 'aukrug-connect'),
                'add_new_item' => __('Add New Download', 'aukrug-connect'),
                'edit_item' => __('Edit Download', 'aukrug-connect'),
                'view_item' => __('View Download', 'aukrug-connect'),
            ],
            'public' => false,
            'show_ui' => true,
            'show_in_rest' => true,
            'supports' => ['title', 'editor', 'thumbnail', 'custom-fields'],
            'has_archive' => false,
            'rewrite' => false,
        ]);

        // Provider CPT
        register_post_type('aukrug_provider', [
            'labels' => [
                'name' => __('Providers', 'aukrug-connect'),
                'singular_name' => __('Provider', 'aukrug-connect'),
                'add_new_item' => __('Add New Provider', 'aukrug-connect'),
                'edit_item' => __('Edit Provider', 'aukrug-connect'),
                'view_item' => __('View Provider', 'aukrug-connect'),
            ],
            'public' => false,
            'show_ui' => true,
            'show_in_rest' => true,
            'supports' => ['title', 'editor', 'thumbnail', 'custom-fields'],
            'has_archive' => false,
            'rewrite' => false,
        ]);

        // Report CPT (for user submissions)
        register_post_type('aukrug_report', [
            'labels' => [
                'name' => __('Reports', 'aukrug-connect'),
                'singular_name' => __('Report', 'aukrug-connect'),
                'view_item' => __('View Report', 'aukrug-connect'),
            ],
            'public' => false,
            'show_ui' => true,
            'show_in_rest' => false,
            'supports' => ['title', 'editor', 'custom-fields'],
            'has_archive' => false,
            'rewrite' => false,
            'capabilities' => [
                'create_posts' => 'manage_options',
                'edit_posts' => 'manage_options',
                'edit_others_posts' => 'manage_options',
                'publish_posts' => 'manage_options',
                'read_private_posts' => 'manage_options',
            ],
        ]);
    }

    public function registerTaxonomies()
    {
        // Audience taxonomy
        register_taxonomy('aukrug_audience', [
            'aukrug_place', 'aukrug_route', 'aukrug_event', 'aukrug_notice', 'aukrug_download'
        ], [
            'labels' => [
                'name' => __('Audience', 'aukrug-connect'),
                'singular_name' => __('Audience', 'aukrug-connect'),
                'add_new_item' => __('Add New Audience', 'aukrug-connect'),
                'edit_item' => __('Edit Audience', 'aukrug-connect'),
            ],
            'hierarchical' => false,
            'public' => false,
            'show_ui' => true,
            'show_in_rest' => true,
            'rewrite' => false,
        ]);

        // Category taxonomy
        register_taxonomy('aukrug_category', [
            'aukrug_place', 'aukrug_route', 'aukrug_event', 'aukrug_notice', 'aukrug_download'
        ], [
            'labels' => [
                'name' => __('Categories', 'aukrug-connect'),
                'singular_name' => __('Category', 'aukrug-connect'),
                'add_new_item' => __('Add New Category', 'aukrug-connect'),
                'edit_item' => __('Edit Category', 'aukrug-connect'),
            ],
            'hierarchical' => true,
            'public' => false,
            'show_ui' => true,
            'show_in_rest' => true,
            'rewrite' => false,
        ]);

        // Insert default terms
        $this->insertDefaultTerms();
    }

    private function insertDefaultTerms()
    {
        // Default audience terms
        $audiences = ['tourist', 'resident', 'kita', 'schule'];
        foreach ($audiences as $audience) {
            if (!term_exists($audience, 'aukrug_audience')) {
                wp_insert_term($audience, 'aukrug_audience', [
                    'description' => ucfirst($audience) . ' specific content',
                    'slug' => $audience,
                ]);
            }
        }
    }

    public function addMetaBoxes()
    {
        $post_types = ['aukrug_place', 'aukrug_route', 'aukrug_event'];
        
        foreach ($post_types as $post_type) {
            add_meta_box(
                'aukrug_location_meta',
                __('Location Data', 'aukrug-connect'),
                [$this, 'renderLocationMetaBox'],
                $post_type,
                'normal',
                'high'
            );
        }
    }

    public function renderLocationMetaBox($post)
    {
        wp_nonce_field('aukrug_location_meta', 'aukrug_location_nonce');
        
        $latitude = get_post_meta($post->ID, '_aukrug_latitude', true);
        $longitude = get_post_meta($post->ID, '_aukrug_longitude', true);
        $address = get_post_meta($post->ID, '_aukrug_address', true);
        
        echo '<table class="form-table">';
        echo '<tr><th><label for="aukrug_latitude">' . __('Latitude', 'aukrug-connect') . '</label></th>';
        echo '<td><input type="number" step="any" id="aukrug_latitude" name="aukrug_latitude" value="' . esc_attr($latitude) . '" /></td></tr>';
        echo '<tr><th><label for="aukrug_longitude">' . __('Longitude', 'aukrug-connect') . '</label></th>';
        echo '<td><input type="number" step="any" id="aukrug_longitude" name="aukrug_longitude" value="' . esc_attr($longitude) . '" /></td></tr>';
        echo '<tr><th><label for="aukrug_address">' . __('Address', 'aukrug-connect') . '</label></th>';
        echo '<td><textarea id="aukrug_address" name="aukrug_address" rows="3" cols="50">' . esc_textarea($address) . '</textarea></td></tr>';
        echo '</table>';
    }

    public function saveMetaData($post_id)
    {
        if (!isset($_POST['aukrug_location_nonce']) || !wp_verify_nonce($_POST['aukrug_location_nonce'], 'aukrug_location_meta')) {
            return;
        }

        if (defined('DOING_AUTOSAVE') && DOING_AUTOSAVE) {
            return;
        }

        if (!current_user_can('edit_post', $post_id)) {
            return;
        }

        $fields = ['aukrug_latitude', 'aukrug_longitude', 'aukrug_address'];
        
        foreach ($fields as $field) {
            if (isset($_POST[$field])) {
                update_post_meta($post_id, '_' . $field, sanitize_text_field($_POST[$field]));
            }
        }
    }
}
