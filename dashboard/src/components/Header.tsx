'use client';

interface HeaderProps {
    onToggleSidebar: () => void;
}

export default function Header({ onToggleSidebar }: HeaderProps) {
    return (
        <header className="header bg-white border-bottom sticky-top">
            <div className="d-flex align-items-center justify-content-between p-3">
                {/* Mobile Menu Toggle */}
                <button
                    className="btn btn-link d-lg-none p-0 border-0"
                    onClick={onToggleSidebar}
                    aria-label="Toggle Sidebar"
                >
                    <i className="fas fa-bars fs-4 text-dark"></i>
                </button>

                {/* Breadcrumb / Title */}
                <div className="flex-grow-1 d-none d-lg-block">
                    <nav aria-label="breadcrumb">
                        <ol className="breadcrumb mb-0">
                            <li className="breadcrumb-item">
                                <i className="fas fa-home me-1"></i>
                                Dashboard
                            </li>
                        </ol>
                    </nav>
                </div>

                {/* Header Actions */}
                <div className="d-flex align-items-center gap-3">
                    {/* Notifications */}
                    <div className="dropdown">
                        <button
                            className="btn btn-link p-0 border-0 position-relative"
                            data-bs-toggle="dropdown"
                            aria-expanded="false"
                        >
                            <i className="fas fa-bell fs-5 text-muted"></i>
                            <span className="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                3
                            </span>
                        </button>
                        <ul className="dropdown-menu dropdown-menu-end shadow">
                            <li><h6 className="dropdown-header">Benachrichtigungen</h6></li>
                            <li><a className="dropdown-item" href="#">Neue Bürgermeldung</a></li>
                            <li><a className="dropdown-item" href="#">Community-Beitrag</a></li>
                            <li><a className="dropdown-item" href="#">System-Update</a></li>
                            <li><hr className="dropdown-divider" /></li>
                            <li><a className="dropdown-item text-center" href="#">Alle anzeigen</a></li>
                        </ul>
                    </div>

                    {/* User Profile */}
                    <div className="dropdown">
                        <button
                            className="btn btn-link p-0 border-0 d-flex align-items-center"
                            data-bs-toggle="dropdown"
                            aria-expanded="false"
                        >
                            <div className="bg-primary rounded-circle d-flex align-items-center justify-content-center me-2"
                                style={{ width: '32px', height: '32px' }}>
                                <i className="fas fa-user text-white"></i>
                            </div>
                            <span className="text-dark d-none d-md-inline">Administrator</span>
                            <i className="fas fa-chevron-down ms-2 text-muted"></i>
                        </button>
                        <ul className="dropdown-menu dropdown-menu-end shadow">
                            <li><h6 className="dropdown-header">Administrator</h6></li>
                            <li><a className="dropdown-item" href="#"><i className="fas fa-user me-2"></i>Profil</a></li>
                            <li><a className="dropdown-item" href="#"><i className="fas fa-cog me-2"></i>Einstellungen</a></li>
                            <li><hr className="dropdown-divider" /></li>
                            <li><a className="dropdown-item" href="#"><i className="fas fa-sign-out-alt me-2"></i>Abmelden</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </header>
    );
}
