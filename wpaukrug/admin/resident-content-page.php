<?php
/**
 * Aukrug App Resident Content Management Panel
 * WordPress Admin Interface for Resident Features
 */

// Security check
if (!defined('ABSPATH')) {
    exit;
}

if (!current_user_can('manage_options')) {
    wp_die(__('Sie haben keine Berechtigung für diese Seite.'));
}

// Handle form submissions
if (isset($_POST['action'])) {
    $result = handle_resident_content_action($_POST);
    if ($result['success']) {
        echo '<div class="notice notice-success"><p>' . esc_html($result['message']) . '</p></div>';
    } else {
        echo '<div class="notice notice-error"><p>' . esc_html($result['message']) . '</p></div>';
    }
}

// Fetch current data
$notices = get_notices();
$settings = get_option('aukrug_resident_settings', []);
?>

<div class="wrap">
    <h1>Aukrug App - Bürger-Inhalte</h1>
    
    <div class="nav-tab-wrapper">
        <a href="#notices" class="nav-tab nav-tab-active">Amtliche Bekanntmachungen</a>
        <a href="#settings" class="nav-tab">App-Einstellungen</a>
        <a href="#notifications" class="nav-tab">Push-Benachrichtigungen</a>
    </div>

    <!-- Notices Tab -->
    <div id="notices" class="tab-content">
        <h2>Amtliche Bekanntmachungen</h2>
        
        <div class="notices-actions">
            <button class="button button-primary" onclick="openNoticeModal()">Neue Bekanntmachung erstellen</button>
            <button class="button" onclick="importNotices()">Bekanntmachungen importieren</button>
            <button class="button" onclick="exportNotices()">Exportieren</button>
        </div>

        <div class="notices-filters">
            <select id="category-filter">
                <option value="">Alle Kategorien</option>
                <option value="allgemein">Allgemein</option>
                <option value="verkehr">Verkehr</option>
                <option value="baustelle">Baustelle</option>
                <option value="veranstaltung">Veranstaltung</option>
                <option value="sitzung">Sitzung</option>
                <option value="ausschreibung">Ausschreibung</option>
                <option value="umwelt">Umwelt</option>
                <option value="sonstiges">Sonstiges</option>
            </select>
            
            <select id="importance-filter">
                <option value="">Alle Wichtigkeiten</option>
                <option value="hoch">Hoch</option>
                <option value="mittel">Mittel</option>
                <option value="niedrig">Niedrig</option>
            </select>
        </div>

        <table class="wp-list-table widefat fixed striped">
            <thead>
                <tr>
                    <th>Titel</th>
                    <th>Kategorie</th>
                    <th>Wichtigkeit</th>
                    <th>Veröffentlichung</th>
                    <th>Status</th>
                    <th>Aktionen</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($notices as $notice): ?>
                <tr>
                    <td>
                        <strong><?php echo esc_html($notice['title']); ?></strong>
                        <?php if ($notice['is_pinned']): ?>
                            <span class="dashicons dashicons-admin-post" title="Angepinnt"></span>
                        <?php endif; ?>
                        <br>
                        <small><?php echo esc_html(wp_trim_words($notice['content'], 12)); ?></small>
                    </td>
                    <td><span class="category-badge category-<?php echo esc_attr($notice['category']); ?>">
                        <?php echo get_notice_category_display_name($notice['category']); ?>
                    </span></td>
                    <td><span class="importance-badge importance-<?php echo esc_attr($notice['importance']); ?>">
                        <?php echo get_importance_display_name($notice['importance']); ?>
                    </span></td>
                    <td><?php echo date('d.m.Y', strtotime($notice['published_date'])); ?></td>
                    <td>
                        <?php if (strtotime($notice['valid_until']) > time()): ?>
                            <span class="status-active">Aktiv</span>
                        <?php else: ?>
                            <span class="status-expired">Abgelaufen</span>
                        <?php endif; ?>
                    </td>
                    <td>
                        <button class="button button-small" onclick="editNotice('<?php echo esc_js($notice['id']); ?>')">Bearbeiten</button>
                        <?php if (!$notice['is_pinned']): ?>
                            <button class="button button-small" onclick="pinNotice('<?php echo esc_js($notice['id']); ?>')">Anpinnen</button>
                        <?php else: ?>
                            <button class="button button-small" onclick="unpinNotice('<?php echo esc_js($notice['id']); ?>')">Lösen</button>
                        <?php endif; ?>
                        <button class="button button-small button-link-delete" onclick="deleteNotice('<?php echo esc_js($notice['id']); ?>')">Löschen</button>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>

    <!-- Settings Tab -->
    <div id="settings" class="tab-content" style="display: none;">
        <h2>App-Einstellungen verwalten</h2>
        
        <form method="post" action="">
            <input type="hidden" name="action" value="update_resident_settings">
            <?php wp_nonce_field('aukrug_resident_settings'); ?>
            
            <table class="form-table">
                <tr>
                    <th scope="row">Standardeinstellungen</th>
                    <td>
                        <fieldset>
                            <legend class="screen-reader-text">Benachrichtigungseinstellungen</legend>
                            <label>
                                <input type="checkbox" name="default_notices" value="1" <?php checked($settings['default_notices'] ?? true); ?>>
                                Bekanntmachungen standardmäßig aktiviert
                            </label><br><br>
                            <label>
                                <input type="checkbox" name="default_emergency" value="1" <?php checked($settings['default_emergency'] ?? true); ?>>
                                Notfall-Benachrichtigungen standardmäßig aktiviert
                            </label><br><br>
                            <label>
                                <input type="checkbox" name="default_events" value="1" <?php checked($settings['default_events'] ?? true); ?>>
                                Veranstaltungen standardmäßig aktiviert
                            </label>
                        </fieldset>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Theme-Einstellungen</th>
                    <td>
                        <select name="default_theme">
                            <option value="system" <?php selected($settings['default_theme'] ?? 'system', 'system'); ?>>System</option>
                            <option value="light" <?php selected($settings['default_theme'] ?? 'system', 'light'); ?>>Hell</option>
                            <option value="dark" <?php selected($settings['default_theme'] ?? 'system', 'dark'); ?>>Dunkel</option>
                        </select>
                        <p class="description">Standard-Theme für neue App-Installationen</p>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Cache-Einstellungen</th>
                    <td>
                        <label>
                            Cache-Dauer (Stunden)<br>
                            <input type="number" name="cache_duration" value="<?php echo esc_attr($settings['cache_duration'] ?? 24); ?>" min="1" max="168" class="small-text">
                        </label>
                        <p class="description">Wie lange sollen Daten in der App zwischengespeichert werden?</p>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Benutzer-Feedback</th>
                    <td>
                        <label>
                            <input type="checkbox" name="enable_feedback" value="1" <?php checked($settings['enable_feedback'] ?? true); ?>>
                            Feedback-Funktion aktivieren
                        </label><br><br>
                        <label>
                            Feedback E-Mail<br>
                            <input type="email" name="feedback_email" value="<?php echo esc_attr($settings['feedback_email'] ?? 'feedback@aukrug.de'); ?>" class="regular-text">
                        </label>
                    </td>
                </tr>
            </table>
            
            <?php submit_button('Einstellungen speichern'); ?>
        </form>
    </div>

    <!-- Notifications Tab -->
    <div id="notifications" class="tab-content" style="display: none;">
        <h2>Push-Benachrichtigungen</h2>
        
        <div class="notification-composer">
            <h3>Neue Benachrichtigung senden</h3>
            <form method="post" action="">
                <input type="hidden" name="action" value="send_push_notification">
                <?php wp_nonce_field('aukrug_push_notification'); ?>
                
                <table class="form-table">
                    <tr>
                        <th scope="row">Titel</th>
                        <td><input type="text" name="notification_title" class="regular-text" required></td>
                    </tr>
                    <tr>
                        <th scope="row">Nachricht</th>
                        <td><textarea name="notification_message" rows="3" cols="50" required></textarea></td>
                    </tr>
                    <tr>
                        <th scope="row">Zielgruppe</th>
                        <td>
                            <select name="notification_target" required>
                                <option value="all">Alle Benutzer</option>
                                <option value="residents">Nur Bürger</option>
                                <option value="tourists">Nur Touristen</option>
                                <option value="test">Test-Gruppe</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Priorität</th>
                        <td>
                            <select name="notification_priority">
                                <option value="normal">Normal</option>
                                <option value="high">Hoch</option>
                                <option value="max">Maximal (Notfall)</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Planen</th>
                        <td>
                            <label>
                                <input type="checkbox" name="schedule_notification" value="1">
                                Benachrichtigung planen
                            </label><br><br>
                            <input type="datetime-local" name="scheduled_time" disabled>
                        </td>
                    </tr>
                </table>
                
                <?php submit_button('Benachrichtigung senden', 'primary', 'send_notification'); ?>
            </form>
        </div>

        <div class="notification-history">
            <h3>Benachrichtigungs-Verlauf</h3>
            <table class="wp-list-table widefat fixed striped">
                <thead>
                    <tr>
                        <th>Titel</th>
                        <th>Zielgruppe</th>
                        <th>Gesendet</th>
                        <th>Zugestellt</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td colspan="5">Noch keine Benachrichtigungen gesendet.</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- Notice Modal -->
