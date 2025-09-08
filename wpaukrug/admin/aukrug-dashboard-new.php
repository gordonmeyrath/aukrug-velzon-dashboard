<?php
/**
 * Aukrug Connect Comprehensive Dashboard
 * Tab-basiertes System für alle App-Funktionen
 */

// Verhindere direkten Zugriff
if (!defined('ABSPATH')) {
    exit;
}

class Aukrug_Dashboard_New {
    
    public function __construct() {
        add_action('admin_menu', array($this, 'add_admin_menu'));
        add_action('admin_enqueue_scripts', array($this, 'enqueue_admin_assets'));
        add_action('wp_ajax_aukrug_dashboard_action', array($this, 'handle_ajax_actions'));
    }
    
    /**
     * Admin-Menü hinzufügen
     */
    public function add_admin_menu() {
        // Debug: Log dashboard registration
        error_log('[Aukrug Dashboard] Registering NEW dashboard menu');
        
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
        $css = plugin_dir_path(__FILE__) . '../assets/css/dashboard-admin-v2.css';
        $js = plugin_dir_path(__FILE__) . '../assets/js/dashboard-admin.js';
        
        if (file_exists($css)) {
            wp_enqueue_style('aukrug-admin', plugins_url('../assets/css/dashboard-admin-v2.css', __FILE__), [], filemtime($css));
        }
        if (file_exists($js)) {
            wp_enqueue_script('aukrug-admin', plugins_url('../assets/js/dashboard-admin.js', __FILE__), [], filemtime($js), true);
            wp_script_add_data('aukrug-admin', 'type', 'module');
        }
        
        // External dependencies
        wp_enqueue_script('chartjs', 'https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js', [], null, true);
        wp_enqueue_script('leaflet', 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.js', [], null, true);
        wp_enqueue_style('leaflet', 'https://unpkg.com/leaflet@1.9.4/dist/leaflet.css', [], null);
        
        // Ajax Nonce für Dashboard-AJAX-Calls
        wp_localize_script('aukrug-admin', 'aukrug_ajax', array(
            'nonce' => wp_create_nonce('aukrug_dashboard_nonce'),
            'ajax_url' => admin_url('admin-ajax.php')
        ));
    }

    /**
     * Hauptseite des Dashboards mit vollständigem Tab-System
     */
    public function main_dashboard_page() {
        $current_tab = isset($_GET['tab']) ? sanitize_text_field($_GET['tab']) : 'overview';
        
        // Actions verarbeiten
        if ($_POST && wp_verify_nonce($_POST['aukrug_nonce'], 'aukrug_dashboard')) {
            $this->process_dashboard_actions($current_tab);
        }

        // Daten für Dashboard laden
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
        
        <?php wp_nonce_field('aukrug_dashboard', 'aukrug_nonce'); ?>
        <?php
    }

    /**
     * Overview Tab - Dashboard Übersicht mit korrigiertem Chart
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
        
        <!-- Quick Stats und Activity -->
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
        // Chart.js initialization with fixed height
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
                            legend: {
                                display: true
                            }
                        },
                        scales: {
                            y: {
                                beginAtZero: true
                            }
                        }
                    }
                });
            }
        });
        </script>
        <?php
    }

    /**
     * Reports Tab - Ticket-System für Meldungen
     */
    private function render_reports_tab() {
        $reports = $this->get_reports_data();
        $filter_status = isset($_GET['status']) ? sanitize_text_field($_GET['status']) : 'all';
        ?>
        <div class="reports-management">
            <div class="reports-header">
                <h2><span class="dashicons dashicons-feedback"></span> Meldungen & Tickets</h2>
                <div class="reports-actions">
                    <button class="button button-primary" id="refresh-reports">
                        <span class="dashicons dashicons-update"></span> Aktualisieren
                    </button>
                    <button class="button" id="export-reports">
                        <span class="dashicons dashicons-download"></span> Exportieren
                    </button>
                </div>
            </div>

            <!-- Status Filter -->
            <div class="status-filter">
                <a href="?page=aukrug&tab=reports&status=all" 
                   class="filter-link <?php echo $filter_status === 'all' ? 'active' : ''; ?>">
                   Alle (<?php echo $reports['counts']['total']; ?>)
                </a>
                <a href="?page=aukrug&tab=reports&status=open" 
                   class="filter-link <?php echo $filter_status === 'open' ? 'active' : ''; ?>">
                   Offen (<?php echo $reports['counts']['open']; ?>)
                </a>
                <a href="?page=aukrug&tab=reports&status=in-progress" 
                   class="filter-link <?php echo $filter_status === 'in-progress' ? 'active' : ''; ?>">
                   In Bearbeitung (<?php echo $reports['counts']['in_progress']; ?>)
                </a>
                <a href="?page=aukrug&tab=reports&status=resolved" 
                   class="filter-link <?php echo $filter_status === 'resolved' ? 'active' : ''; ?>">
                   Gelöst (<?php echo $reports['counts']['resolved']; ?>)
                </a>
                <a href="?page=aukrug&tab=reports&status=closed" 
                   class="filter-link <?php echo $filter_status === 'closed' ? 'active' : ''; ?>">
                   Geschlossen (<?php echo $reports['counts']['closed']; ?>)
                </a>
            </div>

            <!-- Reports Table -->
            <div class="reports-table-container">
                <table class="wp-list-table widefat fixed striped reports-table">
                    <thead>
                        <tr>
                            <th scope="col" class="manage-column column-id">ID</th>
                            <th scope="col" class="manage-column column-title">Titel</th>
                            <th scope="col" class="manage-column column-category">Kategorie</th>
                            <th scope="col" class="manage-column column-priority">Priorität</th>
                            <th scope="col" class="manage-column column-status">Status</th>
                            <th scope="col" class="manage-column column-reporter">Melder</th>
                            <th scope="col" class="manage-column column-created">Erstellt</th>
                            <th scope="col" class="manage-column column-actions">Aktionen</th>
                        </tr>
                    </thead>
                    <tbody>
                        <?php foreach ($reports['items'] as $report): ?>
                        <tr data-report-id="<?php echo $report['id']; ?>">
                            <td class="column-id">
                                <strong>#<?php echo $report['id']; ?></strong>
                            </td>
                            <td class="column-title">
                                <a href="#" class="report-title" data-report-id="<?php echo $report['id']; ?>">
                                    <?php echo esc_html($report['title']); ?>
                                </a>
                                <div class="report-excerpt">
                                    <?php echo esc_html(wp_trim_words($report['description'], 10)); ?>
                                </div>
                            </td>
                            <td class="column-category">
                                <span class="category-badge category-<?php echo $report['category']; ?>">
                                    <?php echo esc_html($report['category_label']); ?>
                                </span>
                            </td>
                            <td class="column-priority">
                                <span class="priority-badge priority-<?php echo $report['priority']; ?>">
                                    <?php echo esc_html($report['priority_label']); ?>
                                </span>
                            </td>
                            <td class="column-status">
                                <select class="status-select" data-report-id="<?php echo $report['id']; ?>">
                                    <option value="open" <?php selected($report['status'], 'open'); ?>>Offen</option>
                                    <option value="in-progress" <?php selected($report['status'], 'in-progress'); ?>>In Bearbeitung</option>
                                    <option value="resolved" <?php selected($report['status'], 'resolved'); ?>>Gelöst</option>
                                    <option value="closed" <?php selected($report['status'], 'closed'); ?>>Geschlossen</option>
                                </select>
                            </td>
                            <td class="column-reporter">
                                <?php if ($report['is_anonymous']): ?>
                                    <em>Anonym</em>
                                <?php else: ?>
                                    <?php echo esc_html($report['reporter_name']); ?>
                                    <br><small><?php echo esc_html($report['reporter_email']); ?></small>
                                <?php endif; ?>
                            </td>
                            <td class="column-created">
                                <?php echo date('d.m.Y H:i', strtotime($report['created_at'])); ?>
                                <br><small><?php echo human_time_diff(strtotime($report['created_at'])); ?> ago</small>
                            </td>
                            <td class="column-actions">
                                <div class="row-actions">
                                    <a href="#" class="view-report" data-report-id="<?php echo $report['id']; ?>">Anzeigen</a> |
                                    <a href="#" class="edit-report" data-report-id="<?php echo $report['id']; ?>">Bearbeiten</a> |
                                    <a href="#" class="delete-report" data-report-id="<?php echo $report['id']; ?>">Löschen</a>
                                </div>
                            </td>
                        </tr>
                        <?php endforeach; ?>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div class="tablenav bottom">
                <div class="tablenav-pages">
                    <span class="displaying-num"><?php echo $reports['counts']['total']; ?> Einträge</span>
                    <!-- Pagination links here -->
                </div>
            </div>
        </div>

        <!-- Report Detail Modal -->
        <div id="report-modal" class="report-modal" style="display: none;">
            <div class="modal-content">
                <div class="modal-header">
                    <h3 id="modal-title">Meldung Details</h3>
                    <span class="close-modal">&times;</span>
                </div>
                <div class="modal-body" id="modal-body">
                    <!-- Report details will be loaded here -->
                </div>
                <div class="modal-footer">
                    <button class="button button-primary" id="save-report">Speichern</button>
                    <button class="button" id="close-modal">Schließen</button>
                </div>
            </div>
        </div>

        <script>
        document.addEventListener('DOMContentLoaded', function() {
            // Status change handler
            document.querySelectorAll('.status-select').forEach(select => {
                select.addEventListener('change', function() {
                    const reportId = this.dataset.reportId;
                    const newStatus = this.value;
                    updateReportStatus(reportId, newStatus);
                });
            });

            // Report detail modal
            document.querySelectorAll('.view-report, .report-title').forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    const reportId = this.dataset.reportId;
                    showReportDetails(reportId);
                });
            });

