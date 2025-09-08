<?php
/**
 * DEPRECATED - Altes Dashboard - wird nicht mehr verwendet
 * Neues Dashboard: aukrug-dashboard-new.php
 */

// Verhindere direkten Zugriff
if (!defined('ABSPATH')) {
    exit;
}

class Aukrug_Dashboard_OLD_DEPRECATED {
    
    public function __construct() {
        add_action('admin_menu', array($this, 'add_admin_menu'));
        add_action('admin_enqueue_scripts', array($this, 'enqueue_admin_assets'));
        add_action('wp_ajax_aukrug_dashboard_action', array($this, 'handle_ajax_actions'));
    }
    
    /**
     * Admin-Menü mit umfassenden Panels hinzufügen
     */
    public function add_admin_menu() {
        // Hauptmenü-Seite mit der richtigen Slug und niedrigerer Berechtigung
        add_menu_page(
            'Aukrug Connect',
            'Aukrug Connect',
            'edit_posts', // Niedrigere Berechtigung als manage_options
            'aukrug',
            array($this, 'main_dashboard_page'),
            'dashicons-location-alt',
            25
        );
        
        // Dashboard Submenu
        add_submenu_page(
            'aukrug',
            'Dashboard',
            'Dashboard',
            'edit_posts',
            'aukrug',
            array($this, 'main_dashboard_page')
        );
        
        // GeoCaching Verwaltung
        add_submenu_page(
            'aukrug',
            'GeoCaching',
            'GeoCaching',
            'edit_posts',
            'aukrug-geocaching',
            array($this, 'geocaching_page')
        );
        
        // Benutzer Verwaltung (unabhängig)
        add_submenu_page(
            'aukrug',
            'App Benutzer',
            'App Benutzer',
            'edit_posts',
            'aukrug-users',
            array($this, 'users_page')
        );
        
        // Karten Verwaltung
        add_submenu_page(
            'aukrug',
            'Karten & Navigation',
            'Karten & Navigation',
            'edit_posts',
            'aukrug-maps',
            array($this, 'maps_page')
        );
        
        // Events & Routen
        add_submenu_page(
            'aukrug',
            'Events & Routen',
            'Events & Routen',
            'edit_posts',
            'aukrug-events',
            array($this, 'events_page')
        );
        
        // Community Management
        add_submenu_page(
            'aukrug',
            'Community',
            'Community',
            'edit_posts',
            'aukrug-community',
            array($this, 'community_page')
        );
        
        // Push Notifications
        add_submenu_page(
            'aukrug',
            'Notifications',
            'Notifications',
            'edit_posts',
            'aukrug-notifications',
            array($this, 'notifications_page')
        );
        
        // API & Settings
        add_submenu_page(
            'aukrug',
            'API & Einstellungen',
            'API & Einstellungen',
            'edit_posts',
            'aukrug-api',
            array($this, 'api_page')
        );
        
        // Analytics & Reports
        add_submenu_page(
            'aukrug',
            'Analytics & Reports',
            'Analytics & Reports',
            'edit_posts',
            'aukrug-analytics',
            array($this, 'analytics_page')
        );
    }
    
    /**
     * Admin Assets laden - Deaktiviert, da von wpaukrug.php geladen
     */
    public function enqueue_admin_assets($hook) {
        // Assets werden bereits von wpaukrug.php geladen
        // Nur Ajax-Daten hinzufügen
        if (strpos($hook, 'aukrug') === false) {
            return;
        }
        
        // Ajax Nonce für Dashboard-AJAX-Calls
        wp_localize_script('aukrug-admin', 'aukrug_ajax', array(
            'nonce' => wp_create_nonce('aukrug_dashboard_nonce'),
            'ajax_url' => admin_url('admin-ajax.php')
        ));
    }
    