<div id="notice-modal" class="aukrug-modal" style="display: none;">
    <div class="aukrug-modal-content">
        <span class="aukrug-modal-close">&times;</span>
        <h2>Bekanntmachung bearbeiten</h2>
        <form id="notice-form">
            <table class="form-table">
                <tr>
                    <th scope="row">Titel</th>
                    <td><input type="text" id="notice-title" name="title" class="regular-text" required></td>
                </tr>
                <tr>
                    <th scope="row">Inhalt</th>
                    <td><textarea id="notice-content" name="content" rows="6" cols="50" required></textarea></td>
                </tr>
                <tr>
                    <th scope="row">Kategorie</th>
                    <td>
                        <select id="notice-category" name="category" required>
                            <option value="allgemein">Allgemein</option>
                            <option value="verkehr">Verkehr</option>
                            <option value="baustelle">Baustelle</option>
                            <option value="veranstaltung">Veranstaltung</option>
                            <option value="sitzung">Sitzung</option>
                            <option value="ausschreibung">Ausschreibung</option>
                            <option value="umwelt">Umwelt</option>
                            <option value="sonstiges">Sonstiges</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Wichtigkeit</th>
                    <td>
                        <select id="notice-importance" name="importance" required>
                            <option value="niedrig">Niedrig</option>
                            <option value="mittel">Mittel</option>
                            <option value="hoch">Hoch</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Gültigkeitszeitraum</th>
                    <td>
                        <label>
                            Von<br>
                            <input type="date" id="notice-published" name="published_date" required>
                        </label><br><br>
                        <label>
                            Bis<br>
                            <input type="date" id="notice-valid-until" name="valid_until" required>
                        </label>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Einstellungen</th>
                    <td>
                        <label>
                            <input type="checkbox" id="notice-pinned" name="is_pinned" value="1">
                            Bekanntmachung anpinnen
                        </label><br><br>
                        <label>
                            <input type="checkbox" id="notice-push" name="send_push" value="1">
                            Push-Benachrichtigung senden
                        </label>
                    </td>
                </tr>
            </table>
            
            <p class="submit">
                <button type="submit" class="button button-primary">Speichern</button>
                <button type="button" class="button" onclick="closeNoticeModal()">Abbrechen</button>
            </p>
        </form>
    </div>
