<?php
/**
 * Aukrug Notifications System
 * Handles email notifications and communication for reports system
 */

// Prevent direct access
if (!defined('ABSPATH')) {
    exit;
}

class Aukrug_Notifications {
    
    public function __construct() {
        add_action('init', array($this, 'init'));
    }

    public function init() {
        // Hook into report activities for notifications
        add_action('aukrug_report_created', array($this, 'notify_new_report'), 10, 2);
        add_action('aukrug_report_status_changed', array($this, 'notify_status_change'), 10, 3);
        add_action('aukrug_report_comment_added', array($this, 'notify_new_comment'), 10, 3);
        add_action('aukrug_report_assigned', array($this, 'notify_assignment'), 10, 3);
        
        // Custom email templates
        add_filter('wp_mail_content_type', array($this, 'set_html_content_type'));
    }

    /**
     * Notify admins about new report
     */
    public function notify_new_report($report_id, $report_data) {
        $admin_emails = $this->get_admin_emails();
        if (empty($admin_emails)) return;

        $subject = sprintf('[Aukrug] Neue Meldung #%d: %s', $report_id, $report_data['title']);
        
        $message = $this->get_email_template('new_report', array(
            'report_id' => $report_id,
            'title' => $report_data['title'],
            'description' => $report_data['description'],
            'category' => $this->get_category_label($report_data['category']),
            'priority' => $this->get_priority_label($report_data['priority']),
            'address' => $report_data['address'] ?? '',
            'admin_url' => admin_url('admin.php?page=aukrug-dashboard&tab=reports&report=' . $report_id)
        ));

        foreach ($admin_emails as $email) {
            wp_mail($email, $subject, $message);
        }

        // Log notification
        $this->log_notification('admin_new_report', $report_id, array('emails' => count($admin_emails)));
    }

    /**
     * Notify reporter about status change
     */
    public function notify_status_change($report_id, $old_status, $new_status) {
        $report = get_post($report_id);
        if (!$report) return;

        $contact_email = get_post_meta($report_id, 'report_contact_email', true);
        if (!$contact_email || !is_email($contact_email)) return;

        $contact_name = get_post_meta($report_id, 'report_contact_name', true) ?: 'Sehr geehrte Damen und Herren';

        $subject = sprintf('[Aukrug] Status-Update für Ihre Meldung #%d', $report_id);
        
        $message = $this->get_email_template('status_change', array(
            'contact_name' => $contact_name,
            'report_id' => $report_id,
            'title' => $report->post_title,
            'old_status' => $this->get_status_label($old_status),
            'new_status' => $this->get_status_label($new_status),
            'status_description' => $this->get_status_description($new_status),
            'view_url' => $this->get_public_report_url($report_id)
        ));

        wp_mail($contact_email, $subject, $message);

        // Log notification
        $this->log_notification('reporter_status_change', $report_id, array(
            'email' => $contact_email,
            'old_status' => $old_status,
            'new_status' => $new_status
        ));
    }

    /**
     * Notify about new comment
     */
    public function notify_new_comment($report_id, $comment_data, $is_admin_comment) {
        $report = get_post($report_id);
        if (!$report) return;

        // Only notify for public comments
        if ($comment_data['visibility'] !== 'public') return;

        if ($is_admin_comment) {
            // Admin commented - notify reporter
            $this->notify_reporter_new_comment($report_id, $comment_data);
        } else {
            // Reporter commented - notify admins
            $this->notify_admins_new_comment($report_id, $comment_data);
        }
    }

    private function notify_reporter_new_comment($report_id, $comment_data) {
        $contact_email = get_post_meta($report_id, 'report_contact_email', true);
        if (!$contact_email || !is_email($contact_email)) return;

        $contact_name = get_post_meta($report_id, 'report_contact_name', true) ?: 'Sehr geehrte Damen und Herren';
        $report = get_post($report_id);

        $subject = sprintf('[Aukrug] Neue Antwort zu Ihrer Meldung #%d', $report_id);
        
        $message = $this->get_email_template('admin_comment', array(
            'contact_name' => $contact_name,
            'report_id' => $report_id,
            'title' => $report->post_title,
            'comment_author' => $comment_data['author_name'],
            'comment_message' => $comment_data['message'],
            'view_url' => $this->get_public_report_url($report_id)
        ));

        wp_mail($contact_email, $subject, $message);
    }