    /**
     * Haupt-Dashboard mit Tab-Navigation
     */
    public function main_dashboard_page() {
        $current_tab = isset($_GET['tab']) ? sanitize_text_field($_GET['tab']) : 'overview';
        
        // Actions verarbeiten
        if ($_POST && wp_verify_nonce($_POST['aukrug_nonce'], 'aukrug_dashboard')) {
            $this->handle_form_actions($current_tab);
        }
        
        ?>
        <div class="wrap aukrug-dashboard">
            <h1>
                <span class="dashicons dashicons-location-alt"></span>
                Aukrug Connect Dashboard
                <span class="version-badge">v<?php echo AU_PLUGIN_VERSION; ?></span>
            </h1>
            
            <div class="nav-tab-wrapper">
                <a href="?page=aukrug-dashboard&tab=overview" 
                   class="nav-tab <?php echo ($current_tab === 'overview') ? 'nav-tab-active' : ''; ?>">
                   <span class="dashicons dashicons-dashboard"></span>
                   Übersicht
                </a>
                <a href="?page=aukrug-dashboard&tab=kpis" 
                   class="nav-tab <?php echo ($current_tab === 'kpis') ? 'nav-tab-active' : ''; ?>">
                   <span class="dashicons dashicons-chart-area"></span>
                   KPIs & Statistiken
                </a>
                <a href="?page=aukrug-dashboard&tab=app-status" 
                   class="nav-tab <?php echo ($current_tab === 'app-status') ? 'nav-tab-active' : ''; ?>">
                   <span class="dashicons dashicons-smartphone"></span>
                   App Status
                </a>
                <a href="?page=aukrug-dashboard&tab=system-health" 
                   class="nav-tab <?php echo ($current_tab === 'system-health') ? 'nav-tab-active' : ''; ?>">
                   <span class="dashicons dashicons-heart"></span>
                   System Health
                </a>
                <a href="?page=aukrug-dashboard&tab=quick-actions" 
                   class="nav-tab <?php echo ($current_tab === 'quick-actions') ? 'nav-tab-active' : ''; ?>">
                   <span class="dashicons dashicons-admin-tools"></span>
                   Quick Actions
                </a>
            </div>
            
            <div class="aukrug-tab-content">
                <?php
                switch ($current_tab) {
                    case 'overview':
                        $this->render_overview_tab();
                        break;
                    case 'kpis':
                        $this->render_kpis_tab();
                        break;
                    case 'app-status':
                        $this->render_app_status_tab();
                        break;
                    case 'system-health':
                        $this->render_system_health_tab();
                        break;
                    case 'quick-actions':
                        $this->render_quick_actions_tab();
                        break;
                    default:
                        $this->render_overview_tab();
                }
                ?>
            </div>
        </div>
        <?php
    }
    