            // Close modal
            document.querySelector('.close-modal').addEventListener('click', function() {
                document.getElementById('report-modal').style.display = 'none';
            });
        });

        function updateReportStatus(reportId, status) {
            // AJAX call to update report status
            fetch(aukrug_ajax.ajax_url, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded',
                },
                body: `action=aukrug_dashboard_action&action_type=update_report_status&report_id=${reportId}&status=${status}&nonce=${aukrug_ajax.nonce}`
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // Update UI
                    location.reload(); // Temporary - should update in place
                }
            });
        }

        function showReportDetails(reportId) {
            // Load and show report details in modal
            document.getElementById('report-modal').style.display = 'block';
            // AJAX call to get report details
        }
        </script>
        <?php
    }

    /**
     * Places Tab - Orte & POIs Verwaltung
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
     * Users Tab - App Benutzer Verwaltung
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

            <!-- User List Table -->
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
     * Weitere Tab-Render-Methoden (Platzhalter)
     */
    private function render_geocaching_tab() {
        echo '<h2>GeoCaching Verwaltung</h2><p>GeoCaching-Funktionen werden hier implementiert.</p>';
    }

    private function render_community_tab() {
        echo '<h2>Community Management</h2><p>Community-Funktionen werden hier implementiert.</p>';
    }

    private function render_events_tab() {
        echo '<h2>Events & Routen</h2><p>Event- und Routen-Management wird hier implementiert.</p>';
    }

    private function render_notifications_tab() {
        echo '<h2>Push Notifications</h2><p>Notification-Management wird hier implementiert.</p>';
    }

    private function render_analytics_tab($stats) {
        echo '<h2>Analytics & Reports</h2><p>Umfassende Analytics werden hier implementiert.</p>';
    }

    private function render_settings_tab() {
        echo '<h2>Plugin Einstellungen</h2><p>Globale Plugin-Einstellungen werden hier implementiert.</p>';
    }

    /**
     * Dashboard-Statistiken holen
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
                array('time' => '2025-09-07 10:30:00', 'description' => 'Neue Meldung eingegangen: Straßenschaden'),
                array('time' => '2025-09-07 09:15:00', 'description' => 'Benutzer registriert: user_156'),
                array('time' => '2025-09-07 08:45:00', 'description' => 'GeoCaching-Fund gemeldet'),
                array('time' => '2025-09-06 16:20:00', 'description' => 'POI aktualisiert: Café am Teich'),
            )
        );
    }

    /**
     * Reports-Daten holen (Mock-Daten für Ticket-System)
     */
    private function get_reports_data() {
        return array(
            'counts' => array(
                'total' => 25,
                'open' => 8,
                'in_progress' => 5,
                'resolved' => 10,
                'closed' => 2
            ),
            'items' => array(
                array(
                    'id' => 1,
                    'title' => 'Straßenschaden Hauptstraße',
                    'description' => 'Großes Schlagloch in der Hauptstraße vor dem Supermarkt. Gefährlich für Radfahrer.',
                    'category' => 'infrastructure',
                    'category_label' => 'Infrastruktur',
                    'priority' => 'high',
                    'priority_label' => 'Hoch',
                    'status' => 'open',
                    'is_anonymous' => false,
                    'reporter_name' => 'Max Mustermann',
                    'reporter_email' => 'max@example.com',
                    'created_at' => '2025-09-07 09:30:00'
                ),
                array(
                    'id' => 2,
                    'title' => 'Defekte Straßenlaterne',
                    'description' => 'Straßenlaterne am Dorfplatz funktioniert nicht mehr.',
                    'category' => 'lighting',
                    'category_label' => 'Beleuchtung',
                    'priority' => 'medium',
                    'priority_label' => 'Mittel',
                    'status' => 'in-progress',
                    'is_anonymous' => true,
                    'reporter_name' => '',
                    'reporter_email' => '',
                    'created_at' => '2025-09-06 14:15:00'
                )
            )
        );
    }

    /**
     * Places-Daten holen
     */
    private function get_places_data() {
        return array(
            array(
                'id' => 'place_001',
                'name' => 'Naturpark Aukrug',
                'description' => 'Wunderschöner Naturpark mit vielfältigen Wanderwegen und beeindruckender Flora und Fauna.',
                'category' => 'Natur',
                'rating' => 5,
                'visits' => 1250,
                'is_active' => true,
                'image' => 'https://picsum.photos/300/200?random=1'
            ),
            array(
                'id' => 'place_002',
                'name' => 'Gasthof Zur Linde',
                'description' => 'Traditioneller Gasthof mit regionaler Küche und gemütlicher Atmosphäre.',
                'category' => 'Gastronomie',
                'rating' => 4,
                'visits' => 890,
                'is_active' => true,
                'image' => 'https://picsum.photos/300/200?random=2'
            )
        );
    }

    /**
     * App-Benutzer-Daten holen
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
     * Dashboard-Aktionen verarbeiten
     */
    private function process_dashboard_actions($tab) {
        // Action processing logic here
    }

    /**
     * AJAX Actions verarbeiten
     */
    public function handle_ajax_actions() {
        check_ajax_referer('aukrug_dashboard_nonce', 'nonce');
        
        $action = sanitize_text_field($_POST['action_type']);
        
        switch ($action) {
            case 'update_report_status':
                // Handle report status update
                wp_send_json_success(['message' => 'Status updated']);
                break;
            
            default:
                wp_send_json_error('Unknown action');
        }
    }
}

// Dashboard wird nur in wpaukrug.php initialisiert
// Nicht hier!