    private function notify_admins_new_comment($report_id, $comment_data) {
        $admin_emails = $this->get_admin_emails();
        if (empty($admin_emails)) return;

        $report = get_post($report_id);
        $subject = sprintf('[Aukrug] Neue Rückfrage zu Meldung #%d', $report_id);
        
        $message = $this->get_email_template('reporter_comment', array(
            'report_id' => $report_id,
            'title' => $report->post_title,
            'comment_author' => $comment_data['author_name'],
            'comment_message' => $comment_data['message'],
            'admin_url' => admin_url('admin.php?page=aukrug-dashboard&tab=reports&report=' . $report_id)
        ));

        foreach ($admin_emails as $email) {
            wp_mail($email, $subject, $message);
        }
    }

    /**
     * Notify about assignment
     */
    public function notify_assignment($report_id, $user_id, $assigner_id) {
        $user = get_user_by('id', $user_id);
        if (!$user || !$user->user_email) return;

        $report = get_post($report_id);
        $assigner = get_user_by('id', $assigner_id);

        $subject = sprintf('[Aukrug] Meldung #%d wurde Ihnen zugewiesen', $report_id);
        
        $message = $this->get_email_template('assignment', array(
            'user_name' => $user->display_name,
            'report_id' => $report_id,
            'title' => $report->post_title,
            'category' => $this->get_category_label(get_post_meta($report_id, 'report_category', true)),
            'priority' => $this->get_priority_label(get_post_meta($report_id, 'report_priority', true)),
            'assigner_name' => $assigner ? $assigner->display_name : 'System',
            'admin_url' => admin_url('admin.php?page=aukrug-dashboard&tab=reports&report=' . $report_id)
        ));

        wp_mail($user->user_email, $subject, $message);

        // Log notification
        $this->log_notification('assignment', $report_id, array(
            'user_id' => $user_id,
            'assigner_id' => $assigner_id
        ));
    }

    /**
     * Get email templates
     */
    private function get_email_template($template, $variables) {
        $templates = array(
            'new_report' => '
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <div style="background: #f8fafc; padding: 20px; border-radius: 8px;">
                        <h2 style="color: #1e40af; margin-top: 0;">Neue Meldung eingegangen</h2>
                        
                        <div style="background: white; padding: 20px; border-radius: 6px; margin: 16px 0;">
                            <h3 style="margin-top: 0;">Meldung #{report_id}</h3>
                            <p><strong>Titel:</strong> {title}</p>
                            <p><strong>Kategorie:</strong> {category}</p>
                            <p><strong>Priorität:</strong> {priority}</p>
                            {address_block}
                            <p><strong>Beschreibung:</strong></p>
                            <div style="background: #f3f4f6; padding: 12px; border-radius: 4px;">
                                {description}
                            </div>
                        </div>
                        
                        <div style="text-align: center; margin: 24px 0;">
                            <a href="{admin_url}" style="background: #3b82f6; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; display: inline-block;">
                                Meldung bearbeiten
                            </a>
                        </div>
                        
                        <p style="color: #6b7280; font-size: 12px; margin-bottom: 0;">
                            Diese E-Mail wurde automatisch vom Aukrug Meldungssystem generiert.
                        </p>
                    </div>
                </div>
            ',
            
            'status_change' => '
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <div style="background: #f8fafc; padding: 20px; border-radius: 8px;">
                        <h2 style="color: #1e40af; margin-top: 0;">Status-Update zu Ihrer Meldung</h2>
                        
                        <p>Hallo {contact_name},</p>
                        
                        <p>der Status Ihrer Meldung hat sich geändert:</p>
                        
                        <div style="background: white; padding: 20px; border-radius: 6px; margin: 16px 0;">
                            <h3 style="margin-top: 0;">Meldung #{report_id}: {title}</h3>
                            <p><strong>Neuer Status:</strong> <span style="color: #059669; font-weight: bold;">{new_status}</span></p>
                            <p>{status_description}</p>
                        </div>
                        
                        <div style="text-align: center; margin: 24px 0;">
                            <a href="{view_url}" style="background: #3b82f6; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; display: inline-block;">
                                Meldung ansehen
                            </a>
                        </div>
                        
                        <p>Vielen Dank für Ihre Meldung!</p>
                        <p>Ihr Aukrug-Team</p>
                        
                        <p style="color: #6b7280; font-size: 12px; margin-bottom: 0;">
                            Diese E-Mail wurde automatisch generiert. Bei Fragen antworten Sie bitte auf diese E-Mail.
                        </p>
                    </div>
                </div>
            ',
            
            'admin_comment' => '
                <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
                    <div style="background: #f8fafc; padding: 20px; border-radius: 8px;">
                        <h2 style="color: #1e40af; margin-top: 0;">Neue Antwort zu Ihrer Meldung</h2>
                        
                        <p>Hallo {contact_name},</p>
                        
                        <p>wir haben eine Antwort zu Ihrer Meldung erhalten:</p>
                        
                        <div style="background: white; padding: 20px; border-radius: 6px; margin: 16px 0;">
                            <h3 style="margin-top: 0;">Meldung #{report_id}: {title}</h3>
                            <div style="background: #eff6ff; padding: 12px; border-radius: 4px; border-left: 4px solid #3b82f6;">
                                <p style="margin: 0; font-weight: bold;">Antwort von {comment_author}:</p>
                                <p style="margin: 8px 0 0 0;">{comment_message}</p>
                            </div>
                        </div>
                        
                        <div style="text-align: center; margin: 24px 0;">
                            <a href="{view_url}" style="background: #3b82f6; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; display: inline-block;">
                                Antworten
                            </a>
                        </div>
                        
                        <p>Ihr Aukrug-Team</p>
                        
                        <p style="color: #6b7280; font-size: 12px; margin-bottom: 0;">
                            Sie können auf diese E-Mail antworten, um weitere Informationen zu übermitteln.
                        </p>
                    </div>
                </div>
            '
        );

        $template_html = $templates[$template] ?? '';
        
        // Replace variables
        foreach ($variables as $key => $value) {
            $template_html = str_replace('{' . $key . '}', $value, $template_html);
        }

        // Handle address block
        if (isset($variables['address']) && $variables['address']) {
            $address_block = '<p><strong>Adresse:</strong> ' . $variables['address'] . '</p>';
        } else {
            $address_block = '';
        }
        $template_html = str_replace('{address_block}', $address_block, $template_html);

        return $template_html;
    }

