<?php
/**
 * Aukrug Connect Clean Dashboard
 * Einziges Dashboard - kein doppeltes Menu
 */

// Verhindere direkten Zugriff
if (!defined('ABSPATH')) {
    exit;
}

class Aukrug_Dashboard_Clean {
    
    private static $instance = null;
    
    // Singleton Pattern um doppelte Initialisierung zu verhindern
    public static function get_instance() {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }
    
    public function __construct() {
        // Verhindere mehrfache Initialisierung
        if (self::$instance !== null) {
            return;
        }
        
        add_action('admin_menu', array($this, 'add_admin_menu'));
        add_action('admin_enqueue_scripts', array($this, 'enqueue_admin_assets'));
        add_action('wp_ajax_aukrug_dashboard_action', array($this, 'handle_ajax_actions'));
    }
    
    /**
     * Admin-Menü hinzufügen - nur einmal!
     */
    public function add_admin_menu() {
        // Prüfe ob Menu bereits existiert
        global $admin_page_hooks;
        if (isset($admin_page_hooks['aukrug'])) {
            error_log('[Aukrug] Dashboard menu already exists - skipping');
            return;
        }
        
        error_log('[Aukrug] Registering CLEAN dashboard menu');
        
        add_menu_page(
            'Aukrug Connect',
            'Aukrug Connect',
            'edit_posts',
            'aukrug',
            array($this, 'main_dashboard_page'),
            'dashicons-location-alt',
            25
        );
    }
    
    /**
     * Admin Assets laden
     */
    public function enqueue_admin_assets($hook) {
        if (strpos($hook, 'aukrug') === false) {
            return;
        }
        
        // CSS und JS Assets laden
        $css_path = plugin_dir_path(__FILE__) . '../assets/css/dashboard-admin-v2.css';
        $js_path = plugin_dir_path(__FILE__) . '../assets/js/dashboard-admin.js';
        
        if (file_exists($css_path)) {
            wp_enqueue_style('aukrug-admin', plugins_url('../assets/css/dashboard-admin-v2.css', __FILE__), [], filemtime($css_path));
        }
        if (file_exists($js_path)) {
            wp_enqueue_script('aukrug-admin', plugins_url('../assets/js/dashboard-admin.js', __FILE__), [], filemtime($js_path), true);
        }
        
        // External dependencies
        wp_enqueue_script('chartjs', 'https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js', [], null, true);
        
        // Ajax Nonce
        wp_localize_script('aukrug-admin', 'aukrug_ajax', array(
            'nonce' => wp_create_nonce('aukrug_dashboard_nonce'),
            'ajax_url' => admin_url('admin-ajax.php')
        ));
    }

