'use client';

import Header from '@/components/Header';
import Sidebar from '@/components/Sidebar';
import { useApi } from '@/lib/api-client';
import { useEffect, useState } from 'react';

const statusColors = {
    'open': 'warning',
    'in_progress': 'info',
    'resolved': 'success',
    'closed': 'secondary'
};

const statusLabels = {
    'open': 'Offen',
    'in_progress': 'In Bearbeitung',
    'resolved': 'Gelöst',
    'closed': 'Geschlossen'
};

const priorityColors = {
    'low': 'success',
    'medium': 'warning',
    'high': 'danger'
};

const priorityLabels = {
    'low': 'Niedrig',
    'medium': 'Mittel',
    'high': 'Hoch'
};

export default function ReportsPage() {
    const [sidebarOpen, setSidebarOpen] = useState(false);
    const [reports, setReports] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [filter, setFilter] = useState('all');
    const [selectedReport, setSelectedReport] = useState<any>(null);
    const api = useApi();

    useEffect(() => {
        loadReports();
    }, []);

    const loadReports = async () => {
        setLoading(true);
        try {
            const response = await api.getReports();
            if (response.data) {
                setReports(response.data);
            }
        } catch (error) {
            console.error('Error loading reports:', error);
        } finally {
            setLoading(false);
        }
    };

    const filteredReports = reports.filter(report => {
        if (filter === 'all') return true;
        return report.status === filter;
    });

    const handleStatusChange = async (reportId: string, newStatus: string) => {
        try {
            await api.updateReport(reportId, { status: newStatus });
            await loadReports(); // Reload data
        } catch (error) {
            console.error('Error updating report status:', error);
        }
    };

    return (
        <>
            <Sidebar isOpen={sidebarOpen} onToggle={() => setSidebarOpen(!sidebarOpen)} />
            <div className="main-content">
                <Header onToggleSidebar={() => setSidebarOpen(!sidebarOpen)} />

                <div className="page-title-box">
                    <h4 className="page-title">Bürgermeldungen</h4>
                    <p className="text-muted">Verwalten Sie Meldungen und Beschwerden aus der Community</p>
                </div>

                {/* Statistics Cards */}
                <div className="row mb-4">
                    <div className="col-md-3">
                        <div className="card bg-warning text-white">
                            <div className="card-body">
                                <div className="d-flex align-items-center">
                                    <div className="flex-grow-1">
                                        <h4 className="mb-0">{reports.filter(r => r.status === 'open').length}</h4>
                                        <p className="mb-0">Offen</p>
                                    </div>
                                    <i className="fas fa-exclamation-circle fs-1 opacity-75"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="col-md-3">
                        <div className="card bg-info text-white">
                            <div className="card-body">
                                <div className="d-flex align-items-center">
                                    <div className="flex-grow-1">
                                        <h4 className="mb-0">{reports.filter(r => r.status === 'in_progress').length}</h4>
                                        <p className="mb-0">In Bearbeitung</p>
                                    </div>
                                    <i className="fas fa-clock fs-1 opacity-75"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="col-md-3">
                        <div className="card bg-success text-white">
                            <div className="card-body">
                                <div className="d-flex align-items-center">
                                    <div className="flex-grow-1">
                                        <h4 className="mb-0">{reports.filter(r => r.status === 'resolved').length}</h4>
                                        <p className="mb-0">Gelöst</p>
                                    </div>
                                    <i className="fas fa-check-circle fs-1 opacity-75"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div className="col-md-3">
                        <div className="card bg-secondary text-white">
                            <div className="card-body">
                                <div className="d-flex align-items-center">
                                    <div className="flex-grow-1">
                                        <h4 className="mb-0">{reports.length}</h4>
                                        <p className="mb-0">Gesamt</p>
                                    </div>
                                    <i className="fas fa-list fs-1 opacity-75"></i>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Filter Controls */}
                <div className="card mb-4">
                    <div className="card-body">
                        <div className="row align-items-center">
                            <div className="col-md-6">
                                <div className="btn-group" role="group">
                                    <button
                                        className={`btn ${filter === 'all' ? 'btn-primary' : 'btn-outline-primary'}`}
                                        onClick={() => setFilter('all')}
                                    >
                                        Alle
                                    </button>
                                    <button
                                        className={`btn ${filter === 'open' ? 'btn-warning' : 'btn-outline-warning'}`}
                                        onClick={() => setFilter('open')}
                                    >
                                        Offen
                                    </button>
                                    <button
                                        className={`btn ${filter === 'in_progress' ? 'btn-info' : 'btn-outline-info'}`}
                                        onClick={() => setFilter('in_progress')}
                                    >
                                        In Bearbeitung
                                    </button>
                                    <button
                                        className={`btn ${filter === 'resolved' ? 'btn-success' : 'btn-outline-success'}`}
                                        onClick={() => setFilter('resolved')}
                                    >
                                        Gelöst
                                    </button>
                                </div>
                            </div>
                            <div className="col-md-6 text-md-end">
                                <button className="btn btn-primary" onClick={loadReports}>
                                    <i className="fas fa-sync-alt me-2"></i>
                                    Aktualisieren
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                {/* Reports Table */}
                <div className="card">
                    <div className="card-header">
                        <h5 className="card-title mb-0">
                            {filter === 'all' ? 'Alle Meldungen' : `${statusLabels[filter as keyof typeof statusLabels] || filter} Meldungen`}
                            <span className="badge bg-secondary ms-2">{filteredReports.length}</span>
                        </h5>
                    </div>
                    <div className="card-body">
                        {loading ? (
                            <div className="d-flex justify-content-center py-5">
                                <div className="spinner-border text-primary" role="status">
                                    <span className="visually-hidden">Laden...</span>
                                </div>
                            </div>
                        ) : (
                            <div className="table-responsive">
                                <table className="table table-hover">
                                    <thead>
                                        <tr>
                                            <th>ID</th>
                                            <th>Titel</th>
                                            <th>Kategorie</th>
                                            <th>Priorität</th>
                                            <th>Status</th>
                                            <th>Erstellt</th>
                                            <th>Aktionen</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        {filteredReports.length === 0 ? (
                                            <tr>
                                                <td colSpan={7} className="text-center text-muted py-4">
                                                    {filter === 'all'
                                                        ? 'Keine Meldungen verfügbar'
                                                        : `Keine ${(statusLabels[filter as keyof typeof statusLabels] || filter).toLowerCase()} Meldungen vorhanden`
                                                    }
                                                </td>
                                            </tr>
                                        ) : (
                                            filteredReports.map((report: any) => (
                                                <tr key={report.id}>
                                                    <td>
                                                        <code>#{report.id.slice(-6)}</code>
                                                    </td>
                                                    <td>
                                                        <div className="fw-medium">{report.title || 'Unbenannt'}</div>
                                                        <small className="text-muted">{report.description?.substring(0, 60)}...</small>
                                                    </td>
                                                    <td>
                                                        <span className="badge bg-light text-dark">
                                                            {report.category || 'Allgemein'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <span className={`badge bg-${priorityColors[report.priority as keyof typeof priorityColors] || 'secondary'}`}>
                                                            {priorityLabels[report.priority as keyof typeof priorityLabels] || 'Unbekannt'}
                                                        </span>
                                                    </td>
                                                    <td>
                                                        <select
                                                            className={`form-select form-select-sm border-${statusColors[report.status as keyof typeof statusColors] || 'secondary'}`}
                                                            value={report.status}
                                                            onChange={(e) => handleStatusChange(report.id, e.target.value)}
                                                        >
                                                            <option value="open">Offen</option>
                                                            <option value="in_progress">In Bearbeitung</option>
                                                            <option value="resolved">Gelöst</option>
                                                            <option value="closed">Geschlossen</option>
                                                        </select>
                                                    </td>
                                                    <td>
                                                        <small className="text-muted">
                                                            {new Date(report.createdAt).toLocaleDateString('de-DE')}
                                                        </small>
                                                    </td>
                                                    <td>
                                                        <div className="btn-group btn-group-sm">
                                                            <button
                                                                className="btn btn-outline-primary"
                                                                onClick={() => setSelectedReport(report)}
                                                                data-bs-toggle="modal"
                                                                data-bs-target="#reportModal"
                                                            >
                                                                <i className="fas fa-eye"></i>
                                                            </button>
                                                            <button className="btn btn-outline-success">
                                                                <i className="fas fa-map-marker-alt"></i>
                                                            </button>
                                                            <button className="btn btn-outline-danger">
                                                                <i className="fas fa-trash"></i>
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            ))
                                        )}
                                    </tbody>
                                </table>
                            </div>
                        )}
                    </div>
                </div>

                {/* Report Detail Modal */}
                <div className="modal fade" id="reportModal" tabIndex={-1}>
                    <div className="modal-dialog modal-lg">
                        <div className="modal-content">
                            <div className="modal-header">
                                <h5 className="modal-title">Meldungsdetails</h5>
                                <button type="button" className="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div className="modal-body">
                                {selectedReport && (
                                    <div>
                                        <div className="row mb-3">
                                            <div className="col-md-6">
                                                <strong>ID:</strong> #{selectedReport.id}
                                            </div>
                                            <div className="col-md-6">
                                                <strong>Status:</strong>
                                                <span className={`badge bg-${statusColors[selectedReport.status as keyof typeof statusColors] || 'secondary'} ms-2`}>
                                                    {statusLabels[selectedReport.status as keyof typeof statusLabels] || 'Unbekannt'}
                                                </span>
                                            </div>
                                        </div>
                                        <div className="row mb-3">
                                            <div className="col-md-6">
                                                <strong>Kategorie:</strong> {selectedReport.category}
                                            </div>
                                            <div className="col-md-6">
                                                <strong>Priorität:</strong>
                                                <span className={`badge bg-${priorityColors[selectedReport.priority as keyof typeof priorityColors] || 'secondary'} ms-2`}>
                                                    {priorityLabels[selectedReport.priority as keyof typeof priorityLabels] || 'Unbekannt'}
                                                </span>
                                            </div>
                                        </div>
                                        <div className="mb-3">
                                            <strong>Titel:</strong>
                                            <div>{selectedReport.title}</div>
                                        </div>
                                        <div className="mb-3">
                                            <strong>Beschreibung:</strong>
                                            <div>{selectedReport.description}</div>
                                        </div>
                                        <div className="mb-3">
                                            <strong>Standort:</strong>
                                            <div>{selectedReport.location || 'Nicht angegeben'}</div>
                                        </div>
                                        <div className="mb-3">
                                            <strong>Erstellt:</strong>
                                            <div>{new Date(selectedReport.createdAt).toLocaleString('de-DE')}</div>
                                        </div>
                                    </div>
                                )}
                            </div>
                            <div className="modal-footer">
                                <button type="button" className="btn btn-secondary" data-bs-dismiss="modal">
                                    Schließen
                                </button>
                                <button type="button" className="btn btn-primary">
                                    Bearbeiten
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </>
    );
}
