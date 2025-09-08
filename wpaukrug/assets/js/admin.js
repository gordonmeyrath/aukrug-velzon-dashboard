/**
 * Aukrug Admin - Modern SPA Dashboard
 * Comprehensive dashboard with MioConneX-level polish
 */

class AukrugDashboard {
    constructor() {
        this.currentTab = 'overview';
        this.cache = new Map();
        this.ws = null;
        this.init();
    }

    init() {
        this.setupRouter();
        this.setupEventListeners();
        this.loadInitialData();
        this.initWebSocket();
        this.showTab('overview');
    }

    setupRouter() {
        window.addEventListener('hashchange', () => {
            const hash = window.location.hash.slice(1);
            if (hash && hash !== this.currentTab) {
                this.showTab(hash);
            }
        });
    }

    setupEventListeners() {
        // Tab navigation
        document.querySelectorAll('.au-tabs button').forEach(btn => {
            btn.addEventListener('click', (e) => {
                const tab = e.target.dataset.tab;
                this.showTab(tab);
                window.location.hash = tab;
            });
        });

        // Auto-refresh toggle
        document.addEventListener('change', (e) => {
            if (e.target.id === 'auto-refresh') {
                this.toggleAutoRefresh(e.target.checked);
            }
        });
    }

    async showTab(tabName) {
        // Update active tab
        document.querySelectorAll('.au-tabs button').forEach(btn => {
            btn.classList.toggle('is-active', btn.dataset.tab === tabName);
        });

        // Hide all content
        document.querySelectorAll('[data-tab-content]').forEach(content => {
            content.style.display = 'none';
        });

        // Show selected content
        const content = document.querySelector(`[data-tab-content="${tabName}"]`);
        if (content) {
            content.style.display = 'block';
            this.currentTab = tabName;
            await this.loadTabData(tabName);
        }
    }

    async loadTabData(tabName) {
        this.showLoading(tabName);

        try {
            switch (tabName) {
                case 'overview':
                    await this.loadOverview();
                    break;
                case 'community':
                    await this.loadCommunity();
                    break;
                case 'geocaching':
                    await this.loadGeocaching();
                    break;
                case 'appcaches':
                    await this.loadAppCaches();
                    break;
                case 'reports':
                    await this.loadReports();
                    break;
                case 'devices':
                    await this.loadDevices();
                    break;
                case 'sync':
                    await this.loadSync();
                    break;
                case 'settings':
                    await this.loadSettings();
                    break;
            }
        } catch (error) {
            this.showError(tabName, error.message);
        } finally {
            this.hideLoading(tabName);
        }
    }

    async loadOverview() {
        const [kpis, health, recent] = await Promise.all([
            this.apiCall('/wp-json/aukrug/v1/kpis'),
            this.apiCall('/wp-json/aukrug/v1/health'),
            this.apiCall('/wp-json/aukrug/v1/recent-activity')
        ]);

        this.renderKPIs(kpis);
        this.renderHealthStatus(health);
        this.renderRecentActivity(recent);
    }

    async loadCommunity() {
        const [members, posts, events] = await Promise.all([
            this.apiCall('/wp-json/aukrug/v1/community/members'),
            this.apiCall('/wp-json/aukrug/v1/community/posts'),
            this.apiCall('/wp-json/aukrug/v1/community/events')
        ]);

        this.renderCommunityStats(members, posts, events);
        this.renderCommunityTable(members);
    }

    async loadGeocaching() {
        const [caches, stats] = await Promise.all([
            this.apiCall('/wp-json/aukrug/v1/geocaching/caches'),
            this.apiCall('/wp-json/aukrug/v1/geocaching/stats')
        ]);

        this.renderGeocachingStats(stats);
        this.renderGeocachingTable(caches);
        this.initGeocachingMap(caches);
    }

    async loadAppCaches() {
        const caches = await this.apiCall('/wp-json/aukrug/v1/appcaches');
        this.renderAppCachesTable(caches);
    }

    async loadReports() {
        const [reports, stats] = await Promise.all([
            this.apiCall('/wp-json/aukrug/v1/reports'),
            this.apiCall('/wp-json/aukrug/v1/reports/stats')
        ]);

        this.renderReportsStats(stats);
        this.renderReportsTable(reports);
    }

