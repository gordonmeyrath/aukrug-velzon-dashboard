<?php
/**
 * Public Report Viewing and Submission
 * Allows citizens to view reports and add comments
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class Aukrug_Public_Reports {
    
    public function __construct() {
        add_action('init', array($this, 'init'));
    }

    public function init() {
        // Add public endpoints
        add_action('wp_loaded', array($this, 'setup_public_endpoints'));
        
        // Handle form submissions
        add_action('wp_ajax_nopriv_aukrug_submit_report', array($this, 'handle_public_report_submission'));
        add_action('wp_ajax_nopriv_aukrug_add_comment', array($this, 'handle_public_comment'));
        
        // Add shortcodes
        add_shortcode('aukrug_report_form', array($this, 'render_report_form'));
        add_shortcode('aukrug_report_view', array($this, 'render_report_view'));
        add_shortcode('aukrug_reports_list', array($this, 'render_reports_list'));
    }

    public function setup_public_endpoints() {
        // Add rewrite rules for public report viewing
        add_rewrite_rule(
            '^meldung/([0-9]+)/?',
            'index.php?aukrug_report_id=$matches[1]',
            'top'
        );
        
        add_rewrite_tag('%aukrug_report_id%', '([^&]+)');
        
        // Add custom query var handler
        add_action('template_redirect', array($this, 'handle_report_view'));
    }

    public function handle_report_view() {
        $report_id = get_query_var('aukrug_report_id');
        
        if ($report_id) {
            $this->display_public_report($report_id);
            exit;
        }
    }

    public function display_public_report($report_id) {
        $report = get_post($report_id);
        
        if (!$report || $report->post_type !== 'aukrug_report') {
            wp_die('Meldung nicht gefunden', 'Fehler 404', array('response' => 404));
        }

        // Get report meta
        $status = get_post_meta($report_id, 'report_status', true) ?: 'open';
        $category = get_post_meta($report_id, 'report_category', true);
        $priority = get_post_meta($report_id, 'report_priority', true);
        $address = get_post_meta($report_id, 'report_address', true);

        // Get public comments
        global $wpdb;
        $comments_table = $wpdb->prefix . 'aukrug_report_comments';
        $comments = $wpdb->get_results($wpdb->prepare(
            "SELECT * FROM $comments_table WHERE report_id = %d AND visibility = 'public' ORDER BY created_at ASC",
            $report_id
        ));

        // Render public page
        $this->include_template('header');
        ?>
        <div class="aukrug-public-report">
            <div class="container">
                <div class="report-header">
                    <h1>Meldung #<?php echo $report_id; ?>: <?php echo esc_html($report->post_title); ?></h1>
                    <div class="report-meta">
                        <span class="status status-<?php echo esc_attr($status); ?>">
                            <?php echo $this->get_status_label($status); ?>
                        </span>
                        <span class="category">
                            <?php echo $this->get_category_label($category); ?>
                        </span>
                        <?php if ($address): ?>
                            <span class="address">📍 <?php echo esc_html($address); ?></span>
                        <?php endif; ?>
                    </div>
                </div>

                <div class="report-content">
                    <div class="report-description">
                        <h3>Beschreibung</h3>
                        <p><?php echo wp_kses_post($report->post_content); ?></p>
                    </div>

                    <div class="report-progress">
                        <h3>Bearbeitungsstatus</h3>
                        <div class="progress-steps">
                            <div class="step <?php echo $status === 'open' ? 'active' : ($status !== 'open' ? 'completed' : ''); ?>">
                                <span class="step-number">1</span>
                                <span class="step-label">Eingegangen</span>
                            </div>
                            <div class="step <?php echo $status === 'in_progress' ? 'active' : (in_array($status, ['resolved', 'closed']) ? 'completed' : ''); ?>">
                                <span class="step-number">2</span>
                                <span class="step-label">In Bearbeitung</span>
                            </div>
                            <div class="step <?php echo $status === 'resolved' ? 'active' : ($status === 'closed' ? 'completed' : ''); ?>">
                                <span class="step-number">3</span>
                                <span class="step-label">Gelöst</span>
                            </div>
                            <div class="step <?php echo $status === 'closed' ? 'active' : ''; ?>">
                                <span class="step-number">4</span>
                                <span class="step-label">Abgeschlossen</span>
                            </div>
                        </div>
                    </div>

                    <?php if ($comments): ?>
                        <div class="report-comments">
                            <h3>Verlauf & Rückfragen</h3>
                            <?php foreach ($comments as $comment): ?>
                                <div class="comment <?php echo $comment->author_role === 'admin' ? 'admin-comment' : 'user-comment'; ?>">
                                    <div class="comment-header">
                                        <strong><?php echo esc_html($comment->author_name ?: 'Anonym'); ?></strong>
                                        <span class="comment-role">
                                            <?php echo $comment->author_role === 'admin' ? '(Gemeindeverwaltung)' : '(Bürger)'; ?>
                                        </span>
                                        <time><?php echo date('d.m.Y H:i', strtotime($comment->created_at)); ?></time>
                                    </div>
                                    <div class="comment-content">
                                        <?php echo wp_kses_post($comment->message); ?>
                                    </div>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    <?php endif; ?>

                    <?php if (in_array($status, ['open', 'in_progress'])): ?>
                        <div class="add-comment">
                            <h3>Rückfrage oder zusätzliche Information</h3>
                            <form id="public-comment-form" method="post">
                                <?php wp_nonce_field('aukrug_public_comment', 'nonce'); ?>
                                <input type="hidden" name="report_id" value="<?php echo $report_id; ?>">
                                
                                <div class="form-row">
                                    <label for="author_name">Ihr Name:</label>
                                    <input type="text" name="author_name" id="author_name" required>
                                </div>
                                
                                <div class="form-row">
                                    <label for="author_email">E-Mail (für Rückmeldungen):</label>
                                    <input type="email" name="author_email" id="author_email" required>
                                </div>
                                
                                <div class="form-row">
                                    <label for="message">Ihre Nachricht:</label>
                                    <textarea name="message" id="message" rows="4" required placeholder="Zusätzliche Informationen, Fragen oder Updates zu Ihrer Meldung..."></textarea>
                                </div>
                                
                                <button type="submit" class="submit-btn">Nachricht senden</button>
                            </form>
                        </div>
                    <?php endif; ?>
                </div>
            </div>
        </div>

        <style>
        .aukrug-public-report {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        .report-header h1 {
            color: #1e40af;
            margin-bottom: 16px;
        }
        
        .report-meta {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-bottom: 24px;
        }
        
        .status, .category {
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-open { background: #fef3c7; color: #92400e; }
        .status-in_progress { background: #dbeafe; color: #1e40af; }
        .status-resolved { background: #d1fae5; color: #065f46; }
        .status-closed { background: #e5e7eb; color: #374151; }
        
        .category {
            background: #f3e8ff;
            color: #7c3aed;
        }
        
        .address {
            font-size: 14px;
            color: #6b7280;
        }
        
        .report-content > div {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .progress-steps {
            display: flex;
            justify-content: space-between;
            margin-top: 16px;
        }
        
        .step {
            text-align: center;
            opacity: 0.5;
        }
        
        .step.active, .step.completed {
            opacity: 1;
        }
        
        .step-number {
            display: block;
            width: 32px;
            height: 32px;
            line-height: 32px;
            border-radius: 50%;
            background: #e5e7eb;
            color: #6b7280;
            margin: 0 auto 8px;
        }
        
        .step.active .step-number {
            background: #3b82f6;
            color: white;
        }
        
        .step.completed .step-number {
            background: #10b981;
            color: white;
        }
        
        .comment {
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 12px;
        }
        
        .admin-comment {
            border-left: 4px solid #3b82f6;
            background: #f8fafc;
        }
        
        .comment-header {
            display: flex;
            gap: 8px;
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        .comment-role {
            color: #6b7280;
        }
        
        .comment-header time {
            color: #9ca3af;
            margin-left: auto;
        }
        
        .form-row {
            margin-bottom: 16px;
        }
        
        .form-row label {
            display: block;
            margin-bottom: 4px;
            font-weight: 500;
        }
        
        .form-row input, .form-row textarea {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .submit-btn {
            background: #3b82f6;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
        }
        
        .submit-btn:hover {
            background: #2563eb;
        }
        </style>

        <script>
        document.getElementById('public-comment-form').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            formData.append('action', 'aukrug_add_comment');
            
            try {
                const response = await fetch('<?php echo admin_url('admin-ajax.php'); ?>', {
                    method: 'POST',
                    body: formData
                });
                
                const result = await response.json();
                
                if (result.success) {
                    alert('Ihre Nachricht wurde gesendet. Sie erhalten eine Bestätigung per E-Mail.');
                    location.reload();
                } else {
                    alert('Fehler beim Senden: ' + (result.data || 'Unbekannter Fehler'));
                }
            } catch (error) {
                alert('Verbindungsfehler. Bitte versuchen Sie es später erneut.');
            }
        });
        </script>

        <?php
        $this->include_template('footer');
    }

    public function handle_public_comment() {
        // Verify nonce
        if (!wp_verify_nonce($_POST['nonce'], 'aukrug_public_comment')) {
            wp_die('Sicherheitsfehler');
        }

        $report_id = intval($_POST['report_id']);
        $author_name = sanitize_text_field($_POST['author_name']);
        $author_email = sanitize_email($_POST['author_email']);
        $message = wp_kses_post($_POST['message']);

        if (!$report_id || !$author_name || !$author_email || !$message) {
            wp_send_json_error('Alle Felder sind erforderlich');
        }

        // Simple rate limiting
        $ip = $_SERVER['REMOTE_ADDR'];
        $rate_key = 'aukrug_comment_rate_' . md5($ip);
        $recent_comments = get_transient($rate_key) ?: 0;
        
        if ($recent_comments >= 5) {
            wp_send_json_error('Zu viele Kommentare. Bitte warten Sie.');
        }

        // Add comment to database
        global $wpdb;
        $table = $wpdb->prefix . 'aukrug_report_comments';
        
        $result = $wpdb->insert($table, array(
            'report_id' => $report_id,
            'author_name' => $author_name,
            'author_email' => $author_email,
            'author_role' => 'anonymous',
            'visibility' => 'public',
            'message' => $message,
            'created_at' => current_time('mysql')
        ));

        if ($result) {
            // Update rate limiting
            set_transient($rate_key, $recent_comments + 1, 300); // 5 minutes
            
            // Log activity
            $activity_table = $wpdb->prefix . 'aukrug_report_activity';
            $wpdb->insert($activity_table, array(
                'report_id' => $report_id,
                'action' => 'public_comment',
                'actor_role' => 'anonymous',
                'meta' => wp_json_encode(array('author' => $author_name)),
                'created_at' => current_time('mysql')
            ));

            // Trigger notification
            if (class_exists('Aukrug_Notifications')) {
                $comment_data = array(
                    'author_name' => $author_name,
                    'message' => $message,
                    'visibility' => 'public'
                );
                Aukrug_Notifications::trigger_comment_added($report_id, $comment_data, false);
            }

            wp_send_json_success('Kommentar hinzugefügt');
        } else {
            wp_send_json_error('Datenbankfehler');
        }
    }

    /**
     * Shortcode for report submission form
     */
    public function render_report_form($atts) {
        $atts = shortcode_atts(array(
            'categories' => 'all',
            'redirect' => ''
        ), $atts);

        ob_start();
        ?>
        <div class="aukrug-report-form">
            <form id="aukrug-public-report-form" method="post">
                <?php wp_nonce_field('aukrug_public_report', 'nonce'); ?>
                
                <div class="form-section">
                    <h3>Was möchten Sie melden?</h3>
                    
                    <div class="form-row">
                        <label for="report_title">Kurze Beschreibung:</label>
                        <input type="text" name="title" id="report_title" required placeholder="z.B. Schlagloch in der Hauptstraße">
                    </div>
                    
                    <div class="form-row">
                        <label for="report_category">Kategorie:</label>
                        <select name="category" id="report_category" required>
                            <option value="">Bitte wählen...</option>
                            <option value="strasse">Straße & Verkehr</option>
                            <option value="beleuchtung">Beleuchtung</option>
                            <option value="abfall">Abfall & Entsorgung</option>
                            <option value="vandalismus">Vandalismus</option>
                            <option value="gruenflaeche">Grünflächen & Parks</option>
                            <option value="wasser">Wasser & Abwasser</option>
                            <option value="laerm">Lärm & Ruhestörung</option>
                            <option value="spielplatz">Spielplätze</option>
                            <option value="umwelt">Umwelt & Natur</option>
                            <option value="winterdienst">Winterdienst</option>
                            <option value="gebaeude">Öffentliche Gebäude</option>
                            <option value="sonstiges">Sonstiges</option>
                        </select>
                    </div>
                    
                    <div class="form-row">
                        <label for="report_description">Detaillierte Beschreibung:</label>
                        <textarea name="description" id="report_description" rows="4" required placeholder="Beschreiben Sie das Problem möglichst genau..."></textarea>
                    </div>
                </div>

                <div class="form-section">
                    <h3>Wo ist das Problem?</h3>
                    
                    <div class="form-row">
                        <label for="report_address">Adresse oder Ort:</label>
                        <input type="text" name="address" id="report_address" placeholder="z.B. Hauptstraße 15, Aukrug">
                    </div>
                </div>

                <div class="form-section">
                    <h3>Ihre Kontaktdaten (für Rückfragen)</h3>
                    
                    <div class="form-row">
                        <label for="contact_name">Ihr Name:</label>
                        <input type="text" name="contact_name" id="contact_name" required>
                    </div>
                    
                    <div class="form-row">
                        <label for="contact_email">E-Mail-Adresse:</label>
                        <input type="email" name="contact_email" id="contact_email" required>
                    </div>
                    
                    <p class="privacy-note">
                        <small>Ihre Kontaktdaten werden nur für die Bearbeitung Ihrer Meldung verwendet und nicht öffentlich angezeigt.</small>
                    </p>
                </div>

                <button type="submit" class="submit-btn">Meldung absenden</button>
            </form>
        </div>

        <style>
        .aukrug-report-form {
            max-width: 600px;
            margin: 0 auto;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        .form-section {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .form-section h3 {
            margin-top: 0;
            color: #1e40af;
        }
        
        .form-row {
            margin-bottom: 16px;
        }
        
        .form-row label {
            display: block;
            margin-bottom: 4px;
            font-weight: 500;
        }
        
        .form-row input, .form-row select, .form-row textarea {
            width: 100%;
            padding: 8px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .privacy-note {
            color: #6b7280;
            font-style: italic;
        }
        
        .submit-btn {
            background: #3b82f6;
            color: white;
            padding: 12px 24px;
            border: none;
            border-radius: 6px;
            font-weight: 500;
            cursor: pointer;
            font-size: 16px;
        }
        
        .submit-btn:hover {
            background: #2563eb;
        }
        </style>

        <script>
        document.getElementById('aukrug-public-report-form').addEventListener('submit', async function(e) {
            e.preventDefault();
            
            const formData = new FormData(this);
            formData.append('action', 'aukrug_submit_report');
            
            const submitBtn = this.querySelector('.submit-btn');
            submitBtn.disabled = true;
            submitBtn.textContent = 'Wird gesendet...';
            
            try {
                const response = await fetch('<?php echo admin_url('admin-ajax.php'); ?>', {
                    method: 'POST',
                    body: formData
                });
                
                const result = await response.json();
                
                if (result.success) {
                    alert('Vielen Dank! Ihre Meldung wurde erfolgreich übermittelt. Sie erhalten eine Bestätigung per E-Mail.');
                    this.reset();
                } else {
                    alert('Fehler beim Senden: ' + (result.data || 'Unbekannter Fehler'));
                }
            } catch (error) {
                alert('Verbindungsfehler. Bitte versuchen Sie es später erneut.');
            } finally {
                submitBtn.disabled = false;
                submitBtn.textContent = 'Meldung absenden';
            }
        });
        </script>
        <?php
        return ob_get_clean();
    }

    public function handle_public_report_submission() {
        // Verify nonce
        if (!wp_verify_nonce($_POST['nonce'], 'aukrug_public_report')) {
            wp_send_json_error('Sicherheitsfehler');
        }

        // Simple rate limiting
        $ip = $_SERVER['REMOTE_ADDR'];
        $rate_key = 'aukrug_report_rate_' . md5($ip);
        $recent_reports = get_transient($rate_key) ?: 0;
        
        if ($recent_reports >= 3) {
            wp_send_json_error('Zu viele Meldungen. Bitte warten Sie 5 Minuten.');
        }

        // Validate and sanitize input
        $title = sanitize_text_field($_POST['title']);
        $category = sanitize_text_field($_POST['category']);
        $description = wp_kses_post($_POST['description']);
        $address = sanitize_text_field($_POST['address']);
        $contact_name = sanitize_text_field($_POST['contact_name']);
        $contact_email = sanitize_email($_POST['contact_email']);

        if (!$title || !$category || !$description || !$contact_name || !$contact_email) {
            wp_send_json_error('Alle Pflichtfelder müssen ausgefüllt werden');
        }

        // Create report
        $post_data = array(
            'post_type' => 'aukrug_report',
            'post_title' => $title,
            'post_content' => $description,
            'post_status' => 'publish',
            'post_author' => 0 // Anonymous
        );

        $report_id = wp_insert_post($post_data);

        if (is_wp_error($report_id)) {
            wp_send_json_error('Fehler beim Speichern der Meldung');
        }

        // Add meta data
        update_post_meta($report_id, 'report_category', $category);
        update_post_meta($report_id, 'report_priority', 'normal');
        update_post_meta($report_id, 'report_status', 'open');
        update_post_meta($report_id, 'report_address', $address);
        update_post_meta($report_id, 'report_contact_name', $contact_name);
        update_post_meta($report_id, 'report_contact_email', $contact_email);
        update_post_meta($report_id, 'report_ip', $ip);

        // Update rate limiting
        set_transient($rate_key, $recent_reports + 1, 300); // 5 minutes

        // Log activity
        global $wpdb;
        $activity_table = $wpdb->prefix . 'aukrug_report_activity';
        $wpdb->insert($activity_table, array(
            'report_id' => $report_id,
            'action' => 'create',
            'actor_role' => 'anonymous',
            'meta' => wp_json_encode(array('ip' => $ip)),
            'created_at' => current_time('mysql')
        ));

        // Trigger notification
        if (class_exists('Aukrug_Notifications')) {
            Aukrug_Notifications::trigger_report_created($report_id, array(
                'title' => $title,
                'description' => $description,
                'category' => $category,
                'priority' => 'normal',
                'address' => $address
            ));
        }

        wp_send_json_success(array(
            'report_id' => $report_id,
            'message' => 'Meldung erfolgreich erstellt',
            'view_url' => home_url('/meldung/' . $report_id)
        ));
    }

    /**
     * Shortcode for reports list
     */
    public function render_reports_list($atts) {
        $atts = shortcode_atts(array(
            'limit' => 10,
            'status' => 'all',
            'category' => 'all'
        ), $atts);

        // Get reports
        $args = array(
            'post_type' => 'aukrug_report',
            'post_status' => 'publish',
            'posts_per_page' => intval($atts['limit']),
            'orderby' => 'date',
            'order' => 'DESC'
        );

        if ($atts['status'] !== 'all') {
            $args['meta_query'] = array(
                array(
                    'key' => 'report_status',
                    'value' => $atts['status']
                )
            );
        }

        if ($atts['category'] !== 'all') {
            if (!isset($args['meta_query'])) {
                $args['meta_query'] = array();
            }
            $args['meta_query'][] = array(
                'key' => 'report_category',
                'value' => $atts['category']
            );
        }

        $reports = get_posts($args);

        ob_start();
        ?>
        <div class="aukrug-reports-list">
            <div class="reports-header">
                <h3>Aktuelle Meldungen</h3>
                <div class="filters">
                    <select id="status-filter" onchange="filterReports()">
                        <option value="all">Alle Status</option>
                        <option value="open">Eingegangen</option>
                        <option value="in_progress">In Bearbeitung</option>
                        <option value="resolved">Gelöst</option>
                        <option value="closed">Abgeschlossen</option>
                    </select>
                    <select id="category-filter" onchange="filterReports()">
                        <option value="all">Alle Kategorien</option>
                        <option value="strasse">Straße & Verkehr</option>
                        <option value="beleuchtung">Beleuchtung</option>
                        <option value="abfall">Abfall & Entsorgung</option>
                        <option value="vandalismus">Vandalismus</option>
                        <option value="gruenflaeche">Grünflächen & Parks</option>
                        <option value="wasser">Wasser & Abwasser</option>
                    </select>
                </div>
            </div>

            <div class="reports-grid">
                <?php if ($reports): ?>
                    <?php foreach ($reports as $report): ?>
                        <?php
                        $status = get_post_meta($report->ID, 'report_status', true) ?: 'open';
                        $category = get_post_meta($report->ID, 'report_category', true);
                        $address = get_post_meta($report->ID, 'report_address', true);
                        ?>
                        <div class="report-card" data-status="<?php echo esc_attr($status); ?>" data-category="<?php echo esc_attr($category); ?>">
                            <div class="report-header">
                                <h4>
                                    <a href="/meldung/<?php echo $report->ID; ?>">
                                        #<?php echo $report->ID; ?>: <?php echo esc_html($report->post_title); ?>
                                    </a>
                                </h4>
                                <div class="report-meta">
                                    <span class="status status-<?php echo esc_attr($status); ?>">
                                        <?php echo $this->get_status_label($status); ?>
                                    </span>
                                    <span class="category">
                                        <?php echo $this->get_category_label($category); ?>
                                    </span>
                                </div>
                            </div>

                            <div class="report-content">
                                <p><?php echo wp_trim_words($report->post_content, 20); ?></p>
                                <?php if ($address): ?>
                                    <div class="report-location">
                                        📍 <?php echo esc_html($address); ?>
                                    </div>
                                <?php endif; ?>
                            </div>

                            <div class="report-footer">
                                <span class="report-date">
                                    <?php echo date('d.m.Y', strtotime($report->post_date)); ?>
                                </span>
                                <a href="/meldung/<?php echo $report->ID; ?>" class="view-link">
                                    Details anzeigen
                                </a>
                            </div>
                        </div>
                    <?php endforeach; ?>
                <?php else: ?>
                    <div class="no-reports">
                        <p>Keine Meldungen gefunden.</p>
                    </div>
                <?php endif; ?>
            </div>
        </div>

        <style>
        .aukrug-reports-list {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
        }
        
        .reports-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
            flex-wrap: wrap;
            gap: 1rem;
        }
        
        .reports-header h3 {
            color: #1e40af;
            margin: 0;
        }
        
        .filters {
            display: flex;
            gap: 1rem;
        }
        
        .filters select {
            padding: 8px 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .reports-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 1.5rem;
        }
        
        .report-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 12px;
            padding: 1.5rem;
            transition: all 0.2s;
        }
        
        .report-card:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
            transform: translateY(-2px);
        }
        
        .report-header {
            margin-bottom: 1rem;
        }
        
        .report-header h4 {
            margin: 0 0 0.5rem 0;
            font-size: 1.1rem;
        }
        
        .report-header h4 a {
            color: #1e40af;
            text-decoration: none;
        }
        
        .report-header h4 a:hover {
            text-decoration: underline;
        }
        
        .report-meta {
            display: flex;
            gap: 0.5rem;
            flex-wrap: wrap;
        }
        
        .status, .category {
            padding: 2px 8px;
            border-radius: 12px;
            font-size: 11px;
            font-weight: 600;
            text-transform: uppercase;
        }
        
        .status-open { background: #fef3c7; color: #92400e; }
        .status-in_progress { background: #dbeafe; color: #1e40af; }
        .status-resolved { background: #d1fae5; color: #065f46; }
        .status-closed { background: #e5e7eb; color: #374151; }
        
        .category {
            background: #f3e8ff;
            color: #7c3aed;
        }
        
        .report-content p {
            color: #6b7280;
            margin-bottom: 0.5rem;
            line-height: 1.5;
        }
        
        .report-location {
            font-size: 0.85rem;
            color: #9ca3af;
            margin-top: 0.5rem;
        }
        
        .report-footer {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 1rem;
            padding-top: 1rem;
            border-top: 1px solid #f3f4f6;
        }
        
        .report-date {
            font-size: 0.85rem;
            color: #9ca3af;
        }
        
        .view-link {
            color: #3b82f6;
            text-decoration: none;
            font-size: 0.9rem;
            font-weight: 500;
        }
        
        .view-link:hover {
            text-decoration: underline;
        }
        
        .no-reports {
            grid-column: 1 / -1;
            text-align: center;
            padding: 3rem;
            color: #6b7280;
        }
        
        @media (max-width: 768px) {
            .reports-grid {
                grid-template-columns: 1fr;
            }
            
            .filters {
                flex-direction: column;
                width: 100%;
            }
            
            .filters select {
                width: 100%;
            }
        }
        </style>

        <script>
        function filterReports() {
            const statusFilter = document.getElementById('status-filter').value;
            const categoryFilter = document.getElementById('category-filter').value;
            const cards = document.querySelectorAll('.report-card');
            
            cards.forEach(card => {
                const cardStatus = card.dataset.status;
                const cardCategory = card.dataset.category;
                
                const statusMatch = statusFilter === 'all' || cardStatus === statusFilter;
                const categoryMatch = categoryFilter === 'all' || cardCategory === categoryFilter;
                
                if (statusMatch && categoryMatch) {
                    card.style.display = 'block';
                } else {
                    card.style.display = 'none';
                }
            });
        }
        </script>
        <?php
        return ob_get_clean();
    }

    private function get_category_label($category) {
        $labels = array(
            'strasse' => 'Straße & Verkehr',
            'beleuchtung' => 'Beleuchtung',
            'abfall' => 'Abfall & Entsorgung',
            'vandalismus' => 'Vandalismus',
            'gruenflaeche' => 'Grünflächen & Parks',
            'wasser' => 'Wasser & Abwasser',
            'laerm' => 'Lärm & Ruhestörung',
            'spielplatz' => 'Spielplätze',
            'umwelt' => 'Umwelt & Natur',
            'winterdienst' => 'Winterdienst',
            'gebaeude' => 'Öffentliche Gebäude',
            'sonstiges' => 'Sonstiges'
        );
        return $labels[$category] ?? 'Sonstiges';
    }

    private function get_status_label($status) {
        $labels = array(
            'open' => 'Eingegangen',
            'in_progress' => 'In Bearbeitung',
            'resolved' => 'Gelöst',
            'closed' => 'Abgeschlossen'
        );
        return $labels[$status] ?? 'Eingegangen';
    }

    private function include_template($template) {
        $template_path = plugin_dir_path(__FILE__) . '../templates/' . $template . '.php';
        if (file_exists($template_path)) {
            include $template_path;
        } else {
            // Fallback to WordPress templates
            if ($template === 'header') {
                echo '<!DOCTYPE html><html><head><meta charset="utf-8"><title>Meldungen</title></head><body>';
            } else {
                echo '</body></html>';
            }
        }
    }
}

new Aukrug_Public_Reports();