    /**
     * Hauptseite des Dashboards
     */
    public function main_dashboard_page() {
        $current_tab = isset($_GET['tab']) ? sanitize_text_field($_GET['tab']) : 'overview';
        
        // Dashboard stats
        $stats = $this->get_dashboard_stats();
        ?>
        <div class="aukrug-dashboard">
            <h1>
                <span class="dashicons dashicons-location-alt"></span>
                Aukrug Connect Dashboard
                <span class="version-badge">v1.0.0</span>
            </h1>
            
            <!-- Tab Navigation -->
            <div class="nav-tab-wrapper">
                <a href="?page=aukrug&tab=overview" class="nav-tab <?php echo $current_tab === 'overview' ? 'nav-tab-active' : ''; ?>">
                    <span class="dashicons dashicons-dashboard"></span> Übersicht
                </a>
                <a href="?page=aukrug&tab=reports" class="nav-tab <?php echo $current_tab === 'reports' ? 'nav-tab-active' : ''; ?>">
                    <span class="dashicons dashicons-feedback"></span> Meldungen/Tickets
                </a>
                <a href="?page=aukrug&tab=places" class="nav-tab <?php echo $current_tab === 'places' ? 'nav-tab-active' : ''; ?>">
                    <span class="dashicons dashicons-location"></span> Orte & POIs
                </a>
                <a href="?page=aukrug&tab=geocaching" class="nav-tab <?php echo $current_tab === 'geocaching' ? 'nav-tab-active' : ''; ?>">
                    <span class="dashicons dashicons-location-alt"></span> GeoCaching
                </a>
                <a href="?page=aukrug&tab=users" class="nav-tab <?php echo $current_tab === 'users' ? 'nav-tab-active' : ''; ?>">
                    <span class="dashicons dashicons-admin-users"></span> App-Benutzer
                </a>
                <a href="?page=aukrug&tab=community" class="nav-tab <?php echo $current_tab === 'community' ? 'nav-tab-active' : ''; ?>">
                    <span class="dashicons dashicons-groups"></span> Community
                </a>
                <a href="?page=aukrug&tab=events" class="nav-tab <?php echo $current_tab === 'events' ? 'nav-tab-active' : ''; ?>">
                    <span class="dashicons dashicons-calendar-alt"></span> Events & Routen
                </a>
                <a href="?page=aukrug&tab=notifications" class="nav-tab <?php echo $current_tab === 'notifications' ? 'nav-tab-active' : ''; ?>">
                    <span class="dashicons dashicons-bell"></span> Push-Notifications
                </a>
                <a href="?page=aukrug&tab=analytics" class="nav-tab <?php echo $current_tab === 'analytics' ? 'nav-tab-active' : ''; ?>">
                    <span class="dashicons dashicons-chart-line"></span> Analytics
                </a>
                <a href="?page=aukrug&tab=settings" class="nav-tab <?php echo $current_tab === 'settings' ? 'nav-tab-active' : ''; ?>">
                    <span class="dashicons dashicons-admin-settings"></span> Einstellungen
                </a>
            </div>

            <!-- Tab Content -->
            <div class="tab-content">
                <?php
                switch ($current_tab) {
                    case 'overview':
                        $this->render_overview_tab($stats);
                        break;
                    case 'reports':
                        $this->render_reports_tab();
                        break;
                    case 'places':
                        $this->render_places_tab();
                        break;
                    case 'geocaching':
                        $this->render_geocaching_tab();
                        break;
                    case 'users':
                        $this->render_users_tab();
                        break;
                    case 'community':
                        $this->render_community_tab();
                        break;
                    case 'events':
                        $this->render_events_tab();
                        break;
                    case 'notifications':
                        $this->render_notifications_tab();
                        break;
                    case 'analytics':
                        $this->render_analytics_tab($stats);
                        break;
                    case 'settings':
                        $this->render_settings_tab();
                        break;
                    default:
                        $this->render_overview_tab($stats);
                }
                ?>
            </div>
        </div>
        <?php
    }

