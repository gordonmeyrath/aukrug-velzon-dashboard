<?php
/**
 * Modern Admin Dashboard Page
 * Aukrug Plugin - MioConneX-level polish
 */

// Security check
if (!current_user_can('manage_options')) {
    wp_die(__('Sie haben keine Berechtigung für diese Seite.'));
}
?>

<div id="au-admin-app" class="au-container">
    <!-- Topbar -->
    <div class="au-topbar">
        <h1>Aukrug Dashboard</h1>
        <div class="au-flex au-gap-4">
            <span class="au-version">v<?php echo defined('AUKRUG_CONNECT_VERSION') ? AUKRUG_CONNECT_VERSION : '1.0.0'; ?></span>
            <div class="au-status online" id="health-status">
                <div class="status-indicator"></div>
                System wird geprüft...
            </div>
        </div>
    </div>

    <!-- Tab Navigation -->
    <nav class="au-tabs">
        <button data-tab="overview" class="is-active">Übersicht</button>
        <button data-tab="community">Community</button>
        <button data-tab="geocaching">Geocaching</button>
        <button data-tab="appcaches">App-Caches</button>
        <button data-tab="reports">Meldungen</button>
        <button data-tab="devices">Geräte</button>
        <button data-tab="sync">Synchronisation</button>
        <button data-tab="settings">Einstellungen</button>
    </nav>

    <!-- Overview Tab -->
    <div data-tab-content="overview">
        <!-- KPI Grid -->
        <div class="au-kpi-grid" id="kpis-container">
            <div class="au-kpi">
                <span class="au-kpi-value">-</span>
                <span class="au-kpi-label">Wird geladen...</span>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="au-quick-actions">
            <button class="au-btn au-btn-primary">
                <span>🔄</span> Daten aktualisieren
            </button>
            <button class="au-btn au-btn-ghost">
                <span>📊</span> Vollständiger Bericht
            </button>
            <button class="au-btn au-btn-ghost">
                <span>⚙️</span> System-Check
            </button>
        </div>

        <!-- Recent Activity -->
        <div class="au-card">
            <h2>Letzte Aktivitäten</h2>
            <div id="recent-activity">
                <p class="au-text-muted">Aktivitäten werden geladen...</p>
            </div>
        </div>
    </div>

    <!-- Community Tab -->
    <div data-tab-content="community" style="display: none;">
        <div class="au-card">
            <h2>Community Verwaltung</h2>
            
            <!-- Community Stats -->
            <div class="au-kpi-grid" id="community-stats">
                <div class="au-kpi">
                    <span class="au-kpi-value" id="total-members">-</span>
                    <span class="au-kpi-label">Mitglieder</span>
                </div>
                <div class="au-kpi">
                    <span class="au-kpi-value" id="active-members">-</span>
                    <span class="au-kpi-label">Aktive Mitglieder</span>
                </div>
                <div class="au-kpi">
                    <span class="au-kpi-value" id="new-members">-</span>
                    <span class="au-kpi-label">Neue (30 Tage)</span>
                </div>
            </div>

            <!-- Member Management -->
            <div class="au-flex au-gap-4 au-mb-4">
                <button class="au-btn au-btn-primary">Neues Mitglied</button>
                <button class="au-btn au-btn-ghost">Export CSV</button>
                <div class="au-segmented">
                    <button class="active">Alle</button>
                    <button>Aktiv</button>
                    <button>Inaktiv</button>
                </div>
            </div>

            <div id="community-table">
                <p class="au-text-muted">Mitglieder werden geladen...</p>
            </div>
        </div>
    </div>

    <!-- Geocaching Tab -->
    <div data-tab-content="geocaching" style="display: none;">
        <div class="au-card">
            <h2>Geocaching Verwaltung</h2>
            
            <!-- Geocaching Stats -->
            <div class="au-kpi-grid" id="geocaching-stats">
                <div class="au-kpi">
                    <span class="au-kpi-value" id="total-caches">-</span>
                    <span class="au-kpi-label">Geocaches</span>
                </div>
                <div class="au-kpi">
                    <span class="au-kpi-value" id="active-caches">-</span>
                    <span class="au-kpi-label">Aktive Caches</span>
                </div>
                <div class="au-kpi">
                    <span class="au-kpi-value" id="archived-caches">-</span>
                    <span class="au-kpi-label">Archiviert</span>
                </div>
            </div>

            <!-- Map -->
            <div class="au-card au-mb-4">
                <h3>Karte</h3>
                <div id="geocaching-map" class="au-map"></div>
            </div>

            <!-- Cache Table -->
            <div id="geocaching-table">
                <p class="au-text-muted">Geocaches werden geladen...</p>
            </div>
        </div>
    </div>

    <!-- App-Only Caches Tab -->
    <div data-tab-content="appcaches" style="display: none;">
        <div class="au-card">
            <h2>App-Only Caches</h2>
            
            <div class="au-flex au-gap-4 au-mb-4">
                <button class="au-btn au-btn-primary">Neuen Cache erstellen</button>
                <button class="au-btn au-btn-ghost">Import von GPX</button>
            </div>

            <div id="appcaches-table">
                <p class="au-text-muted">App-Caches werden geladen...</p>
            </div>
        </div>
    </div>

    <!-- Reports Tab -->
    <div data-tab-content="reports" style="display: none;">
        <!-- Meldungsübersicht -->
        <div id="reports-overview" class="au-card">
            <div class="au-flex au-justify-between au-items-center au-mb-6">
                <h2>Bürgermeldungen</h2>
                <div class="au-flex au-gap-2">
                    <button class="au-btn au-btn-ghost" onclick="exportReports()">
                        📊 CSV Export
                    </button>
                    <button class="au-btn au-btn-ghost" onclick="showTimeSeries()">
                        📈 Zeitreihen
                    </button>
                    <button class="au-btn au-btn-primary" onclick="refreshReports()">
                        🔄 Aktualisieren
                    </button>
                </div>
            </div>
            
            <!-- Reports Stats -->
            <div class="au-kpi-grid" id="reports-stats">
                <div class="au-kpi">
                    <span class="au-kpi-value" id="total-reports">-</span>
                    <span class="au-kpi-label">Gesamt</span>
                </div>
                <div class="au-kpi">
                    <span class="au-kpi-value" id="open-reports">-</span>
                    <span class="au-kpi-label">Offen</span>
                </div>
                <div class="au-kpi">
                    <span class="au-kpi-value" id="urgent-reports">-</span>
                    <span class="au-kpi-label">Dringend</span>
                </div>
                <div class="au-kpi">
                    <span class="au-kpi-value" id="resolved-reports">-</span>
                    <span class="au-kpi-label">Gelöst</span>
                </div>
            </div>

            <!-- Filter & Actions -->
            <div class="au-reports-controls au-flex au-gap-4 au-mb-4">
                <div class="au-flex au-gap-2">
                    <select id="status-filter" class="au-select">
                        <option value="">Alle Status</option>
                        <option value="open">Offen</option>
                        <option value="in_progress">In Bearbeitung</option>
                        <option value="resolved">Gelöst</option>
                        <option value="closed">Geschlossen</option>
                    </select>
                    <select id="category-filter" class="au-select">
                        <option value="">Alle Kategorien</option>
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
                    <select id="priority-filter" class="au-select">
                        <option value="">Alle Prioritäten</option>
                        <option value="low">Niedrig</option>
                        <option value="normal">Normal</option>
                        <option value="high">Hoch</option>
                        <option value="urgent">Dringend</option>
                    </select>
                </div>
                <div class="au-flex au-gap-2">
                    <input type="date" id="date-from" class="au-input" placeholder="Von">
                    <input type="date" id="date-to" class="au-input" placeholder="Bis">
                    <button class="au-btn au-btn-ghost" onclick="applyFilters()">Filtern</button>
                    <button class="au-btn au-btn-ghost" onclick="clearFilters()">Zurücksetzen</button>
                </div>
            </div>

            <!-- Bulk Actions -->
            <div class="au-bulk-actions" id="bulk-actions" style="display: none;">
                <div class="au-flex au-gap-2 au-items-center">
                    <span>Ausgewählte Meldungen:</span>
                    <select id="bulk-status" class="au-select">
                        <option value="">Status ändern...</option>
                        <option value="in_progress">In Bearbeitung setzen</option>
                        <option value="resolved">Als gelöst markieren</option>
                        <option value="closed">Schließen</option>
                    </select>
                    <select id="bulk-priority" class="au-select">
                        <option value="">Priorität ändern...</option>
                        <option value="low">Niedrig</option>
                        <option value="normal">Normal</option>
                        <option value="high">Hoch</option>
                        <option value="urgent">Dringend</option>
                    </select>
                    <button class="au-btn au-btn-primary" onclick="applyBulkActions()">Anwenden</button>
                    <button class="au-btn au-btn-ghost" onclick="clearSelection()">Abbrechen</button>
                </div>
            </div>

            <!-- Reports Table -->
            <div class="au-table-container">
                <table class="au-table" id="reports-table">
                    <thead>
                        <tr>
                            <th><input type="checkbox" id="select-all-reports" onchange="toggleAllReports()"></th>
                            <th>ID</th>
                            <th>Titel</th>
                            <th>Kategorie</th>
                            <th>Priorität</th>
                            <th>Status</th>
                            <th>Zugewiesen</th>
                            <th>Erstellt</th>
                            <th>Aktionen</th>
                        </tr>
                    </thead>
                    <tbody id="reports-tbody">
                        <tr>
                            <td colspan="9" class="au-text-center au-text-muted">Meldungen werden geladen...</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Detailansicht Modal -->
        <div id="report-detail-modal" class="au-modal" style="display: none;">
            <div class="au-modal-content au-modal-large">
                <div class="au-modal-header">
                    <h3 id="report-detail-title">Meldungsdetails</h3>
                    <button class="au-modal-close" onclick="closeReportDetail()">×</button>
                </div>
                <div class="au-modal-body">
                    <div class="au-report-detail" id="report-detail-content">
                        <!-- Wird dynamisch gefüllt -->
                    </div>
                </div>
            </div>
        </div>

        <!-- Zeitreihen Modal -->
        <div id="timeseries-modal" class="au-modal" style="display: none;">
            <div class="au-modal-content">
                <div class="au-modal-header">
                    <h3>Meldungen Zeitreihen</h3>
                    <button class="au-modal-close" onclick="closeTimeSeries()">×</button>
                </div>
                <div class="au-modal-body">
                    <div class="au-flex au-gap-4 au-mb-4">
                        <label>
                            Zeitraum:
                            <select id="timeseries-days" onchange="updateTimeSeries()">
                                <option value="7">7 Tage</option>
                                <option value="30" selected>30 Tage</option>
                                <option value="90">90 Tage</option>
                            </select>
                        </label>
                    </div>
                    <canvas id="timeseries-chart" width="400" height="200"></canvas>
                </div>
            </div>
        </div>
    </div>

    <!-- Devices Tab -->
    <div data-tab-content="devices" style="display: none;">
        <div class="au-card">
            <h2>Registrierte Geräte</h2>
            
            <div class="au-flex au-gap-4 au-mb-4">
                <div class="au-segmented">
                    <button class="active">Alle Geräte</button>
                    <button>iOS</button>
                    <button>Android</button>
                </div>
                <button class="au-btn au-btn-ghost">Push-Benachrichtigung</button>
            </div>

            <div id="devices-table">
                <p class="au-text-muted">Geräte werden geladen...</p>
            </div>
        </div>
    </div>

    <!-- Sync Tab -->
    <div data-tab-content="sync" style="display: none;">
        <div id="sync-status">
            <p class="au-text-muted">Sync-Status wird geladen...</p>
        </div>

        <div class="au-card">
            <h3>Sync-Protokoll</h3>
            <div id="sync-logs">
                <p class="au-text-muted">Protokoll wird geladen...</p>
            </div>
        </div>
    </div>

    <!-- Settings Tab -->
    <div data-tab-content="settings" style="display: none;">
        <div id="settings-container">
            <!-- Settings werden dynamisch von JavaScript geladen -->
            <div class="au-card">
                <div class="au-loading">Einstellungen werden geladen...</div>
            </div>
        </div>
    </div>
</div>

<!-- Include external dependencies -->
<script src="https://unpkg.com/chart.js@4.4.0/dist/chart.umd.js"></script>
<script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"></script>
<link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css" />

<script>
// WordPress API settings for the dashboard
const wpApiSettings = {
    nonce: '<?php echo wp_create_nonce('wp_rest'); ?>',
    root: '<?php echo esc_url_raw(rest_url()); ?>'
};
</script>