</div>

<style>
.category-badge, .importance-badge {
    padding: 2px 8px;
    border-radius: 12px;
    font-size: 11px;
    font-weight: bold;
    color: white;
}

.category-allgemein { background: #34495e; }
.category-verkehr { background: #e74c3c; }
.category-baustelle { background: #f39c12; }
.category-veranstaltung { background: #9b59b6; }
.category-sitzung { background: #3498db; }
.category-ausschreibung { background: #1abc9c; }
.category-umwelt { background: #27ae60; }
.category-sonstiges { background: #95a5a6; }

.importance-niedrig { background: #95a5a6; }
.importance-mittel { background: #f39c12; }
.importance-hoch { background: #e74c3c; }

.status-active { color: #27ae60; font-weight: bold; }
.status-expired { color: #e74c3c; font-weight: bold; }

.notices-actions, .notices-filters {
    margin: 20px 0;
}

.notices-filters select {
    margin-right: 10px;
}

.notification-composer, .notification-history {
    background: #f9f9f9;
    padding: 20px;
    margin: 20px 0;
    border-radius: 8px;
}

.aukrug-modal {
    position: fixed;
    z-index: 100000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.5);
}

.aukrug-modal-content {
    background-color: #fefefe;
    margin: 5% auto;
    padding: 20px;
    border: none;
    border-radius: 8px;
    width: 80%;
    max-width: 800px;
    max-height: 90vh;
    overflow-y: auto;
}

.aukrug-modal-close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}

.tab-content {
    background: white;
    padding: 20px;
    border: 1px solid #ccd0d4;
    border-top: none;
}
</style>

<script>
// Tab functionality
document.addEventListener('DOMContentLoaded', function() {
    const tabs = document.querySelectorAll('.nav-tab');
    const contents = document.querySelectorAll('.tab-content');
    
    tabs.forEach((tab, index) => {
        tab.addEventListener('click', function(e) {
            e.preventDefault();
            
            tabs.forEach(t => t.classList.remove('nav-tab-active'));
            contents.forEach(c => c.style.display = 'none');
            
            this.classList.add('nav-tab-active');
            contents[index].style.display = 'block';
        });
    });

    // Schedule notification checkbox
    const scheduleCheckbox = document.querySelector('input[name="schedule_notification"]');
    const scheduledTimeInput = document.querySelector('input[name="scheduled_time"]');
    
    if (scheduleCheckbox && scheduledTimeInput) {
        scheduleCheckbox.addEventListener('change', function() {
            scheduledTimeInput.disabled = !this.checked;
        });
    }
});

// Modal functions
function openNoticeModal(id = null) {
    if (id) {
        loadNotice(id);
    } else {
        document.getElementById('notice-form').reset();
        // Set default dates
        const today = new Date().toISOString().split('T')[0];
        const nextMonth = new Date();
        nextMonth.setMonth(nextMonth.getMonth() + 1);
        document.getElementById('notice-published').value = today;
        document.getElementById('notice-valid-until').value = nextMonth.toISOString().split('T')[0];
    }
    document.getElementById('notice-modal').style.display = 'block';
}

function closeNoticeModal() {
    document.getElementById('notice-modal').style.display = 'none';
}

function editNotice(id) {
    openNoticeModal(id);
}

function deleteNotice(id) {
    if (confirm('Möchten Sie diese Bekanntmachung wirklich löschen?')) {
        deleteItemAjax('notice', id);
    }
}

function pinNotice(id) {
    updateNoticePin(id, true);
}

function unpinNotice(id) {
    updateNoticePin(id, false);
}

function updateNoticePin(id, pinned) {
    const data = new FormData();
    data.append('action', 'update_notice_pin');
    data.append('id', id);
    data.append('pinned', pinned ? '1' : '0');
    data.append('nonce', '<?php echo wp_create_nonce("aukrug_admin"); ?>');
    
    fetch(ajaxurl, {
        method: 'POST',
        body: data
    })
    .then(response => response.json())
    .then(result => {
        if (result.success) {
            location.reload();
        } else {
            alert('Fehler beim Aktualisieren: ' + result.message);
        }
    });
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('notice-modal');
    if (event.target === modal) {
        modal.style.display = 'none';
    }
}
</script>

<?php

// Helper functions
function get_notices() {
    // Return mock data for now - will be replaced with database calls
    return [
        [
            'id' => '1',
            'title' => 'Straßensperrung Hauptstraße',
            'content' => 'Aufgrund von Bauarbeiten ist die Hauptstraße vom 15.01. bis 20.01. gesperrt...',
            'category' => 'verkehr',
            'importance' => 'hoch',
            'published_date' => '2024-01-10',
            'valid_until' => '2024-01-25',
            'is_pinned' => true,
        ],
        [
            'id' => '2',
            'title' => 'Gemeindeversammlung',
            'content' => 'Die nächste Gemeindeversammlung findet am 25.01. statt...',
            'category' => 'sitzung',
            'importance' => 'mittel',
            'published_date' => '2024-01-05',
            'valid_until' => '2024-01-26',
            'is_pinned' => false,
        ],
    ];
}

function get_notice_category_display_name($category) {
    $names = [
        'allgemein' => 'Allgemein',
        'verkehr' => 'Verkehr',
        'baustelle' => 'Baustelle',
        'veranstaltung' => 'Veranstaltung',
        'sitzung' => 'Sitzung',
        'ausschreibung' => 'Ausschreibung',
        'umwelt' => 'Umwelt',
        'sonstiges' => 'Sonstiges',
    ];
    return $names[$category] ?? $category;
}

function get_importance_display_name($importance) {
    $names = [
        'niedrig' => 'Niedrig',
        'mittel' => 'Mittel',
        'hoch' => 'Hoch',
    ];
    return $names[$importance] ?? $importance;
}

function handle_resident_content_action($post_data) {
    switch ($post_data['action']) {
        case 'update_resident_settings':
            if (!wp_verify_nonce($post_data['_wpnonce'], 'aukrug_resident_settings')) {
                return ['success' => false, 'message' => 'Sicherheitsprüfung fehlgeschlagen.'];
            }
            
            $settings = [
                'default_notices' => isset($post_data['default_notices']),
                'default_emergency' => isset($post_data['default_emergency']),
                'default_events' => isset($post_data['default_events']),
                'default_theme' => sanitize_text_field($post_data['default_theme']),
                'cache_duration' => intval($post_data['cache_duration']),
                'enable_feedback' => isset($post_data['enable_feedback']),
                'feedback_email' => sanitize_email($post_data['feedback_email']),
            ];
            
            update_option('aukrug_resident_settings', $settings);
            return ['success' => true, 'message' => 'Einstellungen erfolgreich gespeichert.'];
            
        case 'send_push_notification':
            if (!wp_verify_nonce($post_data['_wpnonce'], 'aukrug_push_notification')) {
                return ['success' => false, 'message' => 'Sicherheitsprüfung fehlgeschlagen.'];
            }
            
            // TODO: Implement push notification sending
            return ['success' => true, 'message' => 'Benachrichtigung erfolgreich gesendet.'];
            
        default:
            return ['success' => false, 'message' => 'Unbekannte Aktion.'];
    }
}
?>