    /**
     * Overview Tab
     */
    private function render_overview_tab($stats) {
        ?>
        <!-- KPI Cards -->
        <div class="kpi-grid">
            <div class="kpi-card users">
                <div class="kpi-icon">
                    <span class="dashicons dashicons-admin-users"></span>
                </div>
                <div class="kpi-content">
                    <h3>App Benutzer</h3>
                    <div class="kpi-value"><?php echo number_format($stats['total_users']); ?></div>
                    <div class="kpi-change positive">+<?php echo $stats['new_users_this_week']; ?> diese Woche</div>
                </div>
            </div>
            
            <div class="kpi-card reports">
                <div class="kpi-icon">
                    <span class="dashicons dashicons-feedback"></span>
                </div>
                <div class="kpi-content">
                    <h3>Offene Tickets</h3>
                    <div class="kpi-value"><?php echo number_format($stats['open_reports']); ?></div>
                    <div class="kpi-change neutral"><?php echo $stats['new_reports_today']; ?> heute</div>
                </div>
            </div>
            
            <div class="kpi-card places">
                <div class="kpi-icon">
                    <span class="dashicons dashicons-location"></span>
                </div>
                <div class="kpi-content">
                    <h3>Orte & POIs</h3>
                    <div class="kpi-value"><?php echo number_format($stats['total_places']); ?></div>
                    <div class="kpi-change neutral"><?php echo $stats['active_places']; ?> aktiv</div>
                </div>
            </div>
            
            <div class="kpi-card api-calls">
                <div class="kpi-icon">
                    <span class="dashicons dashicons-admin-network"></span>
                </div>
                <div class="kpi-content">
                    <h3>API Aufrufe</h3>
                    <div class="kpi-value"><?php echo number_format($stats['api_calls_today']); ?></div>
                    <div class="kpi-change positive">Heute</div>
                </div>
            </div>
        </div>
        
        <!-- Chart mit fester Höhe -->
        <div class="dashboard-panels">
            <div class="panel-left">
                <div class="dashboard-panel chart-panel">
                    <h3><span class="dashicons dashicons-chart-line"></span> Benutzeraktivität (7 Tage)</h3>
                    <div class="chart-container">
                        <canvas id="userActivityChart"></canvas>
                    </div>
                </div>
            </div>
            
            <div class="panel-right">
                <div class="dashboard-panel">
                    <h3><span class="dashicons dashicons-bell"></span> Aktuelle Aktivitäten</h3>
                    <div class="activity-feed">
                        <?php foreach ($stats['recent_activities'] as $activity): ?>
                            <div class="activity-item">
                                <div class="activity-time"><?php echo human_time_diff(strtotime($activity['time'])); ?> ago</div>
                                <div class="activity-description"><?php echo esc_html($activity['description']); ?></div>
                            </div>
                        <?php endforeach; ?>
                    </div>
                </div>
            </div>
        </div>
        
        <script>
        // Chart mit fester Höhe
        document.addEventListener('DOMContentLoaded', function() {
            const canvas = document.getElementById('userActivityChart');
            if (canvas) {
                const ctx = canvas.getContext('2d');
                new Chart(ctx, {
                    type: 'line',
                    data: {
                        labels: <?php echo json_encode($stats['activity_labels']); ?>,
                        datasets: [{
                            label: 'Aktive Benutzer',
                            data: <?php echo json_encode($stats['activity_data']); ?>,
                            borderColor: '#0073aa',
                            backgroundColor: 'rgba(0, 115, 170, 0.1)',
                            tension: 0.4
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        plugins: {
                            legend: { display: true }
                        },
                        scales: {
                            y: { beginAtZero: true }
                        }
                    }
                });
            }
        });
        </script>
        <?php
    }

    /**
     * Reports Tab - Ticket-System
     */
    private function render_reports_tab() {
        ?>
        <div class="reports-management">
            <h2><span class="dashicons dashicons-feedback"></span> Meldungen & Tickets</h2>
            <p>Hier würde das vollständige Ticket-System erscheinen.</p>
            
            <div class="status-filter">
                <a href="#" class="filter-link active">Alle (25)</a>
                <a href="#" class="filter-link">Offen (8)</a>
                <a href="#" class="filter-link">In Bearbeitung (5)</a>
                <a href="#" class="filter-link">Gelöst (10)</a>
                <a href="#" class="filter-link">Geschlossen (2)</a>
            </div>
            
            <table class="wp-list-table widefat fixed striped">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Titel</th>
                        <th>Status</th>
                        <th>Priorität</th>
                        <th>Erstellt</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>#001</td>
                        <td>Straßenschaden Hauptstraße</td>
                        <td><span class="status-badge status-open">Offen</span></td>
                        <td><span class="priority-badge priority-high">Hoch</span></td>
                        <td>07.09.2025 09:30</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <?php
    }

    /**
     * Places Tab
     */
    private function render_places_tab() {
        $places = $this->get_places_data();
        ?>
        <div class="places-management">
            <div class="places-header">
                <h2><span class="dashicons dashicons-location"></span> Orte & POIs Verwaltung</h2>
                <button class="button button-primary" id="add-new-place">
                    <span class="dashicons dashicons-plus"></span> Neuer Ort
                </button>
            </div>

            <div class="places-grid">
                <?php foreach ($places as $place): ?>
                <div class="place-card" data-place-id="<?php echo $place['id']; ?>">
                    <div class="place-image">
                        <img src="<?php echo esc_url($place['image'] ?: 'https://picsum.photos/300/200'); ?>" alt="<?php echo esc_attr($place['name']); ?>">
                        <div class="place-status <?php echo $place['is_active'] ? 'active' : 'inactive'; ?>">
                            <?php echo $place['is_active'] ? 'Aktiv' : 'Inaktiv'; ?>
                        </div>
                    </div>
                    <div class="place-content">
                        <h3><?php echo esc_html($place['name']); ?></h3>
                        <p class="place-category"><?php echo esc_html($place['category']); ?></p>
                        <p class="place-description"><?php echo esc_html(wp_trim_words($place['description'], 15)); ?></p>
                        <div class="place-meta">
                            <span class="place-rating">
                                <?php for ($i = 0; $i < 5; $i++): ?>
                                    <span class="star <?php echo $i < $place['rating'] ? 'filled' : ''; ?>">★</span>
                                <?php endfor; ?>
                                (<?php echo $place['rating']; ?>)
                            </span>
                            <span class="place-visits"><?php echo $place['visits']; ?> Besuche</span>
                        </div>
                        <div class="place-actions">
                            <button class="button edit-place" data-place-id="<?php echo $place['id']; ?>">Bearbeiten</button>
                            <button class="button toggle-place-status" data-place-id="<?php echo $place['id']; ?>">
                                <?php echo $place['is_active'] ? 'Deaktivieren' : 'Aktivieren'; ?>
                            </button>
                        </div>
                    </div>
                </div>
                <?php endforeach; ?>
            </div>
        </div>
        <?php
    }

    /**
     * GeoCaching Tab
     */
    private function render_geocaching_tab() {
        ?>
        <div class="geocaching-management">
            <h2><span class="dashicons dashicons-location-alt"></span> GeoCaching Verwaltung</h2>
            
            <div class="geocaching-stats">
                <div class="stat-box">
                    <h4>Aktive Caches</h4>
                    <div class="stat-number">12</div>
                </div>
                <div class="stat-box">
                    <h4>Gefundene Caches</h4>
                    <div class="stat-number">89</div>
                </div>
                <div class="stat-box">
                    <h4>Cache-Finder</h4>
                    <div class="stat-number">45</div>
                </div>
            </div>

            <div class="geocaching-actions">
                <button class="button button-primary">Neuen Cache hinzufügen</button>
                <button class="button">Import von Geocaching.com</button>
                <button class="button">Cache-Report generieren</button>
            </div>

            <table class="wp-list-table widefat fixed striped">
                <thead>
                    <tr>
                        <th>Cache Name</th>
                        <th>Koordinaten</th>
                        <th>Schwierigkeit</th>
                        <th>Gelände</th>
                        <th>Status</th>
                        <th>Funde</th>
                        <th>Aktionen</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>Aukruger Naturschatz</td>
                        <td>54.1234, 9.5678</td>
                        <td>2.5/5</td>
                        <td>3/5</td>
                        <td><span class="status-badge status-active">Aktiv</span></td>
                        <td>23</td>
                        <td><button class="button">Bearbeiten</button></td>
                    </tr>
                </tbody>
            </table>
        </div>
        <?php
    }

    /**
     * Users Tab - App Benutzer
     */
    private function render_users_tab() {
        $users = $this->get_app_users_data();
        ?>
        <div class="users-management">
            <h2><span class="dashicons dashicons-admin-users"></span> App Benutzer Verwaltung</h2>
            <p class="description">Unabhängige Benutzerverwaltung für die App (getrennt von WordPress-Benutzern)</p>
            
            <div class="users-stats">
                <div class="stat-box">
                    <h4>Gesamte Benutzer</h4>
                    <div class="stat-number"><?php echo number_format($users['total']); ?></div>
                </div>
                <div class="stat-box">
                    <h4>Aktive Benutzer (30 Tage)</h4>
                    <div class="stat-number"><?php echo number_format($users['active_30d']); ?></div>
                </div>
                <div class="stat-box">
                    <h4>Neue Benutzer (7 Tage)</h4>
                    <div class="stat-number"><?php echo number_format($users['new_7d']); ?></div>
                </div>
            </div>

            <table class="wp-list-table widefat fixed striped">
                <thead>
                    <tr>
                        <th>Benutzer ID</th>
                        <th>Name/Alias</th>
                        <th>Registriert</th>
                        <th>Letzte Aktivität</th>
                        <th>Meldungen</th>
                        <th>Status</th>
                        <th>Aktionen</th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($users['items'] as $user): ?>
                    <tr>
                        <td><?php echo esc_html($user['id']); ?></td>
                        <td><?php echo esc_html($user['display_name'] ?: 'Anonym'); ?></td>
                        <td><?php echo date('d.m.Y', strtotime($user['created_at'])); ?></td>
                        <td><?php echo $user['last_activity'] ? human_time_diff(strtotime($user['last_activity'])) . ' ago' : 'Nie'; ?></td>
                        <td><?php echo number_format($user['reports_count']); ?></td>
                        <td>
                            <span class="status-badge status-<?php echo $user['status']; ?>">
                                <?php echo ucfirst($user['status']); ?>
                            </span>
                        </td>
                        <td>
                            <button class="button view-user" data-user-id="<?php echo $user['id']; ?>">Details</button>
                        </td>
                    </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
        </div>
        <?php
    }

    /**
     * Community Tab
     */
    private function render_community_tab() {
        ?>
        <div class="community-management">
            <h2><span class="dashicons dashicons-groups"></span> Community Management</h2>
            
            <div class="community-overview">
                <div class="stat-box">
                    <h4>Community Mitglieder</h4>
                    <div class="stat-number">156</div>
                </div>
                <div class="stat-box">
                    <h4>Aktive Diskussionen</h4>
                    <div class="stat-number">12</div>
                </div>
                <div class="stat-box">
                    <h4>Events diese Woche</h4>
                    <div class="stat-number">3</div>
                </div>
            </div>

            <div class="community-features">
                <h3>Community Features</h3>
                <ul>
                    <li>📱 Community Chat & Diskussionen</li>
                    <li>📅 Event-Organisation & Teilnahme</li>
                    <li>🏆 Gamification & Belohnungen</li>
                    <li>🗳️ Umfragen & Abstimmungen</li>
                    <li>📢 Ankündigungen & News</li>
                </ul>
            </div>
        </div>
        <?php
    }

    /**
     * Events Tab
     */
    private function render_events_tab() {
        ?>
        <div class="events-management">
            <h2><span class="dashicons dashicons-calendar-alt"></span> Events & Routen Verwaltung</h2>
            
            <div class="events-actions">
                <button class="button button-primary">Neues Event erstellen</button>
                <button class="button">Neue Route hinzufügen</button>
                <button class="button">Kalender exportieren</button>
            </div>

            <div class="events-overview">
                <h3>Kommende Events</h3>
                <table class="wp-list-table widefat fixed striped">
                    <thead>
                        <tr>
                            <th>Event Name</th>
                            <th>Datum</th>
                            <th>Teilnehmer</th>
                            <th>Status</th>
                            <th>Aktionen</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Aukruger Wandertag</td>
                            <td>15.09.2025</td>
                            <td>23/50</td>
                            <td><span class="status-badge status-active">Offen</span></td>
                            <td><button class="button">Bearbeiten</button></td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="routes-overview">
                <h3>Beliebte Routen</h3>
                <p>Wanderrouten, Radwege und touristische Strecken durch Aukrug.</p>
            </div>
        </div>
        <?php
    }

    /**
     * Notifications Tab
     */
    private function render_notifications_tab() {
        ?>
        <div class="notifications-management">
            <h2><span class="dashicons dashicons-bell"></span> Push Notifications</h2>
            
            <div class="notifications-actions">
                <button class="button button-primary">Neue Benachrichtigung senden</button>
                <button class="button">Geplante Nachrichten</button>
                <button class="button">Notification-Report</button>
            </div>

            <div class="notification-stats">
                <div class="stat-box">
                    <h4>Gesendet heute</h4>
                    <div class="stat-number">47</div>
                </div>
                <div class="stat-box">
                    <h4>Geöffnet</h4>
                    <div class="stat-number">32</div>
                </div>
                <div class="stat-box">
                    <h4>Öffnungsrate</h4>
                    <div class="stat-number">68%</div>
                </div>
            </div>

            <div class="recent-notifications">
                <h3>Letzte Benachrichtigungen</h3>
                <table class="wp-list-table widefat fixed striped">
                    <thead>
                        <tr>
                            <th>Titel</th>
                            <th>Gesendet</th>
                            <th>Empfänger</th>
                            <th>Geöffnet</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>Neues Event: Wandertag</td>
                            <td>07.09.2025 10:30</td>
                            <td>156</td>
                            <td>89</td>
                            <td><span class="status-badge status-sent">Gesendet</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
        <?php
    }

    /**
     * Analytics Tab
     */
    private function render_analytics_tab($stats) {
        ?>
        <div class="analytics-management">
            <h2><span class="dashicons dashicons-chart-line"></span> Analytics & Reports</h2>
            
            <div class="analytics-overview">
                <div class="stat-box">
                    <h4>Seitenaufrufe heute</h4>
                    <div class="stat-number">1,247</div>
                </div>
                <div class="stat-box">
                    <h4>API Calls</h4>
                    <div class="stat-number">8,392</div>
                </div>
                <div class="stat-box">
                    <h4>Aktive Sessions</h4>
                    <div class="stat-number">89</div>
                </div>
                <div class="stat-box">
                    <h4>Durchschn. Session</h4>
                    <div class="stat-number">4:32 min</div>
                </div>
            </div>

            <div class="analytics-charts">
                <h3>Detaillierte Analytics</h3>
                <p>Hier würden erweiterte Charts und Berichte angezeigt werden.</p>
                
                <div class="chart-container">
                    <canvas id="analyticsChart"></canvas>
                </div>
            </div>
        </div>
        <?php
    }

    /**
     * Settings Tab
     */
    private function render_settings_tab() {
        ?>
        <div class="settings-management">
            <h2><span class="dashicons dashicons-admin-settings"></span> Plugin Einstellungen</h2>
            
            <form method="post" action="">
                <?php wp_nonce_field('aukrug_settings', 'aukrug_settings_nonce'); ?>
                
                <table class="form-table">
                    <tr>
                        <th scope="row">API Basis-URL</th>
                        <td>
                            <input type="url" name="api_base_url" value="https://aukrug.mioconnex.com" class="regular-text" />
                            <p class="description">Basis-URL für API-Aufrufe</p>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Debug Modus</th>
                        <td>
                            <label>
                                <input type="checkbox" name="debug_mode" value="1" checked />
                                Debug-Logging aktivieren
                            </label>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Cache-Laufzeit</th>
                        <td>
                            <select name="cache_duration">
                                <option value="3600">1 Stunde</option>
                                <option value="21600" selected>6 Stunden</option>
                                <option value="86400">24 Stunden</option>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th scope="row">Push Notifications</th>
                        <td>
                            <label>
                                <input type="checkbox" name="push_enabled" value="1" checked />
                                Push-Benachrichtigungen aktivieren
                            </label>
                        </td>
                    </tr>
                </table>
                
                <?php submit_button('Einstellungen speichern'); ?>
            </form>

            <div class="settings-info">
                <h3>Plugin Information</h3>
                <ul>
                    <li><strong>Version:</strong> 1.0.0</li>
                    <li><strong>Letzte Aktualisierung:</strong> 07.09.2025</li>
                    <li><strong>Plugin-Pfad:</strong> <?php echo plugin_dir_path(__FILE__); ?></li>
                    <li><strong>WordPress Version:</strong> <?php echo get_bloginfo('version'); ?></li>
                </ul>
            </div>
        </div>
        <?php
    }

    /**
     * Get Places Data
     */
    private function get_places_data() {
        return array(
            array(
                'id' => 'place_001',
                'name' => 'Naturpark Aukrug',
                'description' => 'Wunderschöner Naturpark mit vielfältigen Wanderwegen.',
                'category' => 'Natur',
                'rating' => 5,
                'visits' => 1250,
                'is_active' => true,
                'image' => 'https://picsum.photos/300/200?random=1'
            ),
            array(
                'id' => 'place_002',
                'name' => 'Gasthof Zur Linde',
                'description' => 'Traditioneller Gasthof mit regionaler Küche.',
                'category' => 'Gastronomie',
                'rating' => 4,
                'visits' => 890,
                'is_active' => true,
                'image' => 'https://picsum.photos/300/200?random=2'
            )
        );
    }

    /**
     * Get App Users Data
     */
    private function get_app_users_data() {
        return array(
            'total' => 156,
            'active_30d' => 78,
            'new_7d' => 12,
            'items' => array(
                array(
                    'id' => 'app_user_001',
                    'display_name' => 'Naturfreund2024',
                    'created_at' => '2025-08-15 10:30:00',
                    'last_activity' => '2025-09-07 09:15:00',
                    'reports_count' => 3,
                    'status' => 'active'
                ),
                array(
                    'id' => 'app_user_002',
                    'display_name' => '',
                    'created_at' => '2025-08-20 14:20:00',
                    'last_activity' => '2025-09-05 16:45:00',
                    'reports_count' => 1,
                    'status' => 'active'
                )
            )
        );
    }

    /**
     * Dashboard-Statistiken
     */
    private function get_dashboard_stats() {
        return array(
            'total_users' => 156,
            'new_users_this_week' => 12,
            'open_reports' => 8,
            'new_reports_today' => 3,
            'total_places' => 10,
            'active_places' => 10,
            'api_calls_today' => 1247,
            'activity_labels' => ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
            'activity_data' => [45, 52, 38, 47, 59, 73, 68],
            'recent_activities' => array(
                array('time' => '2025-09-07 10:30:00', 'description' => 'Neue Meldung eingegangen'),
                array('time' => '2025-09-07 09:15:00', 'description' => 'Benutzer registriert'),
                array('time' => '2025-09-07 08:45:00', 'description' => 'GeoCaching-Fund gemeldet'),
                array('time' => '2025-09-06 16:20:00', 'description' => 'POI aktualisiert'),
            )
        );
    }

    /**
     * AJAX Actions
     */
    public function handle_ajax_actions() {
        check_ajax_referer('aukrug_dashboard_nonce', 'nonce');
        wp_send_json_success(['message' => 'Action processed']);
    }
}

// Keine automatische Initialisierung hier!
