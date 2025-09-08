/**
 * Aukrug Connect Dashboard - Modern Admin JavaScript
 * Interactive features and AJAX functionality for Reports Management
 */

(function ($) {
    'use strict';

    class AukrugDashboard {
        constructor() {
            this.selectedReports = new Set();
            this.currentFilters = {};
            this.timeseriesChart = null;
            this.init();
        }

        init() {
            this.bindEvents();
            this.initCharts();
            this.initRefreshTimers();
            this.initQuickActions();
            this.loadReports();
        }

        bindEvents() {
            // Tab switching with animation
            $('.nav-tab').on('click', this.handleTabSwitch.bind(this));

            // Refresh buttons
            $('.refresh-stats').on('click', this.refreshStats.bind(this));

            // Quick action buttons
            $('.quick-action-btn').on('click', this.handleQuickAction.bind(this));

            // Search functionality
            $('.aukrug-search').on('input', this.handleSearch.bind(this));

            // Reports management
            $('#status-filter, #category-filter, #priority-filter').on('change', this.applyFilters.bind(this));
            $('#date-from, #date-to').on('change', this.applyFilters.bind(this));

            // Global click handler for modals
            $(document).on('click', '.au-modal', function (e) {
                if (e.target === this) {
                    this.closeReportDetail();
                    this.closeTimeSeries();
                }.bind(this));
        }

        // Reports Management
        async loadReports(filters = {}) {
            try {
                const params = new URLSearchParams({
                    ...filters,
                    limit: 100
                });

                const response = await fetch(`${wpApiSettings.root}aukrug/v1/reports?${params}`, {
                    headers: {
                        'X-WP-Nonce': wpApiSettings.nonce
                    }
                });

                if (!response.ok) throw new Error('API request failed');

                const reports = await response.json();
                this.renderReportsTable(reports);
                this.loadReportsStats();
            } catch (error) {
                console.error('Error loading reports:', error);
                this.showNotice('Fehler beim Laden der Meldungen', 'error');
            }
        }

        async loadReportsStats() {
            try {
                const response = await fetch(`${wpApiSettings.root}aukrug/v1/reports/stats`, {
                    headers: {
                        'X-WP-Nonce': wpApiSettings.nonce
                    }
                });

                if (!response.ok) throw new Error('Stats request failed');

                const stats = await response.json();
                this.updateReportsStats(stats);
            } catch (error) {
                console.error('Error loading reports stats:', error);
            }
        }

        renderReportsTable(reports) {
            const tbody = document.getElementById('reports-tbody');
            if (!tbody) return;

            if (reports.length === 0) {
                tbody.innerHTML = '<tr><td colspan="9" class="au-text-center au-text-muted">Keine Meldungen gefunden</td></tr>';
                return;
            }

            tbody.innerHTML = reports.map(report => `
                <tr data-report-id="${report.id}" ${this.selectedReports.has(report.id) ? 'class="selected"' : ''}>
                    <td>
                        <input type="checkbox" 
                               ${this.selectedReports.has(report.id) ? 'checked' : ''} 
                               onchange="dashboard.toggleReportSelection(${report.id})">
                    </td>
                    <td>#${report.id}</td>
                    <td>
                        <strong>${this.escapeHtml(report.title || 'Ohne Titel')}</strong>
                        ${report.address ? `<br><small class="au-text-muted">${this.escapeHtml(report.address)}</small>` : ''}
                    </td>
                    <td>
                        <span class="category-badge">${this.getCategoryLabel(report.category)}</span>
                    </td>
                    <td>
                        <span class="priority-badge ${report.priority || 'normal'}">${this.getPriorityLabel(report.priority)}</span>
                    </td>
                    <td>
                        <span class="status-badge ${report.status || 'open'}">${this.getStatusLabel(report.status)}</span>
                    </td>
                    <td>
                        ${report.assigned_to ? `User #${report.assigned_to}` : '<span class="au-text-muted">Nicht zugewiesen</span>'}
                    </td>
                    <td>
                        <small>${this.formatDate(report.created_at)}</small>
                    </td>
                    <td>
                        <div class="au-action-group">
                            <button class="au-action-btn" onclick="dashboard.viewReport(${report.id})">👁️</button>
                            <button class="au-action-btn" onclick="dashboard.editReportStatus(${report.id})">✏️</button>
                            <button class="au-action-btn" onclick="dashboard.assignReport(${report.id})">👤</button>
                        </div>
                    </td>
                </tr>
            `).join('');
        }

        updateReportsStats(stats) {
            document.getElementById('total-reports').textContent = stats.total || 0;
            document.getElementById('open-reports').textContent = stats.open_reports || 0;
            document.getElementById('urgent-reports').textContent = stats.urgent_reports || 0;
            document.getElementById('resolved-reports').textContent = stats.by_status?.resolved || 0;
        }

        toggleReportSelection(reportId) {
            if (this.selectedReports.has(reportId)) {
                this.selectedReports.delete(reportId);
            } else {
                this.selectedReports.add(reportId);
            }

            this.updateSelectionUI();
        }

        toggleAllReports() {
            const checkbox = document.getElementById('select-all-reports');
            const checkboxes = document.querySelectorAll('#reports-tbody input[type="checkbox"]');

            if (checkbox.checked) {
                checkboxes.forEach(cb => {
                    const reportId = parseInt(cb.closest('tr').dataset.reportId);
                    this.selectedReports.add(reportId);
                    cb.checked = true;
                });
            } else {
                this.selectedReports.clear();
                checkboxes.forEach(cb => cb.checked = false);
            }

            this.updateSelectionUI();
        }

        updateSelectionUI() {
            const bulkActions = document.getElementById('bulk-actions');
            const hasSelection = this.selectedReports.size > 0;

            bulkActions.style.display = hasSelection ? 'block' : 'none';

            // Update row highlighting
            document.querySelectorAll('#reports-tbody tr').forEach(tr => {
                const reportId = parseInt(tr.dataset.reportId);
                tr.classList.toggle('selected', this.selectedReports.has(reportId));
            });
        }

        async viewReport(reportId) {
            try {
                const response = await fetch(`${wpApiSettings.root}aukrug/v1/reports/${reportId}`, {
                    headers: {
                        'X-WP-Nonce': wpApiSettings.nonce
                    }
                });

                if (!response.ok) throw new Error('Report request failed');

                const report = await response.json();
                await this.loadReportComments(reportId);
                this.renderReportDetail(report);
                document.getElementById('report-detail-modal').style.display = 'flex';
            } catch (error) {
                console.error('Error loading report:', error);
                this.showNotice('Fehler beim Laden der Meldung', 'error');
            }
        }

        async loadReportComments(reportId) {
            try {
                const response = await fetch(`${wpApiSettings.root}aukrug/v1/reports/${reportId}/comments`, {
                    headers: {
                        'X-WP-Nonce': wpApiSettings.nonce
                    }
                });

                if (!response.ok) throw new Error('Comments request failed');

                this.reportComments = await response.json();
            } catch (error) {
                console.error('Error loading comments:', error);
                this.reportComments = [];
            }
        }

        renderReportDetail(report) {
            document.getElementById('report-detail-title').textContent = `Meldung #${report.id}: ${report.title}`;

            const content = document.getElementById('report-detail-content');
            content.innerHTML = `
                <div class="au-report-detail">
                    <div class="au-report-main">
                        <div class="au-report-header">
                            <h3 class="au-report-title">${this.escapeHtml(report.title)}</h3>
                            <div class="au-report-meta">
                                <span class="category-badge">${this.getCategoryLabel(report.category)}</span>
                                <span class="priority-badge ${report.priority}">${this.getPriorityLabel(report.priority)}</span>
                                <span class="status-badge ${report.status}">${this.getStatusLabel(report.status)}</span>
                            </div>
                        </div>
                        
                        ${report.description ? `
                            <div class="au-report-description">
                                <h4>Beschreibung</h4>
                                <p>${this.escapeHtml(report.description)}</p>
                            </div>
                        ` : ''}
                        
                        <div class="au-comments-section">
                            <h4>Verlauf & Kommentare</h4>
                            <div id="comments-list">
                                ${this.renderComments()}
                            </div>
                            
                            <div class="au-comment-form">
                                <textarea id="new-comment" placeholder="Antwort oder interne Notiz hinzufügen..."></textarea>
                                <div class="au-comment-form-actions">
                                    <button class="au-btn au-btn-primary" onclick="dashboard.addComment(${report.id})">
                                        Kommentar hinzufügen
                                    </button>
                                    <div class="au-visibility-toggle">
                                        <input type="checkbox" id="internal-comment">
                                        <label for="internal-comment">Interne Notiz</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <div class="au-report-sidebar">
                        <h4>Details</h4>
                        <dl>
                            <dt>Status</dt>
                            <dd>
                                <select onchange="dashboard.updateReportField(${report.id}, 'status', this.value)">
                                    <option value="open" ${report.status === 'open' ? 'selected' : ''}>Offen</option>
                                    <option value="in_progress" ${report.status === 'in_progress' ? 'selected' : ''}>In Bearbeitung</option>
                                    <option value="resolved" ${report.status === 'resolved' ? 'selected' : ''}>Gelöst</option>
                                    <option value="closed" ${report.status === 'closed' ? 'selected' : ''}>Geschlossen</option>
                                </select>
                            </dd>
                            
                            <dt>Priorität</dt>
                            <dd>
                                <select onchange="dashboard.updateReportField(${report.id}, 'priority', this.value)">
                                    <option value="low" ${report.priority === 'low' ? 'selected' : ''}>Niedrig</option>
                                    <option value="normal" ${report.priority === 'normal' ? 'selected' : ''}>Normal</option>
                                    <option value="high" ${report.priority === 'high' ? 'selected' : ''}>Hoch</option>
                                    <option value="urgent" ${report.priority === 'urgent' ? 'selected' : ''}>Dringend</option>
                                </select>
                            </dd>
                            
                            ${report.address ? `
                                <dt>Adresse</dt>
                                <dd>${this.escapeHtml(report.address)}</dd>
                            ` : ''}
                            
                            ${report.lat && report.lng ? `
                                <dt>Koordinaten</dt>
                                <dd>${report.lat}, ${report.lng}</dd>
                            ` : ''}
                            
                            <dt>Erstellt</dt>
                            <dd>${this.formatDate(report.created_at)}</dd>
                            
                            ${report.assigned_to ? `
                                <dt>Zugewiesen</dt>
                                <dd>User #${report.assigned_to}</dd>
                            ` : ''}
                        </dl>
                    </div>
                </div>
            `;
        }

        renderComments() {
            if (!this.reportComments || this.reportComments.length === 0) {
                return '<p class="au-text-muted">Noch keine Kommentare</p>';
            }

            return this.reportComments.map(comment => `
                <div class="au-comment ${comment.visibility === 'internal' ? 'internal' : ''}">
                    <div class="au-comment-header">
                        <div>
                            <span class="au-comment-author">${this.escapeHtml(comment.author_name || 'Anonym')}</span>
                            <span class="au-comment-meta">${this.formatDate(comment.created_at)}</span>
                            ${comment.visibility === 'internal' ? '<span class="au-comment-visibility internal">Intern</span>' : ''}
                        </div>
                    </div>
                    <div class="au-comment-message">${this.escapeHtml(comment.message)}</div>
                </div>
            `).join('');
        }

        async addComment(reportId) {
            const textarea = document.getElementById('new-comment');
            const message = textarea.value.trim();
            const isInternal = document.getElementById('internal-comment').checked;

            if (!message) {
                this.showNotice('Bitte geben Sie eine Nachricht ein', 'error');
                return;
            }

            try {
                const response = await fetch(`${wpApiSettings.root}aukrug/v1/reports/${reportId}/comments`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-WP-Nonce': wpApiSettings.nonce
                    },
                    body: JSON.stringify({
                        message: message,
                        visibility: isInternal ? 'internal' : 'public'
                    })
                });

                if (!response.ok) throw new Error('Comment request failed');

                textarea.value = '';
                document.getElementById('internal-comment').checked = false;

                // Reload comments
                await this.loadReportComments(reportId);
                document.getElementById('comments-list').innerHTML = this.renderComments();

                this.showNotice('Kommentar hinzugefügt', 'success');
            } catch (error) {
                console.error('Error adding comment:', error);
                this.showNotice('Fehler beim Hinzufügen des Kommentars', 'error');
            }
        }

        async updateReportField(reportId, field, value) {
            try {
                const response = await fetch(`${wpApiSettings.root}aukrug/v1/reports/${reportId}`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-WP-Nonce': wpApiSettings.nonce
                    },
                    body: JSON.stringify({
                        [field]: value
                    })
                });

                if (!response.ok) throw new Error('Update request failed');

                this.showNotice(`${field} aktualisiert`, 'success');
                this.loadReports(this.currentFilters); // Refresh table
            } catch (error) {
                console.error('Error updating report:', error);
                this.showNotice('Fehler beim Aktualisieren', 'error');
            }
        }

        applyFilters() {
            this.currentFilters = {
                status: document.getElementById('status-filter').value,
                category: document.getElementById('category-filter').value,
                priority: document.getElementById('priority-filter').value,
                from: document.getElementById('date-from').value,
                to: document.getElementById('date-to').value
            };

            // Remove empty filters
            Object.keys(this.currentFilters).forEach(key => {
                if (!this.currentFilters[key]) {
                    delete this.currentFilters[key];
                }
            });

            this.loadReports(this.currentFilters);
        }

        clearFilters() {
            document.getElementById('status-filter').value = '';
            document.getElementById('category-filter').value = '';
            document.getElementById('priority-filter').value = '';
            document.getElementById('date-from').value = '';
            document.getElementById('date-to').value = '';

            this.currentFilters = {};
            this.loadReports();
        }

        async applyBulkActions() {
            const bulkStatus = document.getElementById('bulk-status').value;
            const bulkPriority = document.getElementById('bulk-priority').value;

            if (!bulkStatus && !bulkPriority) {
                this.showNotice('Bitte wählen Sie eine Aktion aus', 'error');
                return;
            }

            if (this.selectedReports.size === 0) {
                this.showNotice('Bitte wählen Sie Meldungen aus', 'error');
                return;
            }

            try {
                const data = {
                    ids: Array.from(this.selectedReports)
                };

                if (bulkStatus) data.status = bulkStatus;
                if (bulkPriority) data.priority = bulkPriority;

                const response = await fetch(`${wpApiSettings.root}aukrug/v1/reports/bulk`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-WP-Nonce': wpApiSettings.nonce
                    },
                    body: JSON.stringify(data)
                });

                if (!response.ok) throw new Error('Bulk action failed');

                const result = await response.json();
                this.showNotice(`${result.updated} Meldungen aktualisiert`, 'success');

                this.clearSelection();
                this.loadReports(this.currentFilters);
            } catch (error) {
                console.error('Error applying bulk actions:', error);
                this.showNotice('Fehler bei der Bulk-Aktion', 'error');
            }
        }

        clearSelection() {
            this.selectedReports.clear();
            document.getElementById('select-all-reports').checked = false;
            this.updateSelectionUI();
        }

        refreshReports() {
            this.loadReports(this.currentFilters);
        }

        async exportReports() {
            try {
                const response = await fetch(`${wpApiSettings.root}aukrug/v1/reports/export`, {
                    headers: {
                        'X-WP-Nonce': wpApiSettings.nonce
                    }
                });

                if (!response.ok) throw new Error('Export failed');

                const blob = await response.blob();
                const url = window.URL.createObjectURL(blob);
                const a = document.createElement('a');
                a.href = url;
                a.download = `meldungen-export-${new Date().toISOString().split('T')[0]}.csv`;
                document.body.appendChild(a);
                a.click();
                window.URL.revokeObjectURL(url);
                document.body.removeChild(a);

                this.showNotice('Export erfolgreich', 'success');
            } catch (error) {
                console.error('Error exporting reports:', error);
                this.showNotice('Fehler beim Export', 'error');
            }
        }

        async showTimeSeries() {
            const modal = document.getElementById('timeseries-modal');
            modal.style.display = 'flex';

            await this.updateTimeSeries();
        }

        async updateTimeSeries() {
            const days = document.getElementById('timeseries-days').value;

            try {
                const response = await fetch(`${wpApiSettings.root}aukrug/v1/reports/stats/timeseries?days=${days}`, {
                    headers: {
                        'X-WP-Nonce': wpApiSettings.nonce
                    }
                });

                if (!response.ok) throw new Error('Timeseries request failed');

                const data = await response.json();
                this.renderTimeseriesChart(data);
            } catch (error) {
                console.error('Error loading timeseries:', error);
                this.showNotice('Fehler beim Laden der Zeitreihen', 'error');
            }
        }

        renderTimeseriesChart(data) {
            const ctx = document.getElementById('timeseries-chart');

            if (this.timeseriesChart) {
                this.timeseriesChart.destroy();
            }

            this.timeseriesChart = new Chart(ctx, {
                type: 'line',
                data: {
                    labels: data.map(d => d.d),
                    datasets: [{
                        label: 'Neue Meldungen',
                        data: data.map(d => d.c),
                        borderColor: '#3b82f6',
                        backgroundColor: 'rgba(59, 130, 246, 0.1)',
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
        }

        closeReportDetail() {
            document.getElementById('report-detail-modal').style.display = 'none';
        }

        closeTimeSeries() {
            document.getElementById('timeseries-modal').style.display = 'none';
            if (this.timeseriesChart) {
                this.timeseriesChart.destroy();
                this.timeseriesChart = null;
            }
        }

        // Utility functions
        getCategoryLabel(category) {
            const labels = {
                'strasse': 'Straße & Verkehr',
                'beleuchtung': 'Beleuchtung',
                'abfall': 'Abfall & Entsorgung',
                'vandalismus': 'Vandalismus',
                'gruenflaeche': 'Grünflächen',
                'wasser': 'Wasser & Abwasser',
                'laerm': 'Lärm',
                'spielplatz': 'Spielplätze',
                'umwelt': 'Umwelt',
                'winterdienst': 'Winterdienst',
                'gebaeude': 'Gebäude',
                'sonstiges': 'Sonstiges'
            };
            return labels[category] || 'Sonstiges';
        }

        getPriorityLabel(priority) {
            const labels = {
                'low': 'Niedrig',
                'normal': 'Normal',
                'high': 'Hoch',
                'urgent': 'Dringend'
            };
            return labels[priority] || 'Normal';
        }

        getStatusLabel(status) {
            const labels = {
                'open': 'Offen',
                'in_progress': 'In Bearbeitung',
                'resolved': 'Gelöst',
                'closed': 'Geschlossen'
            };
            return labels[status] || 'Offen';
        }

        escapeHtml(text) {
            const div = document.createElement('div');
            div.textContent = text;
            return div.innerHTML;
        }

        formatDate(dateString) {
            return new Date(dateString).toLocaleDateString('de-DE', {
                year: 'numeric',
                month: '2-digit',
                day: '2-digit',
                hour: '2-digit',
                minute: '2-digit'
            });
        }

        showNotice(message, type = 'info') {
            // Create notice element
            const notice = document.createElement('div');
            notice.className = `au-notice au-notice-${type}`;
            notice.innerHTML = `
                <span>${message}</span>
                <button class="au-notice-close" onclick="this.parentElement.remove()">×</button>
            `;

            // Add to page
            document.body.appendChild(notice);

            // Auto-remove after 5 seconds
            setTimeout(() => {
                if (notice.parentElement) {
                    notice.remove();
                }
            }, 5000);
        }

        handleTabSwitch(e) {
            e.preventDefault();

            const $tab = $(e.currentTarget);
            const targetUrl = $tab.attr('href');

            // Update active state
            $('.nav-tab').removeClass('nav-tab-active');
            $tab.addClass('nav-tab-active');

            // Fade content
            $('.aukrug-tab-content').addClass('loading');

            // Load new content (in real app, this would be AJAX)
            setTimeout(() => {
                window.location.href = targetUrl;
            }, 200);
        }

        refreshStats() {
            if (!aukrug_ajax) return;

            $.ajax({
                url: aukrug_ajax.ajax_url,
                type: 'POST',
                data: {
                    action: 'aukrug_dashboard_action',
                    action_type: 'refresh_stats',
                    nonce: aukrug_ajax.nonce
                },
                beforeSend: () => {
                    $('.kpi-cards-row').addClass('loading');
                },
                success: (response) => {
                    if (response.success) {
                        this.updateStatsDisplay(response.data);
                        this.showNotice('Statistiken aktualisiert', 'success');
                    }
                },
                error: () => {
                    this.showNotice('Fehler beim Laden der Statistiken', 'error');
                },
                complete: () => {
                    $('.kpi-cards-row').removeClass('loading');
                }
            });
        }

        updateStatsDisplay(stats) {
            // Update KPI values with animation
            Object.keys(stats).forEach(key => {
                const $element = $(`.kpi-${key} .kpi-value`);
                if ($element.length) {
                    this.animateNumber($element, parseInt(stats[key]) || 0);
                }
            });
        }

        animateNumber($element, targetValue) {
            const startValue = parseInt($element.text().replace(/,/g, '')) || 0;
            const duration = 1000;
            const startTime = Date.now();

            const updateNumber = () => {
                const elapsed = Date.now() - startTime;
                const progress = Math.min(elapsed / duration, 1);

                // Easing function
                const easeOutCubic = 1 - Math.pow(1 - progress, 3);

                const currentValue = Math.round(startValue + (targetValue - startValue) * easeOutCubic);
                $element.text(currentValue.toLocaleString());

                if (progress < 1) {
                    requestAnimationFrame(updateNumber);
                }
            };

            requestAnimationFrame(updateNumber);
        }

        handleQuickAction(e) {
            e.preventDefault();

            const $btn = $(e.currentTarget);
            const action = $btn.data('action');

            if (!aukrug_ajax || !action) return;

            $.ajax({
                url: aukrug_ajax.ajax_url,
                type: 'POST',
                data: {
                    action: 'aukrug_dashboard_action',
                    action_type: 'quick_action',
                    quick_action: action,
                    nonce: aukrug_ajax.nonce
                },
                beforeSend: () => {
                    $btn.addClass('loading').prop('disabled', true);
                },
                success: (response) => {
                    if (response.success) {
                        this.showNotice(`Aktion "${action}" erfolgreich ausgeführt`, 'success');
                    } else {
                        this.showNotice('Aktion fehlgeschlagen', 'error');
                    }
                },
                error: () => {
                    this.showNotice('Verbindungsfehler', 'error');
                },
                complete: () => {
                    $btn.removeClass('loading').prop('disabled', false);
                }
            });
        }

        handleSearch(e) {
            const query = $(e.target).val().toLowerCase();
            const $items = $('.searchable-item');

            $items.each(function () {
                const $item = $(this);
                const text = $item.text().toLowerCase();

                if (text.includes(query)) {
                    $item.show().addClass('fade-in');
                } else {
                    $item.hide().removeClass('fade-in');
                }
            });
        }

        initCharts() {
            // Chart.js initialization is handled in PHP template
            // This method can be extended for additional chart features

            // Make charts responsive
            if (window.Chart) {
                Chart.defaults.responsive = true;
                Chart.defaults.maintainAspectRatio = false;
            }
        }

        initRefreshTimers() {
            // Auto-refresh stats every 5 minutes
            setInterval(() => {
                this.refreshStats();
            }, 5 * 60 * 1000);

            // Update timestamps every minute
            setInterval(() => {
                this.updateTimestamps();
            }, 60 * 1000);
        }

        updateTimestamps() {
            $('.activity-time').each(function () {
                const $time = $(this);
                const timeString = $time.data('time');
                if (timeString) {
                    const timeAgo = this.timeAgo(new Date(timeString));
                    $time.text(timeAgo);
                }
            }.bind(this));
        }

        timeAgo(date) {
            const now = new Date();
            const seconds = Math.floor((now - date) / 1000);

            const intervals = {
                'Jahr': 31536000,
                'Monat': 2592000,
                'Woche': 604800,
                'Tag': 86400,
                'Stunde': 3600,
                'Minute': 60
            };

            for (const [unit, secondsInUnit] of Object.entries(intervals)) {
                const interval = Math.floor(seconds / secondsInUnit);
                if (interval >= 1) {
                    return `vor ${interval} ${unit}${interval > 1 ? (unit === 'Monat' ? 'en' : unit === 'Jahr' ? 'en' : 'n') : ''}`;
                }
            }

            return 'gerade eben';
        }

        initQuickActions() {
            // Initialize quick action tooltips and confirmations
            $('.quick-action-btn[data-confirm]').on('click', function (e) {
                e.preventDefault();

                const $btn = $(this);
                const confirmText = $btn.data('confirm');

                if (confirm(confirmText)) {
                    // Proceed with original click handler
                    $btn.off('click').trigger('click');
                }
            });
        }

        showNotice(message, type = 'info') {
            const $notice = $(`
                <div class="aukrug-notice ${type} fade-in">
                    <span class="dashicons ${this.getNoticeIcon(type)}"></span>
                    ${message}
                    <button type="button" class="notice-dismiss">
                        <span class="dashicons dashicons-dismiss"></span>
                    </button>
                </div>
            `);

            // Insert at top of content
            $('.aukrug-tab-content').prepend($notice);

            // Auto-remove after 5 seconds
            setTimeout(() => {
                $notice.fadeOut(() => $notice.remove());
            }, 5000);

            // Manual dismiss
            $notice.find('.notice-dismiss').on('click', () => {
                $notice.fadeOut(() => $notice.remove());
            });
        }

        getNoticeIcon(type) {
            const icons = {
                'success': 'dashicons-yes-alt',
                'error': 'dashicons-warning',
                'warning': 'dashicons-info',
                'info': 'dashicons-info'
            };

            return icons[type] || icons.info;
        }
    }

    // Utility functions
    window.AukrugUtils = {
        formatNumber: (num) => {
            return new Intl.NumberFormat('de-DE').format(num);
        },

        formatBytes: (bytes) => {
            if (bytes === 0) return '0 Bytes';

            const k = 1024;
            const sizes = ['Bytes', 'KB', 'MB', 'GB', 'TB'];
            const i = Math.floor(Math.log(bytes) / Math.log(k));

            return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
        },

        copyToClipboard: (text) => {
            if (navigator.clipboard) {
                navigator.clipboard.writeText(text).then(() => {
                    window.aukrugDashboard.showNotice('In Zwischenablage kopiert', 'success');
                });
            } else {
                // Fallback for older browsers
                const textArea = document.createElement('textarea');
                textArea.value = text;
                document.body.appendChild(textArea);
                textArea.select();
                document.execCommand('copy');
                document.body.removeChild(textArea);
                window.aukrugDashboard.showNotice('In Zwischenablage kopiert', 'success');
            }
        }
    };

    // Global functions for onclick handlers
    window.dashboard = null;

    // Global functions
    window.toggleAllReports = function () {
        if (window.dashboard) {
            window.dashboard.toggleAllReports();
        }
    };

    window.applyFilters = function () {
        if (window.dashboard) {
            window.dashboard.applyFilters();
        }
    };

    window.clearFilters = function () {
        if (window.dashboard) {
            window.dashboard.clearFilters();
        }
    };

    window.refreshReports = function () {
        if (window.dashboard) {
            window.dashboard.refreshReports();
        }
    };

    window.exportReports = function () {
        if (window.dashboard) {
            window.dashboard.exportReports();
        }
    };

    window.showTimeSeries = function () {
        if (window.dashboard) {
            window.dashboard.showTimeSeries();
        }
    };

    window.closeReportDetail = function () {
        if (window.dashboard) {
            window.dashboard.closeReportDetail();
        }
    };

    window.closeTimeSeries = function () {
        if (window.dashboard) {
            window.dashboard.closeTimeSeries();
        }
    };

    window.applyBulkActions = function () {
        if (window.dashboard) {
            window.dashboard.applyBulkActions();
        }
    };

    window.clearSelection = function () {
        if (window.dashboard) {
            window.dashboard.clearSelection();
        }
    };

    // Initialize when DOM is ready
    $(document).ready(() => {
        window.dashboard = new AukrugDashboard();
        window.aukrugDashboard = window.dashboard; // Compatibility
    });

})(jQuery);