    async loadDevices() {
        const devices = await this.apiCall('/wp-json/aukrug/v1/devices');
        this.renderDevicesTable(devices);
    }

    async loadSync() {
        const [status, logs] = await Promise.all([
            this.apiCall('/wp-json/aukrug/v1/sync/status'),
            this.apiCall('/wp-json/aukrug/v1/sync/logs')
        ]);

        this.renderSyncStatus(status);
        this.renderSyncLogs(logs);
    }

    async loadSettings() {
        const settings = await this.apiCall('/wp-json/aukrug/v1/settings');
        this.renderSettings(settings);
    }

    renderSettings(settings) {
        const container = document.getElementById('settings-container');
        if (!container) return;

        container.innerHTML = `
            <div class="au-card">
                <h3>API Einstellungen</h3>
                <form id="settings-form" class="au-form">
                    <div class="au-form-group">
                        <label>API Endpoint:</label>
                        <input type="url" name="api_endpoint" value="${settings.api_endpoint || ''}" 
                               placeholder="https://api.example.com" />
                    </div>
                    <div class="au-form-group">
                        <label>API Key:</label>
                        <input type="password" name="api_key" value="${settings.api_key || ''}" 
                               placeholder="Geben Sie Ihren API-Key ein" />
                    </div>
                    
                    <h4>Synchronisation</h4>
                    <div class="au-form-group">
                        <label>
                            <input type="checkbox" name="auto_sync" ${settings.auto_sync ? 'checked' : ''} />
                            Automatische Synchronisation
                        </label>
                    </div>
                    <div class="au-form-group">
                        <label>Sync-Intervall (Minuten):</label>
                        <input type="number" name="sync_interval" value="${settings.sync_interval || 15}" 
                               min="1" max="1440" />
                    </div>
                    
                    <h4>Benachrichtigungen</h4>
                    <div class="au-form-group">
                        <label>
                            <input type="checkbox" name="email_notifications" ${settings.email_notifications ? 'checked' : ''} />
                            E-Mail Benachrichtigungen
                        </label>
                    </div>
                    <div class="au-form-group">
                        <label>
                            <input type="checkbox" name="push_notifications" ${settings.push_notifications ? 'checked' : ''} />
                            Push Benachrichtigungen
                        </label>
                    </div>
                    
                    <h4>System</h4>
                    <div class="au-form-group">
                        <label>
                            <input type="checkbox" name="debug_mode" ${settings.debug_mode ? 'checked' : ''} />
                            Debug Modus
                        </label>
                    </div>
                    <div class="au-form-group">
                        <label>
                            <input type="checkbox" name="cache_enabled" ${settings.cache_enabled ? 'checked' : ''} />
                            Cache aktiviert
                        </label>
                    </div>
                    <div class="au-form-group">
                        <label>Cache TTL (Sekunden):</label>
                        <input type="number" name="cache_ttl" value="${settings.cache_ttl || 300}" 
                               min="60" max="3600" />
                    </div>
                    
                    <div class="au-form-actions">
                        <button type="submit" class="au-btn au-btn-primary">Einstellungen speichern</button>
                        <button type="button" class="au-btn au-btn-secondary" onclick="window.dashboard.resetSettings()">
                            Zurücksetzen
                        </button>
                    </div>
                </form>
            </div>
        `;

        // Form submit handler
        document.getElementById('settings-form').addEventListener('submit', async (e) => {
            e.preventDefault();
            await this.saveSettings(new FormData(e.target));
        });
    }

    async saveSettings(formData) {
        try {
            const settings = {};
            for (let [key, value] of formData.entries()) {
                if (key.includes('_checkbox') || value === 'on') {
                    settings[key] = true;
                } else if (key.includes('_number')) {
                    settings[key] = parseInt(value);
                } else {
                    settings[key] = value;
                }
            }

            // Handle checkboxes that weren't checked
            ['auto_sync', 'email_notifications', 'push_notifications', 'debug_mode', 'cache_enabled'].forEach(field => {
                if (!formData.has(field)) {
                    settings[field] = false;
                }
            });

            await fetch('/wp-json/aukrug/v1/settings', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-WP-Nonce': wpApiSettings.nonce
                },
                body: JSON.stringify(settings)
            });

