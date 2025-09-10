'use client';

import Header from '@/components/Header';
import Sidebar from '@/components/Sidebar';
import { useApi } from '@/lib/api-client';
import { useEffect, useState } from 'react';

export default function CommunityPage() {
    const [sidebarOpen, setSidebarOpen] = useState(false);
    const [users, setUsers] = useState<any[]>([]);
    const [groups, setGroups] = useState<any[]>([]);
    const [loading, setLoading] = useState(true);
    const [activeTab, setActiveTab] = useState('users');
    const api = useApi();

    useEffect(() => {
        loadData();
    }, []);

    const loadData = async () => {
        setLoading(true);
        try {
            const [usersResponse, groupsResponse] = await Promise.all([
                api.getCommunityUsers(),
                api.getCommunityGroups()
            ]);

            if (usersResponse.data) {
                setUsers(usersResponse.data);
            }
            if (groupsResponse.data) {
                setGroups(groupsResponse.data);
            }
        } catch (error) {
            console.error('Error loading community data:', error);
        } finally {
            setLoading(false);
        }
    };

    return (
        <>
            <Sidebar isOpen={sidebarOpen} onToggle={() => setSidebarOpen(!sidebarOpen)} />
            <div className="main-content">
                <Header onToggleSidebar={() => setSidebarOpen(!sidebarOpen)} />

                <div className="page-title-box">
                    <h4 className="page-title">Community Verwaltung</h4>
                    <p className="text-muted">Verwalten Sie Community-Mitglieder und Gruppen</p>
                </div>

                {/* Tab Navigation */}
                <ul className="nav nav-tabs mb-4">
                    <li className="nav-item">
                        <button
                            className={`nav-link ${activeTab === 'users' ? 'active' : ''}`}
                            onClick={() => setActiveTab('users')}
                        >
                            <i className="fas fa-users me-2"></i>
                            Mitglieder
                        </button>
                    </li>
                    <li className="nav-item">
                        <button
                            className={`nav-link ${activeTab === 'groups' ? 'active' : ''}`}
                            onClick={() => setActiveTab('groups')}
                        >
                            <i className="fas fa-layer-group me-2"></i>
                            Gruppen
                        </button>
                    </li>
                    <li className="nav-item">
                        <button
                            className={`nav-link ${activeTab === 'settings' ? 'active' : ''}`}
                            onClick={() => setActiveTab('settings')}
                        >
                            <i className="fas fa-cog me-2"></i>
                            Einstellungen
                        </button>
                    </li>
                </ul>

                {loading ? (
                    <div className="d-flex justify-content-center py-5">
                        <div className="spinner-border text-primary" role="status">
                            <span className="visually-hidden">Laden...</span>
                        </div>
                    </div>
                ) : (
                    <>
                        {/* Users Tab */}
                        {activeTab === 'users' && (
                            <div className="card">
                                <div className="card-header d-flex justify-content-between align-items-center">
                                    <h5 className="card-title mb-0">Community-Mitglieder</h5>
                                    <button className="btn btn-primary">
                                        <i className="fas fa-plus me-2"></i>
                                        Neues Mitglied
                                    </button>
                                </div>
                                <div className="card-body">
                                    <div className="table-responsive">
                                        <table className="table table-hover">
                                            <thead>
                                                <tr>
                                                    <th>Name</th>
                                                    <th>E-Mail</th>
                                                    <th>Status</th>
                                                    <th>Registriert</th>
                                                    <th>Aktionen</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                {users.length === 0 ? (
                                                    <tr>
                                                        <td colSpan={5} className="text-center text-muted py-4">
                                                            Keine Community-Mitglieder verfügbar
                                                        </td>
                                                    </tr>
                                                ) : (
                                                    users.map((user: any, index) => (
                                                        <tr key={index}>
                                                            <td>
                                                                <div className="d-flex align-items-center">
                                                                    <div className="bg-primary rounded-circle d-flex align-items-center justify-content-center me-3"
                                                                        style={{ width: '40px', height: '40px' }}>
                                                                        <i className="fas fa-user text-white"></i>
                                                                    </div>
                                                                    <div>
                                                                        <div className="fw-medium">{user.displayName || 'Unbekannt'}</div>
                                                                        <small className="text-muted">ID: {user.id}</small>
                                                                    </div>
                                                                </div>
                                                            </td>
                                                            <td>{user.email}</td>
                                                            <td>
                                                                <span className={`badge ${user.isActive ? 'bg-success' : 'bg-secondary'}`}>
                                                                    {user.isActive ? 'Aktiv' : 'Inaktiv'}
                                                                </span>
                                                            </td>
                                                            <td>{new Date(user.registeredAt).toLocaleDateString('de-DE')}</td>
                                                            <td>
                                                                <div className="btn-group btn-group-sm">
                                                                    <button className="btn btn-outline-primary">
                                                                        <i className="fas fa-edit"></i>
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
                                </div>
                            </div>
                        )}

                        {/* Groups Tab */}
                        {activeTab === 'groups' && (
                            <div className="card">
                                <div className="card-header d-flex justify-content-between align-items-center">
                                    <h5 className="card-title mb-0">Community-Gruppen</h5>
                                    <button className="btn btn-primary">
                                        <i className="fas fa-plus me-2"></i>
                                        Neue Gruppe
                                    </button>
                                </div>
                                <div className="card-body">
                                    <div className="row">
                                        {groups.length === 0 ? (
                                            <div className="col-12">
                                                <div className="text-center text-muted py-4">
                                                    Keine Community-Gruppen verfügbar
                                                </div>
                                            </div>
                                        ) : (
                                            groups.map((group: any, index) => (
                                                <div key={index} className="col-md-6 col-lg-4 mb-4">
                                                    <div className="card h-100">
                                                        <div className="card-body">
                                                            <div className="d-flex align-items-start justify-content-between mb-3">
                                                                <div className="bg-success rounded p-2">
                                                                    <i className="fas fa-layer-group text-white"></i>
                                                                </div>
                                                                <span className={`badge ${group.isPublic ? 'bg-success' : 'bg-warning'}`}>
                                                                    {group.isPublic ? 'Öffentlich' : 'Privat'}
                                                                </span>
                                                            </div>
                                                            <h6 className="card-title">{group.name}</h6>
                                                            <p className="card-text text-muted small">{group.description}</p>
                                                            <div className="d-flex justify-content-between align-items-center">
                                                                <small className="text-muted">
                                                                    <i className="fas fa-users me-1"></i>
                                                                    {group.memberCount || 0} Mitglieder
                                                                </small>
                                                                <div className="btn-group btn-group-sm">
                                                                    <button className="btn btn-outline-primary">
                                                                        <i className="fas fa-edit"></i>
                                                                    </button>
                                                                    <button className="btn btn-outline-danger">
                                                                        <i className="fas fa-trash"></i>
                                                                    </button>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            ))
                                        )}
                                    </div>
                                </div>
                            </div>
                        )}

                        {/* Settings Tab */}
                        {activeTab === 'settings' && (
                            <div className="card">
                                <div className="card-header">
                                    <h5 className="card-title mb-0">Community-Einstellungen</h5>
                                </div>
                                <div className="card-body">
                                    <form>
                                        <div className="row">
                                            <div className="col-md-6 mb-3">
                                                <label className="form-label">Registrierung erlauben</label>
                                                <select className="form-select">
                                                    <option value="true">Ja</option>
                                                    <option value="false">Nein</option>
                                                </select>
                                            </div>
                                            <div className="col-md-6 mb-3">
                                                <label className="form-label">Automatische Verifizierung</label>
                                                <select className="form-select">
                                                    <option value="false">Nein</option>
                                                    <option value="true">Ja</option>
                                                </select>
                                            </div>
                                            <div className="col-md-6 mb-3">
                                                <label className="form-label">Maximale Gruppengröße</label>
                                                <input type="number" className="form-control" defaultValue="50" />
                                            </div>
                                            <div className="col-md-6 mb-3">
                                                <label className="form-label">Moderationsebene</label>
                                                <select className="form-select">
                                                    <option value="low">Niedrig</option>
                                                    <option value="medium" selected>Mittel</option>
                                                    <option value="high">Hoch</option>
                                                </select>
                                            </div>
                                        </div>
                                        <div className="d-flex gap-2">
                                            <button type="submit" className="btn btn-primary">
                                                <i className="fas fa-save me-2"></i>
                                                Speichern
                                            </button>
                                            <button type="reset" className="btn btn-secondary">
                                                <i className="fas fa-undo me-2"></i>
                                                Zurücksetzen
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        )}
                    </>
                )}
            </div>
        </>
    );
}