    /**
     * Übersicht Tab - Dashboard KPIs und wichtige Metriken
     */
    private function render_overview_tab() {
        global $wpdb;
        
        // Statistiken sammeln
        $stats = $this->get_dashboard_stats();
        
        ?>
        <div class="aukrug-dashboard-grid">
            <!-- KPI Cards -->
            <div class="kpi-cards-row">
                <div class="kpi-card users">
                    <div class="kpi-icon">
                        <span class="dashicons dashicons-groups"></span>
                    </div>
                    <div class="kpi-content">
                        <h3>App Benutzer</h3>
                        <div class="kpi-value"><?php echo number_format($stats['app_users']); ?></div>
                        <div class="kpi-change positive">+<?php echo $stats['new_users_week']; ?> diese Woche</div>
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
                
                <div class="kpi-card geocaches">
                    <div class="kpi-icon">
                        <span class="dashicons dashicons-location-alt"></span>
                    </div>
                    <div class="kpi-content">
                        <h3>GeoCaches</h3>
                        <div class="kpi-value"><?php echo number_format($stats['total_geocaches']); ?></div>
                        <div class="kpi-change positive"><?php echo $stats['found_this_week']; ?> gefunden</div>
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
            
            <!-- Charts and Detailed Info -->
            <div class="dashboard-panels">
                <div class="panel-left">
                    <div class="dashboard-panel">
                        <h3><span class="dashicons dashicons-chart-line"></span> Benutzeraktivität (7 Tage)</h3>
                        <canvas id="userActivityChart" width="400" height="200"></canvas>
                    </div>
                    
                    <div class="dashboard-panel">
                        <h3><span class="dashicons dashicons-location"></span> Beliebte Orte</h3>
                        <div class="popular-places-list">
                            <?php foreach ($stats['popular_places'] as $place): ?>
                                <div class="place-item">
                                    <span class="place-name"><?php echo esc_html($place['name']); ?></span>
                                    <span class="place-visits"><?php echo $place['visits']; ?> Besuche</span>
                                </div>
                            <?php endforeach; ?>
                        </div>
                    </div>
                </div>
                
                <div class="panel-right">
                    <div class="dashboard-panel">
                        <h3><span class="dashicons dashicons-admin-network"></span> System Status</h3>
                        <div class="status-grid">
                            <div class="status-item <?php echo $stats['api_status'] ? 'status-ok' : 'status-error'; ?>">
                                <span class="status-indicator"></span>
                                <span>API Service</span>
                                <span class="status-value"><?php echo $stats['api_status'] ? 'Online' : 'Offline'; ?></span>
                            </div>
                            <div class="status-item <?php echo $stats['db_status'] ? 'status-ok' : 'status-error'; ?>">
                                <span class="status-indicator"></span>
                                <span>Datenbank</span>
                                <span class="status-value"><?php echo $stats['db_status'] ? 'OK' : 'Fehler'; ?></span>
                            </div>
                            <div class="status-item status-ok">
                                <span class="status-indicator"></span>
                                <span>WordPress</span>
                                <span class="status-value">OK</span>
                            </div>
                        </div>
                    </div>
                    
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
        </div>
        
        <script>
        // Chart.js initialization
        document.addEventListener('DOMContentLoaded', function() {
            const ctx = document.getElementById('userActivityChart').getContext('2d');
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
                    scales: {
                        y: {
                            beginAtZero: true
                        }
                    }
                }
            });
        });
        </script>
        <?php
    }
    
    /**
     * Dashboard-Statistiken sammeln
     */
    private function get_dashboard_stats() {
        global $wpdb;
        
        // Mock-Daten für Demo - In Produktion aus echten Tabellen
        return array(
            'app_users' => 156,
            'new_users_week' => 12,
            'total_places' => $wpdb->get_var("SELECT COUNT(*) FROM {$wpdb->prefix}aukrug_discover_items"),
            'active_places' => $wpdb->get_var("SELECT COUNT(*) FROM {$wpdb->prefix}aukrug_discover_items WHERE is_featured = 1"),
            'total_geocaches' => 24,
            'found_this_week' => 8,
            'api_calls_today' => 1247,
            'api_status' => true,
            'db_status' => true,
            'popular_places' => array(
                array('name' => 'Naturpark Aukrug', 'visits' => 89),
                array('name' => 'Gut Altenkrempe', 'visits' => 67),
                array('name' => 'Klettergarten Aukrug', 'visits' => 45),
                array('name' => 'Gasthof Zur Linde', 'visits' => 34),
                array('name' => 'Aukruger Waldmuseum', 'visits' => 28)
            ),
            'recent_activities' => array(
                array('time' => '2025-09-07 10:30:00', 'description' => 'Neuer GeoCaches hinzugefügt: Waldrätsel #12'),
                array('time' => '2025-09-07 09:15:00', 'description' => 'Benutzer "HikerMax" hat Level 5 erreicht'),
                array('time' => '2025-09-07 08:45:00', 'description' => 'API-Endpunkt /places wurde 89x aufgerufen'),
                array('time' => '2025-09-07 08:20:00', 'description' => 'Neue Push-Notification versendet: Event-Erinnerung')
            ),
            'activity_labels' => array('Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'),
            'activity_data' => array(45, 52, 48, 61, 55, 67, 73)
        );
    }
    
    // Weitere Tab-Methoden werden in separaten Methoden implementiert...
    // (Für Kürze hier nicht alle ausgeschrieben)
    
    private function render_kpis_tab() {
        echo '<div class="aukrug-panel"><h2>Detaillierte KPIs & Analytics</h2><p>Erweiterte Statistiken und Metriken...</p></div>';
    }
    
    private function render_app_status_tab() {
        echo '<div class="aukrug-panel"><h2>App Status & Verbindungen</h2><p>Status der mobilen Apps und API-Verbindungen...</p></div>';
    }
    
    private function render_system_health_tab() {
        echo '<div class="aukrug-panel"><h2>System Health Check</h2><p>System-Diagnose und Gesundheitschecks...</p></div>';
    }
    
    private function render_quick_actions_tab() {
        echo '<div class="aukrug-panel"><h2>Quick Actions</h2><p>Schnelle Aktionen und Tools...</p></div>';
    }
    
    /**
     * Form Actions verarbeiten
     */
    private function handle_form_actions($tab) {
        // Form-Verarbeitung für verschiedene Tabs
        switch ($tab) {
            case 'overview':
                // Dashboard-Aktionen
                break;
            case 'settings':
                // Einstellungen speichern
                break;
        }
    }
    
    /**
     * AJAX Actions verarbeiten
     */
    public function handle_ajax_actions() {
        check_ajax_referer('aukrug_dashboard_nonce', 'nonce');
        
        $action = sanitize_text_field($_POST['action_type']);
        
        switch ($action) {
            case 'refresh_stats':
                $stats = $this->get_dashboard_stats();
                wp_send_json_success($stats);
                break;
            
            case 'quick_action':
                $result = $this->process_quick_action($_POST['quick_action']);
                wp_send_json_success($result);
                break;
                
            default:
                wp_send_json_error('Unknown action');
        }
    }
    
    // GeoCaching Verwaltung
    public function geocaching_page() {
        echo '<div class="wrap"><h1>GeoCaching Verwaltung</h1>';
        echo '<p>Umfassende Verwaltung aller GeoCaching-Features...</p>';
        echo '</div>';
    }
    
    // App Benutzer Verwaltung (unabhängig von WordPress)
    public function users_page() {
        echo '<div class="wrap"><h1>App Benutzer Verwaltung</h1>';
        echo '<p>Eigenständige Benutzerverwaltung mit optionaler WordPress-Integration...</p>';
        echo '</div>';
    }
    
    // Weitere Seiten...
    public function maps_page() {
        echo '<div class="wrap"><h1>Karten & Navigation</h1><p>Kartenverwaltung...</p></div>';
    }
    
    public function events_page() {
        echo '<div class="wrap"><h1>Events & Routen</h1><p>Event- und Routenverwaltung...</p></div>';
    }
    
    public function community_page() {
        echo '<div class="wrap"><h1>Community Management</h1><p>Community-Features...</p></div>';
    }
    
    public function notifications_page() {
        echo '<div class="wrap"><h1>Push Notifications</h1><p>Notification-Management...</p></div>';
    }
    
    public function api_page() {
        echo '<div class="wrap"><h1>API & Einstellungen</h1><p>API-Konfiguration...</p></div>';
    }
    
    public function analytics_page() {
        echo '<div class="wrap"><h1>Analytics & Reports</h1><p>Detaillierte Berichte...</p></div>';
    }
}

// DEPRECATED - Dashboard wird nicht mehr initialisiert
// Neues Dashboard wird in aukrug-dashboard-new.php initialisiert
// new Aukrug_Dashboard_OLD_DEPRECATED();
