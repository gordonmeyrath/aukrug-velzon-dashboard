'use client';

import { useState } from 'react';

export default function VelzonTopbar() {
    const [searchQuery, setSearchQuery] = useState('');
    const [showNotifications, setShowNotifications] = useState(false);
    const [showUserMenu, setShowUserMenu] = useState(false);

    const notifications = [
        {
            id: 1,
            title: 'Neuer Bericht eingegangen',
            message: 'Straßenschaden in der Hauptstraße gemeldet',
            time: '2 Min',
            read: false,
            icon: 'ri-file-list-line',
            color: 'primary',
        },
        {
            id: 2,
            title: 'Bekanntmachung veröffentlicht',
            message: 'Gemeinderatssitzung für nächste Woche geplant',
            time: '1 Std',
            read: true,
            icon: 'ri-megaphone-line',
            color: 'success',
        },
        {
            id: 3,
            title: 'System Update',
            message: 'Dashboard wurde erfolgreich aktualisiert',
            time: '3 Std',
            read: false,
            icon: 'ri-refresh-line',
            color: 'info',
        },
    ];

    const unreadCount = notifications.filter(n => !n.read).length;

    return (
        <header id="page-topbar">
            <div className="layout-width">
                <div className="navbar-header">
                    <div className="d-flex">
                        {/* Hamburger Menu */}
                        <div className="navbar-brand-box horizontal-logo">
                            <a href="/dashboard" className="logo logo-dark">
                                <span className="logo-sm">
                                    <div className="avatar-xs">
                                        <span className="avatar-title rounded-circle bg-primary text-white">
                                            <i className="ri-leaf-line fs-16"></i>
                                        </span>
                                    </div>
                                </span>
                            </a>
                        </div>

                        <button
                            type="button"
                            className="btn btn-sm px-3 fs-16 header-item vertical-menu-btn topnav-hamburger shadow-none"
                            id="topnav-hamburger-icon"
                        >
                            <span className="hamburger-icon">
                                <span></span>
                                <span></span>
                                <span></span>
                            </span>
                        </button>

                        {/* Search */}
                        <form className="app-search d-none d-md-block">
                            <div className="position-relative">
                                <input
                                    type="text"
                                    className="form-control"
                                    placeholder="Durchsuchen..."
                                    autoComplete="off"
                                    id="search-options"
                                    value={searchQuery}
                                    onChange={(e) => setSearchQuery(e.target.value)}
                                />
                                <span className="mdi mdi-magnify search-widget-icon"></span>
                                <span className="mdi mdi-close-circle search-widget-icon search-widget-icon-close d-none" id="search-close-options"></span>
                            </div>
                            <div className="dropdown-menu dropdown-menu-lg" id="search-dropdown">
                                <div data-simplebar style={{ maxHeight: '320px' }}>
                                    {/* Search results would go here */}
                                </div>
                            </div>
                        </form>
                    </div>

                    <div className="d-flex align-items-center">
                        {/* Search for Mobile */}
                        <div className="dropdown d-md-none topbar-head-dropdown header-item">
                            <button
                                type="button"
                                className="btn btn-icon btn-topbar btn-ghost-secondary rounded-circle shadow-none"
                                id="page-header-search-dropdown"
                                data-bs-toggle="dropdown"
                                aria-haspopup="true"
                                aria-expanded="false"
                            >
                                <i className="bx bx-search fs-22"></i>
                            </button>
                            <div className="dropdown-menu dropdown-menu-lg dropdown-menu-end p-0">
                                <form className="p-3">
                                    <div className="form-group m-0">
                                        <div className="input-group">
                                            <input
                                                type="text"
                                                className="form-control"
                                                placeholder="Durchsuchen..."
                                                aria-label="Recipient's username"
                                            />
                                            <button className="btn btn-primary" type="submit">
                                                <i className="mdi mdi-magnify"></i>
                                            </button>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                        {/* Language Dropdown */}
                        <div className="dropdown ms-1 topbar-head-dropdown header-item">
                            <button
                                type="button"
                                className="btn btn-icon btn-topbar btn-ghost-secondary rounded-circle shadow-none"
                                data-bs-toggle="dropdown"
                                aria-haspopup="true"
                                aria-expanded="false"
                            >
                                <img
                                    id="header-lang-img"
                                    src="https://themesbrand.com/velzon/html/master/assets/images/flags/germany.svg"
                                    alt="Germany"
                                    height="20"
                                    className="rounded"
                                />
                            </button>
                            <div className="dropdown-menu dropdown-menu-end">
                                <a href="#!" className="dropdown-item notify-item language py-2" data-lang="de">
                                    <img
                                        src="https://themesbrand.com/velzon/html/master/assets/images/flags/germany.svg"
                                        alt="Germany"
                                        className="me-2 rounded"
                                        height="18"
                                    />
                                    <span className="align-middle">Deutsch</span>
                                </a>
                                <a href="#!" className="dropdown-item notify-item language py-2" data-lang="en">
                                    <img
                                        src="https://themesbrand.com/velzon/html/master/assets/images/flags/us.svg"
                                        alt="English"
                                        className="me-2 rounded"
                                        height="18"
                                    />
                                    <span className="align-middle">English</span>
                                </a>
                            </div>
                        </div>

                        {/* Notifications */}
                        <div className="dropdown topbar-head-dropdown ms-1 header-item">
                            <button
                                type="button"
                                className="btn btn-icon btn-topbar btn-ghost-secondary rounded-circle shadow-none"
                                id="page-header-notifications-dropdown"
                                data-bs-toggle="dropdown"
                                data-bs-auto-close="outside"
                                aria-haspopup="true"
                                aria-expanded="false"
                                onClick={() => setShowNotifications(!showNotifications)}
                            >
                                <i className="bx bx-bell fs-22"></i>
                                {unreadCount > 0 && (
                                    <span className="position-absolute topbar-badge fs-10 translate-middle badge rounded-pill bg-danger">
                                        {unreadCount}
                                        <span className="visually-hidden">ungelesene Nachrichten</span>
                                    </span>
                                )}
                            </button>
                            {showNotifications && (
                                <div className="dropdown-menu dropdown-menu-lg dropdown-menu-end p-0 show">
                                    <div className="dropdown-head bg-primary bg-pattern rounded-top">
                                        <div className="p-3">
                                            <div className="row align-items-center">
                                                <div className="col">
                                                    <h6 className="m-0 fs-16 fw-semibold text-white">Benachrichtigungen</h6>
                                                </div>
                                                <div className="col-auto dropdown-tabs">
                                                    <span className="badge bg-light text-body fs-13">
                                                        {notifications.length} Neu
                                                    </span>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div className="tab-content position-relative" id="notificationItemsTabContent">
                                        <div className="tab-pane fade show active py-2 ps-2" style={{ maxHeight: '300px', overflowY: 'auto' }}>
                                            <div data-simplebar>
                                                {notifications.map((notification) => (
                                                    <div key={notification.id} className={`text-reset notification-item d-block dropdown-item position-relative ${!notification.read ? 'unread-message' : ''}`}>
                                                        <div className="d-flex">
                                                            <div className="avatar-xs me-3 flex-shrink-0">
                                                                <span className={`avatar-title bg-${notification.color}-subtle text-${notification.color} rounded-circle fs-16`}>
                                                                    <i className={notification.icon}></i>
                                                                </span>
                                                            </div>
                                                            <div className="flex-grow-1">
                                                                <a href="#!" className="stretched-link">
                                                                    <h6 className="mt-0 mb-2 lh-base">{notification.title}</h6>
                                                                </a>
                                                                <p className="mb-0 fs-11 fw-medium text-uppercase text-muted">
                                                                    <span><i className="mdi mdi-clock-outline"></i> {notification.time}</span>
                                                                </p>
                                                            </div>
                                                            <div className="px-2 fs-15">
                                                                <div className="form-check notification-check">
                                                                    <input 
                                                                        className="form-check-input" 
                                                                        type="checkbox" 
                                                                        value="" 
                                                                        id={`all-notification-check${notification.id}`}
                                                                    />
                                                                    <label 
                                                                        className="form-check-label" 
                                                                        htmlFor={`all-notification-check${notification.id}`}
                                                                    ></label>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                ))}
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            )}
                        </div>

                        {/* Dark/Light Mode Toggle */}
                        <div className="ms-1 header-item d-none d-sm-flex">
                            <button
                                type="button"
                                className="btn btn-icon btn-topbar btn-ghost-secondary rounded-circle shadow-none"
                                data-toggle="dark-mode"
                            >
                                <i className="bx bx-moon fs-22"></i>
                            </button>
                        </div>

                        {/* User Profile */}
                        <div className="dropdown ms-sm-3 header-item topbar-user">
                            <button
                                type="button"
                                className="btn shadow-none"
                                id="page-header-user-dropdown"
                                data-bs-toggle="dropdown"
                                aria-haspopup="true"
                                aria-expanded="false"
                                onClick={() => setShowUserMenu(!showUserMenu)}
                            >
                                <span className="d-flex align-items-center">
                                    <img
                                        className="rounded-circle header-profile-user"
                                        src="https://themesbrand.com/velzon/html/master/assets/images/users/avatar-1.jpg"
                                        alt="Header Avatar"
                                    />
                                    <span className="text-start ms-xl-2">
                                        <span className="d-none d-xl-inline-block ms-1 fw-medium user-name-text">Admin Benutzer</span>
                                        <span className="d-none d-xl-block ms-1 fs-12 user-name-sub-text text-muted">Administrator</span>
                                    </span>
                                </span>
                            </button>
                            {showUserMenu && (
                                <div className="dropdown-menu dropdown-menu-end show">
                                    <h6 className="dropdown-header">Willkommen Admin!</h6>
                                    <a className="dropdown-item" href="/dashboard/profile">
                                        <i className="mdi mdi-account-circle text-muted fs-16 align-middle me-1"></i>
                                        <span className="align-middle">Profil</span>
                                    </a>
                                    <a className="dropdown-item" href="/dashboard/messages">
                                        <i className="mdi mdi-message-text-outline text-muted fs-16 align-middle me-1"></i>
                                        <span className="align-middle">Nachrichten</span>
                                    </a>
                                    <a className="dropdown-item" href="/dashboard/taskboard">
                                        <i className="mdi mdi-calendar-check-outline text-muted fs-16 align-middle me-1"></i>
                                        <span className="align-middle">Aufgaben</span>
                                    </a>
                                    <a className="dropdown-item" href="/dashboard/help">
                                        <i className="mdi mdi-lifebuoy text-muted fs-16 align-middle me-1"></i>
                                        <span className="align-middle">Hilfe</span>
                                    </a>
                                    <div className="dropdown-divider"></div>
                                    <a className="dropdown-item" href="/dashboard/profile/balance">
                                        <i className="mdi mdi-wallet text-muted fs-16 align-middle me-1"></i>
                                        <span className="align-middle">
                                            Balance : <b>$5971.67</b>
                                        </span>
                                    </a>
                                    <a className="dropdown-item" href="/dashboard/settings">
                                        <span className="badge bg-success-subtle text-success mt-1 float-end">Neu</span>
                                        <i className="mdi mdi-cog-outline text-muted fs-16 align-middle me-1"></i>
                                        <span className="align-middle">Einstellungen</span>
                                    </a>
                                    <a className="dropdown-item" href="/dashboard/auth/lockscreen">
                                        <i className="mdi mdi-lock text-muted fs-16 align-middle me-1"></i>
                                        <span className="align-middle">Sperren</span>
                                    </a>
                                    <a className="dropdown-item" href="/auth/logout">
                                        <i className="mdi mdi-logout text-muted fs-16 align-middle me-1"></i>
                                        <span className="align-middle" data-key="t-logout">Abmelden</span>
                                    </a>
                                </div>
                            )}
                        </div>
                    </div>
                </div>
            </div>
        </header>
    );
}
