'use client';

import VelzonLayout from '@/components/layout/VelzonLayout';
import { useEffect, useState } from 'react';

interface DashboardStats {
    totalReports: number;
    pendingReports: number;
    resolvedReports: number;
    totalNotices: number;
    totalEvents: number;
    totalDownloads: number;
}

export default function Dashboard() {
    const [stats, setStats] = useState<DashboardStats>({
        totalReports: 0,
        pendingReports: 0,
        resolvedReports: 0,
        totalNotices: 0,
        totalEvents: 0,
        totalDownloads: 0,
    });
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        // Simulate loading stats
        setTimeout(() => {
            setStats({
                totalReports: 47,
                pendingReports: 12,
                resolvedReports: 35,
                totalNotices: 18,
                totalEvents: 8,
                totalDownloads: 127,
            });
            setLoading(false);
        }, 1200);
    }, []);

    const statCards = [
        {
            title: 'Gesamte Berichte',
            value: stats.totalReports,
            icon: 'ri-file-list-3-line',
            gradient: 'linear-gradient(135deg, #664dc9 0%, #5a67d8 100%)',
            link: '/dashboard/reports',
        },
        {
            title: 'Offene Berichte',
            value: stats.pendingReports,
            icon: 'ri-alarm-warning-line',
            gradient: 'linear-gradient(135deg, #ffaa00 0%, #ff8c00 100%)',
            link: '/dashboard/reports?status=pending',
        },
        {
            title: 'Erledigte Berichte',
            value: stats.resolvedReports,
            icon: 'ri-checkbox-circle-line',
            gradient: 'linear-gradient(135deg, #25a0e2 0%, #1e88e5 100%)',
            link: '/dashboard/reports?status=resolved',
        },
        {
            title: 'Bekanntmachungen',
            value: stats.totalNotices,
            icon: 'ri-megaphone-line',
            gradient: 'linear-gradient(135deg, #38c172 0%, #2ecc71 100%)',
            link: '/dashboard/notices',
        },
        {
            title: 'Veranstaltungen',
            value: stats.totalEvents,
            icon: 'ri-calendar-event-line',
            gradient: 'linear-gradient(135deg, #e74c3c 0%, #c0392b 100%)',
            link: '/dashboard/events',
        },
        {
            title: 'Downloads',
            value: stats.totalDownloads,
            icon: 'ri-download-cloud-2-line',
            gradient: 'linear-gradient(135deg, #9b59b6 0%, #8e44ad 100%)',
            link: '/dashboard/downloads',
        },
    ];

    return (
        <VelzonLayout>
            <div className="page-content">
                <div className="container-fluid">
                    {/* Page Title */}
                    <div className="row">
                        <div className="col-12">
                            <div className="page-title-box d-sm-flex align-items-center justify-content-between">
                                <h4 className="mb-sm-0 fw-bold">
                                    <i className="ri-dashboard-2-line me-2"></i>
                                    Dashboard
                                </h4>
                                <div className="page-title-right">
                                    <ol className="breadcrumb m-0">
                                        <li className="breadcrumb-item">
                                            <a href="/dashboard">Aukrug</a>
                                        </li>
                                        <li className="breadcrumb-item active">Dashboard</li>
                                    </ol>
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Welcome Card */}
                    <div className="row">
                        <div className="col-12">
                            <div className="card bg-primary-subtle border-0 overflow-hidden mb-4">
                                <div className="card-body p-4">
                                    <div className="row align-items-center">
                                        <div className="col-sm">
                                            <div className="text-primary-emphasis">
                                                <h5 className="text-primary fw-bold mb-3">
                                                    🌿 Willkommen im Aukrug Verwaltungsdashboard
                                                </h5>
                                                <p className="mb-0 fs-14">
                                                    Verwalten Sie Berichte, Bekanntmachungen und Gemeinschaftsaktivitäten 
                                                    mit der Velzon Interactive Benutzeroberfläche.
                                                </p>
                                            </div>
                                        </div>
                                        <div className="col-sm-auto">
                                            <div className="avatar-lg bg-primary bg-opacity-10 p-3 rounded-circle">
                                                <i className="ri-leaf-line display-6 text-primary"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Stats Cards */}
                    <div className="row">
                        {loading ? (
                            [...Array(6)].map((_, index) => (
                                <div key={index} className="col-xl-2 col-md-4 col-sm-6">
                                    <div className="card stats-card mb-4">
                                        <div className="card-body text-center p-4">
                                            <div className="placeholder-glow">
                                                <div className="placeholder bg-light rounded-circle mx-auto mb-3" 
                                                     style={{ width: '60px', height: '60px' }}></div>
                                                <div className="placeholder col-8 bg-light mb-2"></div>
                                                <div className="placeholder col-6 bg-light"></div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            ))
                        ) : (
                            statCards.map((card, index) => (
                                <div key={index} className="col-xl-2 col-md-4 col-sm-6">
                                    <div className="card stats-card mb-4 overflow-hidden">
                                        <div className="card-body p-4 text-center position-relative"
                                             style={{ background: card.gradient }}>
                                            <div className="avatar-sm mx-auto mb-3">
                                                <div className="avatar-title bg-white bg-opacity-20 text-white rounded-circle fs-18">
                                                    <i className={card.icon}></i>
                                                </div>
                                            </div>
                                            <h5 className="text-white mb-1 fw-bold fs-24">{card.value}</h5>
                                            <p className="text-white-75 mb-0 fs-13 fw-medium">{card.title}</p>
                                            
                                            {/* Background decoration */}
                                            <div className="position-absolute top-0 end-0 p-2 opacity-25">
                                                <i className={`${card.icon} display-4`}></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            ))
                        )}
                    </div>

                    {/* Action Cards Grid */}
                    <div className="row">
                        {/* Quick Actions */}
                        <div className="col-xl-8">
                            <div className="card">
                                <div className="card-header align-items-center d-flex">
                                    <h4 className="card-title mb-0 flex-grow-1">
                                        <i className="ri-flashlight-line me-2 text-primary"></i>
                                        Schnellaktionen
                                    </h4>
                                </div>
                                <div className="card-body">
                                    <div className="row g-3">
                                        <div className="col-md-6 col-lg-3">
                                            <div className="card bg-success-subtle border-0 text-center h-100">
                                                <div className="card-body p-3">
                                                    <div className="avatar-sm mx-auto mb-3">
                                                        <div className="avatar-title bg-success text-white rounded-circle">
                                                            <i className="ri-add-line fs-16"></i>
                                                        </div>
                                                    </div>
                                                    <h6 className="mb-2 fw-semibold">Neuer Bericht</h6>
                                                    <p className="text-muted mb-3 fs-12">Mängel und Probleme melden</p>
                                                    <a href="/dashboard/reports/new" className="btn btn-success btn-sm">
                                                        Erstellen
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                        <div className="col-md-6 col-lg-3">
                                            <div className="card bg-info-subtle border-0 text-center h-100">
                                                <div className="card-body p-3">
                                                    <div className="avatar-sm mx-auto mb-3">
                                                        <div className="avatar-title bg-info text-white rounded-circle">
                                                            <i className="ri-megaphone-line fs-16"></i>
                                                        </div>
                                                    </div>
                                                    <h6 className="mb-2 fw-semibold">Bekanntmachung</h6>
                                                    <p className="text-muted mb-3 fs-12">Offizielle Mitteilungen</p>
                                                    <a href="/dashboard/notices/new" className="btn btn-info btn-sm">
                                                        Erstellen
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                        <div className="col-md-6 col-lg-3">
                                            <div className="card bg-warning-subtle border-0 text-center h-100">
                                                <div className="card-body p-3">
                                                    <div className="avatar-sm mx-auto mb-3">
                                                        <div className="avatar-title bg-warning text-white rounded-circle">
                                                            <i className="ri-calendar-event-line fs-16"></i>
                                                        </div>
                                                    </div>
                                                    <h6 className="mb-2 fw-semibold">Veranstaltung</h6>
                                                    <p className="text-muted mb-3 fs-12">Events und Termine</p>
                                                    <a href="/dashboard/events/new" className="btn btn-warning btn-sm">
                                                        Erstellen
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                        <div className="col-md-6 col-lg-3">
                                            <div className="card bg-primary-subtle border-0 text-center h-100">
                                                <div className="card-body p-3">
                                                    <div className="avatar-sm mx-auto mb-3">
                                                        <div className="avatar-title bg-primary text-white rounded-circle">
                                                            <i className="ri-settings-3-line fs-16"></i>
                                                        </div>
                                                    </div>
                                                    <h6 className="mb-2 fw-semibold">Einstellungen</h6>
                                                    <p className="text-muted mb-3 fs-12">System konfigurieren</p>
                                                    <a href="/dashboard/settings" className="btn btn-primary btn-sm">
                                                        Öffnen
                                                    </a>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        {/* System Status */}
                        <div className="col-xl-4">
                            <div className="card">
                                <div className="card-header">
                                    <h4 className="card-title mb-0">
                                        <i className="ri-pulse-line me-2 text-success"></i>
                                        System Status
                                    </h4>
                                </div>
                                <div className="card-body">
                                    <div className="d-flex align-items-center mb-3">
                                        <div className="avatar-xs me-3">
                                            <span className="avatar-title rounded-circle bg-success-subtle text-success">
                                                <i className="ri-checkbox-circle-line"></i>
                                            </span>
                                        </div>
                                        <div className="flex-grow-1">
                                            <h6 className="mb-1 fs-14">WordPress CMS</h6>
                                            <p className="text-muted mb-0 fs-13">Betriebsbereit</p>
                                        </div>
                                        <div className="flex-shrink-0">
                                            <span className="badge bg-success-subtle text-success">Online</span>
                                        </div>
                                    </div>
                                    
                                    <div className="d-flex align-items-center mb-3">
                                        <div className="avatar-xs me-3">
                                            <span className="avatar-title rounded-circle bg-success-subtle text-success">
                                                <i className="ri-checkbox-circle-line"></i>
                                            </span>
                                        </div>
                                        <div className="flex-grow-1">
                                            <h6 className="mb-1 fs-14">Dashboard API</h6>
                                            <p className="text-muted mb-0 fs-13">Verfügbar</p>
                                        </div>
                                        <div className="flex-shrink-0">
                                            <span className="badge bg-success-subtle text-success">Online</span>
                                        </div>
                                    </div>
                                    
                                    <div className="d-flex align-items-center">
                                        <div className="avatar-xs me-3">
                                            <span className="avatar-title rounded-circle bg-success-subtle text-success">
                                                <i className="ri-checkbox-circle-line"></i>
                                            </span>
                                        </div>
                                        <div className="flex-grow-1">
                                            <h6 className="mb-1 fs-14">Database</h6>
                                            <p className="text-muted mb-0 fs-13">Verbunden</p>
                                        </div>
                                        <div className="flex-shrink-0">
                                            <span className="badge bg-success-subtle text-success">Online</span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </VelzonLayout>
    );
}
