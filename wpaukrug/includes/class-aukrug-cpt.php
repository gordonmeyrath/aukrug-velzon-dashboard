<?php
/**
 * WordPress Post Types for Aukrug
 * Extended with App-Only Caches and Reports
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class Aukrug_CPT {
    
    public function __construct() {
        add_action('init', array($this, 'register_post_types'));
        add_action('init', array($this, 'register_taxonomies'));
        add_action('add_meta_boxes', array($this, 'add_meta_boxes'));
        add_action('save_post', array($this, 'save_meta_boxes'));
    }

    public function register_post_types() {
        // Geocache Post Type
        register_post_type('geocache', array(
            'labels' => array(
                'name' => 'Geocaches',
                'singular_name' => 'Geocache',
                'add_new' => 'Neuer Geocache',
                'add_new_item' => 'Neuen Geocache hinzufügen',
                'edit_item' => 'Geocache bearbeiten',
                'new_item' => 'Neuer Geocache',
                'view_item' => 'Geocache anzeigen',
                'search_items' => 'Geocaches suchen',
                'not_found' => 'Keine Geocaches gefunden',
                'not_found_in_trash' => 'Keine Geocaches im Papierkorb gefunden'
            ),
            'public' => true,
            'publicly_queryable' => true,
            'show_ui' => true,
            'show_in_menu' => true,
            'query_var' => true,
            'rewrite' => array('slug' => 'geocache'),
            'capability_type' => 'post',
            'has_archive' => true,
            'hierarchical' => false,
            'menu_position' => 20,
            'menu_icon' => 'dashicons-location',
            'supports' => array('title', 'editor', 'excerpt', 'custom-fields', 'thumbnail'),
            'show_in_rest' => true
        ));

        // App-Only Cache Post Type
        register_post_type('app_cache', array(
            'labels' => array(
                'name' => 'App-Only Caches',
                'singular_name' => 'App-Only Cache',
                'add_new' => 'Neuer App-Cache',
                'add_new_item' => 'Neuen App-Cache hinzufügen',
                'edit_item' => 'App-Cache bearbeiten',
                'new_item' => 'Neuer App-Cache',
                'view_item' => 'App-Cache anzeigen',
                'search_items' => 'App-Caches suchen',
                'not_found' => 'Keine App-Caches gefunden',
                'not_found_in_trash' => 'Keine App-Caches im Papierkorb gefunden'
            ),
            'public' => false,
            'publicly_queryable' => false,
            'show_ui' => true,
            'show_in_menu' => true,
            'query_var' => true,
            'rewrite' => array('slug' => 'app-cache'),
            'capability_type' => 'post',
            'has_archive' => false,
            'hierarchical' => false,
            'menu_position' => 21,
            'menu_icon' => 'dashicons-smartphone',
            'supports' => array('title', 'editor', 'excerpt', 'custom-fields', 'thumbnail'),
            'show_in_rest' => true
        ));

        // Reports Post Type
        register_post_type('aukrug_report', array(
            'labels' => array(
                'name' => 'Meldungen',
                'singular_name' => 'Meldung',
                'add_new' => 'Neue Meldung',
                'add_new_item' => 'Neue Meldung hinzufügen',
                'edit_item' => 'Meldung bearbeiten',
                'new_item' => 'Neue Meldung',
                'view_item' => 'Meldung anzeigen',
                'search_items' => 'Meldungen suchen',
                'not_found' => 'Keine Meldungen gefunden',
                'not_found_in_trash' => 'Keine Meldungen im Papierkorb gefunden'
            ),
            'public' => true,
            'publicly_queryable' => false,
            'show_ui' => true,
            'show_in_menu' => true,
            'query_var' => true,
            'rewrite' => array('slug' => 'report'),
            'capability_type' => 'post',
            'has_archive' => false,
            'hierarchical' => false,
            'menu_position' => 22,
            'menu_icon' => 'dashicons-warning',
            'supports' => array('title', 'editor', 'author', 'custom-fields'),
            'show_in_rest' => true
        ));

        // Community Events Post Type
        register_post_type('aukrug_event', array(
            'labels' => array(
                'name' => 'Community Events',
                'singular_name' => 'Event',
                'add_new' => 'Neues Event',
                'add_new_item' => 'Neues Event hinzufügen',
                'edit_item' => 'Event bearbeiten',
                'new_item' => 'Neues Event',
                'view_item' => 'Event anzeigen',
                'search_items' => 'Events suchen',
                'not_found' => 'Keine Events gefunden',
                'not_found_in_trash' => 'Keine Events im Papierkorb gefunden'
            ),
            'public' => true,
            'publicly_queryable' => true,
            'show_ui' => true,
            'show_in_menu' => true,
            'query_var' => true,
            'rewrite' => array('slug' => 'event'),
            'capability_type' => 'post',
            'has_archive' => true,
            'hierarchical' => false,
            'menu_position' => 23,
            'menu_icon' => 'dashicons-calendar-alt',
            'supports' => array('title', 'editor', 'excerpt', 'custom-fields', 'thumbnail'),
            'show_in_rest' => true
        ));

        // Downloads Post Type
        register_post_type('aukrug_download', array(
            'labels' => array(
                'name' => 'Downloads',
                'singular_name' => 'Download',
                'add_new' => 'Neuer Download',
                'add_new_item' => 'Neuen Download hinzufügen',
                'edit_item' => 'Download bearbeiten',
                'new_item' => 'Neuer Download',
                'view_item' => 'Download anzeigen',
                'search_items' => 'Downloads suchen',
                'not_found' => 'Keine Downloads gefunden',
                'not_found_in_trash' => 'Keine Downloads im Papierkorb gefunden'
            ),
            'public' => true,
            'publicly_queryable' => true,
            'show_ui' => true,
            'show_in_menu' => true,
            'query_var' => true,
            'rewrite' => array('slug' => 'download'),
            'capability_type' => 'post',
            'has_archive' => true,
            'hierarchical' => false,
            'menu_position' => 24,
            'menu_icon' => 'dashicons-download',
            'supports' => array('title', 'editor', 'excerpt', 'custom-fields', 'thumbnail'),
            'show_in_rest' => true
        ));
    }

    public function register_taxonomies() {
        // Cache Type Taxonomy
        register_taxonomy('cache_type', array('geocache', 'app_cache'), array(
            'labels' => array(
                'name' => 'Cache-Typen',
                'singular_name' => 'Cache-Typ',
                'search_items' => 'Cache-Typen suchen',
                'all_items' => 'Alle Cache-Typen',
                'edit_item' => 'Cache-Typ bearbeiten',
                'update_item' => 'Cache-Typ aktualisieren',
                'add_new_item' => 'Neuen Cache-Typ hinzufügen',
                'new_item_name' => 'Neuer Cache-Typ Name'
            ),
            'hierarchical' => true,
            'show_ui' => true,
            'show_admin_column' => true,
            'query_var' => true,
            'rewrite' => array('slug' => 'cache-type'),
            'show_in_rest' => true
        ));

        // Report Category Taxonomy
        register_taxonomy('report_category', 'aukrug_report', array(
            'labels' => array(
                'name' => 'Meldungs-Kategorien',
                'singular_name' => 'Meldungs-Kategorie',
                'search_items' => 'Kategorien suchen',
                'all_items' => 'Alle Kategorien',
                'edit_item' => 'Kategorie bearbeiten',
                'update_item' => 'Kategorie aktualisieren',
                'add_new_item' => 'Neue Kategorie hinzufügen',
                'new_item_name' => 'Neuer Kategorie Name'
            ),
            'hierarchical' => true,
            'show_ui' => true,
            'show_admin_column' => true,
            'query_var' => true,
            'rewrite' => array('slug' => 'report-category'),
            'show_in_rest' => true
        ));

        // Event Category Taxonomy
        register_taxonomy('event_category', 'aukrug_event', array(
            'labels' => array(
                'name' => 'Event-Kategorien',
                'singular_name' => 'Event-Kategorie',
                'search_items' => 'Kategorien suchen',
                'all_items' => 'Alle Kategorien',
                'edit_item' => 'Kategorie bearbeiten',
                'update_item' => 'Kategorie aktualisieren',
                'add_new_item' => 'Neue Kategorie hinzufügen',
                'new_item_name' => 'Neuer Kategorie Name'
            ),
            'hierarchical' => true,
            'show_ui' => true,
            'show_admin_column' => true,
            'query_var' => true,
            'rewrite' => array('slug' => 'event-category'),
            'show_in_rest' => true
        ));
    }

    public function add_meta_boxes() {
        // Geocache Meta Box
        add_meta_box(
            'geocache_details',
            'Geocache Details',
            array($this, 'geocache_meta_box'),
            'geocache',
            'normal',
            'high'
        );

        // App Cache Meta Box
        add_meta_box(
            'app_cache_details',
            'App-Cache Details',
            array($this, 'app_cache_meta_box'),
            'app_cache',
            'normal',
            'high'
        );

        // Report Meta Box
        add_meta_box(
            'report_details',
            'Meldungs-Details',
            array($this, 'report_meta_box'),
            'aukrug_report',
            'normal',
            'high'
        );

        // Event Meta Box
        add_meta_box(
            'event_details',
            'Event-Details',
            array($this, 'event_meta_box'),
            'aukrug_event',
            'normal',
            'high'
        );
    }

    public function geocache_meta_box($post) {
        wp_nonce_field('geocache_meta_nonce', 'geocache_meta_nonce');
        
        $gc_code = get_post_meta($post->ID, 'gc_code', true);
        $latitude = get_post_meta($post->ID, 'latitude', true);
        $longitude = get_post_meta($post->ID, 'longitude', true);
        $difficulty = get_post_meta($post->ID, 'difficulty', true);
        $terrain = get_post_meta($post->ID, 'terrain', true);
        $cache_owner = get_post_meta($post->ID, 'cache_owner', true);
        $cache_size = get_post_meta($post->ID, 'cache_size', true);
        
        echo '<table class="form-table">';
        echo '<tr><th><label for="gc_code">GC-Code</label></th>';
        echo '<td><input type="text" id="gc_code" name="gc_code" value="' . esc_attr($gc_code) . '" /></td></tr>';
        
        echo '<tr><th><label for="latitude">Breitengrad</label></th>';
        echo '<td><input type="text" id="latitude" name="latitude" value="' . esc_attr($latitude) . '" /></td></tr>';
        
        echo '<tr><th><label for="longitude">Längengrad</label></th>';
        echo '<td><input type="text" id="longitude" name="longitude" value="' . esc_attr($longitude) . '" /></td></tr>';
        
        echo '<tr><th><label for="difficulty">Schwierigkeit</label></th>';
        echo '<td><select id="difficulty" name="difficulty">';
        for ($i = 1; $i <= 5; $i += 0.5) {
            echo '<option value="' . $i . '"' . selected($difficulty, $i, false) . '>' . $i . '</option>';
        }
        echo '</select></td></tr>';
        
        echo '<tr><th><label for="terrain">Gelände</label></th>';
        echo '<td><select id="terrain" name="terrain">';
        for ($i = 1; $i <= 5; $i += 0.5) {
            echo '<option value="' . $i . '"' . selected($terrain, $i, false) . '>' . $i . '</option>';
        }
        echo '</select></td></tr>';
        
        echo '<tr><th><label for="cache_owner">Owner</label></th>';
        echo '<td><input type="text" id="cache_owner" name="cache_owner" value="' . esc_attr($cache_owner) . '" /></td></tr>';
        
        echo '<tr><th><label for="cache_size">Größe</label></th>';
        echo '<td><select id="cache_size" name="cache_size">';
        $sizes = array('Micro', 'Small', 'Regular', 'Large', 'Other');
        foreach ($sizes as $size) {
            echo '<option value="' . $size . '"' . selected($cache_size, $size, false) . '>' . $size . '</option>';
        }
        echo '</select></td></tr>';
        echo '</table>';
    }

    public function app_cache_meta_box($post) {
        wp_nonce_field('app_cache_meta_nonce', 'app_cache_meta_nonce');
        
        $app_code = get_post_meta($post->ID, 'app_code', true);
        $latitude = get_post_meta($post->ID, 'latitude', true);
        $longitude = get_post_meta($post->ID, 'longitude', true);
        $difficulty = get_post_meta($post->ID, 'difficulty', true);
        $terrain = get_post_meta($post->ID, 'terrain', true);
        $hint = get_post_meta($post->ID, 'hint', true);
        
        echo '<table class="form-table">';
        echo '<tr><th><label for="app_code">App-Code</label></th>';
        echo '<td><input type="text" id="app_code" name="app_code" value="' . esc_attr($app_code) . '" /></td></tr>';
        
        echo '<tr><th><label for="latitude">Breitengrad</label></th>';
        echo '<td><input type="text" id="latitude" name="latitude" value="' . esc_attr($latitude) . '" /></td></tr>';
        
        echo '<tr><th><label for="longitude">Längengrad</label></th>';
        echo '<td><input type="text" id="longitude" name="longitude" value="' . esc_attr($longitude) . '" /></td></tr>';
        
        echo '<tr><th><label for="difficulty">Schwierigkeit</label></th>';
        echo '<td><select id="difficulty" name="difficulty">';
        for ($i = 1; $i <= 5; $i += 0.5) {
            echo '<option value="' . $i . '"' . selected($difficulty, $i, false) . '>' . $i . '</option>';
        }
        echo '</select></td></tr>';
        
        echo '<tr><th><label for="terrain">Gelände</label></th>';
        echo '<td><select id="terrain" name="terrain">';
        for ($i = 1; $i <= 5; $i += 0.5) {
            echo '<option value="' . $i . '"' . selected($terrain, $i, false) . '>' . $i . '</option>';
        }
        echo '</select></td></tr>';
        
        echo '<tr><th><label for="hint">Hinweis</label></th>';
        echo '<td><textarea id="hint" name="hint" rows="3" cols="50">' . esc_textarea($hint) . '</textarea></td></tr>';
        echo '</table>';
    }

    public function report_meta_box($post) {
        wp_nonce_field('report_meta_nonce', 'report_meta_nonce');
        
        $priority = get_post_meta($post->ID, 'report_priority', true);
        $status = get_post_meta($post->ID, 'report_status', true);
        $latitude = get_post_meta($post->ID, 'latitude', true);
        $longitude = get_post_meta($post->ID, 'longitude', true);
        $contact_email = get_post_meta($post->ID, 'contact_email', true);
        
        echo '<table class="form-table">';
        echo '<tr><th><label for="report_priority">Priorität</label></th>';
        echo '<td><select id="report_priority" name="report_priority">';
        $priorities = array('low' => 'Niedrig', 'normal' => 'Normal', 'high' => 'Hoch', 'urgent' => 'Dringend');
        foreach ($priorities as $value => $label) {
            echo '<option value="' . $value . '"' . selected($priority, $value, false) . '>' . $label . '</option>';
        }
        echo '</select></td></tr>';
        
        echo '<tr><th><label for="report_status">Status</label></th>';
        echo '<td><select id="report_status" name="report_status">';
        $statuses = array('open' => 'Offen', 'in_progress' => 'In Bearbeitung', 'resolved' => 'Gelöst', 'closed' => 'Geschlossen');
        foreach ($statuses as $value => $label) {
            echo '<option value="' . $value . '"' . selected($status, $value, false) . '>' . $label . '</option>';
        }
        echo '</select></td></tr>';
        
        echo '<tr><th><label for="latitude">Breitengrad</label></th>';
        echo '<td><input type="text" id="latitude" name="latitude" value="' . esc_attr($latitude) . '" /></td></tr>';
        
        echo '<tr><th><label for="longitude">Längengrad</label></th>';
        echo '<td><input type="text" id="longitude" name="longitude" value="' . esc_attr($longitude) . '" /></td></tr>';
        
        echo '<tr><th><label for="contact_email">Kontakt E-Mail</label></th>';
        echo '<td><input type="email" id="contact_email" name="contact_email" value="' . esc_attr($contact_email) . '" /></td></tr>';
        echo '</table>';
    }

    public function event_meta_box($post) {
        wp_nonce_field('event_meta_nonce', 'event_meta_nonce');
        
        $event_date = get_post_meta($post->ID, 'event_date', true);
        $event_time = get_post_meta($post->ID, 'event_time', true);
        $location = get_post_meta($post->ID, 'location', true);
        $max_participants = get_post_meta($post->ID, 'max_participants', true);
        $registration_required = get_post_meta($post->ID, 'registration_required', true);
        
        echo '<table class="form-table">';
        echo '<tr><th><label for="event_date">Datum</label></th>';
        echo '<td><input type="date" id="event_date" name="event_date" value="' . esc_attr($event_date) . '" /></td></tr>';
        
        echo '<tr><th><label for="event_time">Uhrzeit</label></th>';
        echo '<td><input type="time" id="event_time" name="event_time" value="' . esc_attr($event_time) . '" /></td></tr>';
        
        echo '<tr><th><label for="location">Ort</label></th>';
        echo '<td><input type="text" id="location" name="location" value="' . esc_attr($location) . '" /></td></tr>';
        
        echo '<tr><th><label for="max_participants">Max. Teilnehmer</label></th>';
        echo '<td><input type="number" id="max_participants" name="max_participants" value="' . esc_attr($max_participants) . '" min="1" /></td></tr>';
        
        echo '<tr><th><label for="registration_required">Anmeldung erforderlich</label></th>';
        echo '<td><input type="checkbox" id="registration_required" name="registration_required" value="1"' . checked($registration_required, 1, false) . ' /></td></tr>';
        echo '</table>';
    }

    public function save_meta_boxes($post_id) {
        // Check nonces and permissions
        if (get_post_type($post_id) === 'geocache' && isset($_POST['geocache_meta_nonce'])) {
            if (!wp_verify_nonce($_POST['geocache_meta_nonce'], 'geocache_meta_nonce')) return;
            if (!current_user_can('edit_post', $post_id)) return;
            
            $fields = array('gc_code', 'latitude', 'longitude', 'difficulty', 'terrain', 'cache_owner', 'cache_size');
            foreach ($fields as $field) {
                if (isset($_POST[$field])) {
                    update_post_meta($post_id, $field, sanitize_text_field($_POST[$field]));
                }
            }
        }

        if (get_post_type($post_id) === 'app_cache' && isset($_POST['app_cache_meta_nonce'])) {
            if (!wp_verify_nonce($_POST['app_cache_meta_nonce'], 'app_cache_meta_nonce')) return;
            if (!current_user_can('edit_post', $post_id)) return;
            
            $fields = array('app_code', 'latitude', 'longitude', 'difficulty', 'terrain', 'hint');
            foreach ($fields as $field) {
                if (isset($_POST[$field])) {
                    if ($field === 'hint') {
                        update_post_meta($post_id, $field, sanitize_textarea_field($_POST[$field]));
                    } else {
                        update_post_meta($post_id, $field, sanitize_text_field($_POST[$field]));
                    }
                }
            }
        }

        if (get_post_type($post_id) === 'aukrug_report' && isset($_POST['report_meta_nonce'])) {
            if (!wp_verify_nonce($_POST['report_meta_nonce'], 'report_meta_nonce')) return;
            if (!current_user_can('edit_post', $post_id)) return;
            
            $fields = array('report_priority', 'report_status', 'latitude', 'longitude', 'contact_email');
            foreach ($fields as $field) {
                if (isset($_POST[$field])) {
                    update_post_meta($post_id, $field, sanitize_text_field($_POST[$field]));
                }
            }
        }

        if (get_post_type($post_id) === 'aukrug_event' && isset($_POST['event_meta_nonce'])) {
            if (!wp_verify_nonce($_POST['event_meta_nonce'], 'event_meta_nonce')) return;
            if (!current_user_can('edit_post', $post_id)) return;
            
            $fields = array('event_date', 'event_time', 'location', 'max_participants');
            foreach ($fields as $field) {
                if (isset($_POST[$field])) {
                    update_post_meta($post_id, $field, sanitize_text_field($_POST[$field]));
                }
            }
            
            if (isset($_POST['registration_required'])) {
                update_post_meta($post_id, 'registration_required', 1);
            } else {
                delete_post_meta($post_id, 'registration_required');
            }
        }
    }
}