    /**
     * Utility functions
     */
    private function get_admin_emails() {
        $admins = get_users(array('role' => 'administrator'));
        $emails = array();
        
        foreach ($admins as $admin) {
            if ($admin->user_email) {
                $emails[] = $admin->user_email;
            }
        }

        // Add custom notification email if set
        $custom_email = get_option('aukrug_notification_email');
        if ($custom_email && is_email($custom_email)) {
            $emails[] = $custom_email;
        }

        return array_unique($emails);
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

    private function get_priority_label($priority) {
        $labels = array(
            'low' => 'Niedrig',
            'normal' => 'Normal',
            'high' => 'Hoch',
            'urgent' => 'Dringend'
        );
        return $labels[$priority] ?? 'Normal';
    }

    private function get_status_label($status) {
        $labels = array(
            'open' => 'Offen',
            'in_progress' => 'In Bearbeitung',
            'resolved' => 'Gelöst',
            'closed' => 'Geschlossen'
        );
        return $labels[$status] ?? 'Offen';
    }

    private function get_status_description($status) {
        $descriptions = array(
            'open' => 'Ihre Meldung wurde aufgenommen und wird bearbeitet.',
            'in_progress' => 'Ihre Meldung wird derzeit bearbeitet. Wir halten Sie über den Fortschritt auf dem Laufenden.',
            'resolved' => 'Ihre Meldung wurde erfolgreich bearbeitet und das Problem behoben.',
            'closed' => 'Ihre Meldung wurde abgeschlossen. Vielen Dank für Ihre Mithilfe!'
        );
        return $descriptions[$status] ?? '';
    }

    private function get_public_report_url($report_id) {
        // Create a public viewing URL (would need custom page/endpoint)
        return home_url('/meldung/' . $report_id);
    }

    private function log_notification($type, $report_id, $meta = array()) {
        global $wpdb;
        
        $table = $wpdb->prefix . 'aukrug_report_activity';
        
        $wpdb->insert($table, array(
            'report_id' => $report_id,
            'action' => 'notification_' . $type,
            'actor_id' => get_current_user_id() ?: null,
            'actor_role' => 'system',
            'meta' => wp_json_encode($meta),
            'created_at' => current_time('mysql')
        ));
    }

    public function set_html_content_type() {
        return 'text/html';
    }

    /**
     * Manual notification triggers (for REST API)
     */
    public static function trigger_report_created($report_id, $report_data) {
        do_action('aukrug_report_created', $report_id, $report_data);
    }

    public static function trigger_status_changed($report_id, $old_status, $new_status) {
        do_action('aukrug_report_status_changed', $report_id, $old_status, $new_status);
    }

    public static function trigger_comment_added($report_id, $comment_data, $is_admin_comment) {
        do_action('aukrug_report_comment_added', $report_id, $comment_data, $is_admin_comment);
    }

    public static function trigger_assignment($report_id, $user_id, $assigner_id) {
        do_action('aukrug_report_assigned', $report_id, $user_id, $assigner_id);
    }
}

new Aukrug_Notifications();