            this.showToast('Einstellungen gespeichert', 'success');
            this.cache.delete('/wp-json/aukrug/v1/settings'); // Clear cache
        } catch (error) {
            this.showToast('Fehler beim Speichern der Einstellungen', 'error');
        }
    }

    resetSettings() {
        if (confirm('Möchten Sie wirklich alle Einstellungen zurücksetzen?')) {
            this.cache.delete('/wp-json/aukrug/v1/settings');
            this.loadSettings();
        }
    }

    renderKPIs(data) {
        const container = document.getElementById('kpis-container');
        container.innerHTML = `
            <div class="au-kpi">
                <span class="au-kpi-value">${data.total_members || 0}</span>
                <span class="au-kpi-label">Community Mitglieder</span>
                <span class="au-kpi-delta ${data.members_delta >= 0 ? 'positive' : 'negative'}">
                    ${data.members_delta >= 0 ? '+' : ''}${data.members_delta || 0}
                </span>
            </div>
            <div class="au-kpi">
                <span class="au-kpi-value">${data.active_caches || 0}</span>
                <span class="au-kpi-label">Aktive Geocaches</span>
                <span class="au-kpi-delta ${data.caches_delta >= 0 ? 'positive' : 'negative'}">
                    ${data.caches_delta >= 0 ? '+' : ''}${data.caches_delta || 0}
                </span>
            </div>
            <div class="au-kpi">
                <span class="au-kpi-value">${data.total_reports || 0}</span>
                <span class="au-kpi-label">Meldungen</span>
                <span class="au-kpi-delta ${data.reports_delta >= 0 ? 'positive' : 'negative'}">
                    ${data.reports_delta >= 0 ? '+' : ''}${data.reports_delta || 0}
                </span>
            </div>
            <div class="au-kpi">
                <span class="au-kpi-value">${data.app_downloads || 0}</span>
                <span class="au-kpi-label">App Downloads</span>
                <span class="au-kpi-delta ${data.downloads_delta >= 0 ? 'positive' : 'negative'}">
                    ${data.downloads_delta >= 0 ? '+' : ''}${data.downloads_delta || 0}
                </span>
            </div>
        `;
    }

    renderHealthStatus(health) {
        const container = document.getElementById('health-status');
        const statusClass = health.status === 'healthy' ? 'online' : 'offline';

        container.innerHTML = `
            <div class="au-status ${statusClass}">
                <div class="status-indicator"></div>
                System ${health.status === 'healthy' ? 'Gesund' : 'Fehler'}
            </div>
            <div class="au-text-sm au-text-muted">
                Letzte Prüfung: ${new Date(health.last_check).toLocaleString('de-DE')}
            </div>
        `;
    }

    renderRecentActivity(activities) {
        const container = document.getElementById('recent-activity');
        const activityHtml = activities.map(activity => `
            <div class="activity-item">
                <div class="activity-time">${this.formatTimeAgo(activity.created_at)}</div>
                <div class="activity-content">${activity.description}</div>
            </div>
        `).join('');

        container.innerHTML = activityHtml || '<p class="au-text-muted">Keine aktuellen Aktivitäten</p>';
    }

    renderCommunityTable(members) {
        const container = document.getElementById('community-table');
        const tableHtml = `
            <table class="au-table">
                <thead>
                    <tr>
                        <th>Mitglied</th>
                        <th>E-Mail</th>
                        <th>Registriert</th>
                        <th>Status</th>
                        <th>Aktionen</th>
                    </tr>
                </thead>
                <tbody>
                    ${members.map(member => `
                        <tr>
                            <td>${member.display_name}</td>
                            <td>${member.email}</td>
                            <td>${new Date(member.registered).toLocaleDateString('de-DE')}</td>
                            <td><span class="au-badge status-${member.status}">${member.status}</span></td>
                            <td>
                                <button class="au-btn au-btn-ghost" onclick="dashboard.editMember(${member.id})">
                                    Bearbeiten
                                </button>
                            </td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        `;
        container.innerHTML = tableHtml;
    }

    renderGeocachingTable(caches) {
        const container = document.getElementById('geocaching-table');
        const tableHtml = `
            <table class="au-table">
                <thead>
                    <tr>
                        <th>GC-Code</th>
                        <th>Name</th>
                        <th>Typ</th>
                        <th>Status</th>
                        <th>Owner</th>
                        <th>Letzte Synchronisation</th>
                    </tr>
                </thead>
                <tbody>
                    ${caches.map(cache => `
                        <tr>
                            <td><code>${cache.gc_code}</code></td>
                            <td>${cache.name}</td>
                            <td>${cache.type}</td>
                            <td><span class="au-badge status-${cache.status}">${cache.status}</span></td>
                            <td>${cache.owner}</td>
                            <td>${new Date(cache.last_sync).toLocaleDateString('de-DE')}</td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        `;
        container.innerHTML = tableHtml;
    }

    initGeocachingMap(caches) {
        const mapContainer = document.getElementById('geocaching-map');
        if (!mapContainer || !window.L) return;

        // Initialize Leaflet map
        const map = L.map('geocaching-map').setView([54.1, 9.8], 10);
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png').addTo(map);

        // Add cache markers
        caches.forEach(cache => {
            if (cache.latitude && cache.longitude) {
                L.marker([cache.latitude, cache.longitude])
                    .bindPopup(`<b>${cache.name}</b><br/>${cache.gc_code}`)
                    .addTo(map);
            }
        });
    }

    renderReportsTable(reports) {
        const container = document.getElementById('reports-table');
        const tableHtml = `
            <table class="au-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Kategorie</th>
                        <th>Beschreibung</th>
                        <th>Status</th>
                        <th>Erstellt</th>
                        <th>Aktionen</th>
                    </tr>
                </thead>
                <tbody>
                    ${reports.map(report => `
                        <tr>
                            <td>#${report.id}</td>
                            <td>${report.category}</td>
                            <td>${report.description.substring(0, 50)}...</td>
                            <td><span class="au-badge status-${report.status}">${report.status}</span></td>
                            <td>${new Date(report.created_at).toLocaleDateString('de-DE')}</td>
                            <td>
                                <button class="au-btn au-btn-ghost" onclick="dashboard.viewReport(${report.id})">
                                    Details
                                </button>
                            </td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        `;
        container.innerHTML = tableHtml;
    }

    renderDevicesTable(devices) {
        const container = document.getElementById('devices-table');
        const tableHtml = `
            <table class="au-table">
                <thead>
                    <tr>
                        <th>Gerät</th>
                        <th>Plattform</th>
                        <th>App Version</th>
                        <th>Letzter Zugriff</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    ${devices.map(device => `
                        <tr>
                            <td>${device.device_name}</td>
                            <td>${device.platform}</td>
                            <td>${device.app_version}</td>
                            <td>${new Date(device.last_seen).toLocaleDateString('de-DE')}</td>
                            <td><span class="au-status ${device.is_active ? 'online' : 'offline'}">${device.is_active ? 'Aktiv' : 'Inaktiv'}</span></td>
                        </tr>
                    `).join('')}
                </tbody>
            </table>
        `;
        container.innerHTML = tableHtml;
    }

    renderSyncStatus(status) {
        const container = document.getElementById('sync-status');
        container.innerHTML = `
            <div class="au-card">
                <h3>Synchronisation Status</h3>
                <div class="au-status ${status.is_running ? 'online' : 'offline'}">
                    ${status.is_running ? 'Läuft' : 'Gestoppt'}
                </div>
                <p>Letzte Synchronisation: ${new Date(status.last_run).toLocaleString('de-DE')}</p>
                <div class="au-quick-actions">
                    <button class="au-btn au-btn-primary" onclick="dashboard.startSync()">
                        Sync starten
                    </button>
                    <button class="au-btn au-btn-ghost" onclick="dashboard.stopSync()">
                        Sync stoppen
                    </button>
                </div>
            </div>
        `;
    }

    async apiCall(endpoint) {
        if (this.cache.has(endpoint)) {
            return this.cache.get(endpoint);
        }

        const response = await fetch(endpoint, {
            headers: {
                'X-WP-Nonce': wpApiSettings.nonce
            }
        });

        if (!response.ok) {
            throw new Error(`API Fehler: ${response.statusText}`);
        }

        const data = await response.json();
        this.cache.set(endpoint, data);

        // Cache für 5 Minuten
        setTimeout(() => this.cache.delete(endpoint), 300000);

        return data;
    }

    showLoading(tabName) {
        const content = document.querySelector(`[data-tab-content="${tabName}"]`);
        if (content) {
            content.style.opacity = '0.5';
            content.style.pointerEvents = 'none';
        }
    }

    hideLoading(tabName) {
        const content = document.querySelector(`[data-tab-content="${tabName}"]`);
        if (content) {
            content.style.opacity = '1';
            content.style.pointerEvents = 'auto';
        }
    }

    showError(tabName, message) {
        this.showToast(`Fehler beim Laden von ${tabName}: ${message}`, 'error');
    }

    showToast(message, type = 'success') {
        const toast = document.createElement('div');
        toast.className = `au-toast ${type}`;
        toast.textContent = message;
        document.body.appendChild(toast);

        setTimeout(() => {
            toast.remove();
        }, 3000);
    }

    formatTimeAgo(date) {
        const now = new Date();
        const diff = now - new Date(date);
        const minutes = Math.floor(diff / 60000);

        if (minutes < 1) return 'Gerade eben';
        if (minutes < 60) return `vor ${minutes} Min`;
        if (minutes < 1440) return `vor ${Math.floor(minutes / 60)} Std`;
        return `vor ${Math.floor(minutes / 1440)} Tagen`;
    }

    initWebSocket() {
        // WebSocket für Live-Updates (falls verfügbar)
        try {
            this.ws = new WebSocket('wss://your-websocket-endpoint');
            this.ws.onmessage = (event) => {
                const data = JSON.parse(event.data);
                this.handleRealTimeUpdate(data);
            };
        } catch (error) {
            console.log('WebSocket nicht verfügbar, nutze Polling');
            this.startPolling();
        }
    }

    startPolling() {
        setInterval(() => {
            if (this.currentTab === 'overview') {
                this.loadInitialData();
            }
        }, 30000); // Alle 30 Sekunden
    }

    async loadInitialData() {
        try {
            const adminCounts = await this.apiCall('/wp-json/aukrug/v1/admin/counts');
            this.updateAdminCounts(adminCounts);
        } catch (error) {
            console.error('Fehler beim Laden der Admin-Daten:', error);
        }
    }

    updateAdminCounts(counts) {
        // Update admin counts in UI
        Object.keys(counts).forEach(key => {
            const element = document.getElementById(`count-${key}`);
            if (element) {
                element.textContent = counts[key];
            }
        });
    }

    // Action handlers
    async startSync() {
        try {
            await fetch('/wp-json/aukrug/v1/sync/start', {
                method: 'POST',
                headers: { 'X-WP-Nonce': wpApiSettings.nonce }
            });
            this.showToast('Synchronisation gestartet', 'success');
            this.loadSync();
        } catch (error) {
            this.showToast('Fehler beim Starten der Sync', 'error');
        }
    }

    async stopSync() {
        try {
            await fetch('/wp-json/aukrug/v1/sync/stop', {
                method: 'POST',
                headers: { 'X-WP-Nonce': wpApiSettings.nonce }
            });
            this.showToast('Synchronisation gestoppt', 'success');
            this.loadSync();
        } catch (error) {
            this.showToast('Fehler beim Stoppen der Sync', 'error');
        }
    }

    editMember(memberId) {
        // Implement member editing
        this.showToast('Member-Bearbeitung noch nicht implementiert', 'warning');
    }

    viewReport(reportId) {
        // Implement report viewing
        this.showToast('Report-Details noch nicht implementiert', 'warning');
    }
}

// Initialize dashboard when DOM is ready
document.addEventListener('DOMContentLoaded', () => {
    window.dashboard = new AukrugDashboard();
});
