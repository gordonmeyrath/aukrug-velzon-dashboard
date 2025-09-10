'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

interface SidebarItem {
    title: string;
    href: string;
    icon: string;
    badge?: string;
    children?: SidebarItem[];
}

const sidebarItems: SidebarItem[] = [
    {
        title: 'Dashboard',
        href: '/dashboard',
        icon: 'ri-dashboard-2-line',
    },
    {
        title: 'Berichte',
        href: '/dashboard/reports',
        icon: 'ri-file-list-3-line',
        badge: '12',
        children: [
            {
                title: 'Alle Berichte',
                href: '/dashboard/reports',
                icon: 'ri-list-check',
            },
            {
                title: 'Neuer Bericht',
                href: '/dashboard/reports/new',
                icon: 'ri-add-circle-line',
            },
            {
                title: 'Offene Berichte',
                href: '/dashboard/reports/pending',
                icon: 'ri-alarm-warning-line',
            },
        ],
    },
    {
        title: 'Bekanntmachungen',
        href: '/dashboard/notices',
        icon: 'ri-megaphone-line',
    },
    {
        title: 'Veranstaltungen',
        href: '/dashboard/events',
        icon: 'ri-calendar-event-line',
    },
    {
        title: 'Downloads',
        href: '/dashboard/downloads',
        icon: 'ri-download-cloud-2-line',
    },
    {
        title: 'Gemeinschaft',
        href: '/dashboard/community',
        icon: 'ri-group-line',
        children: [
            {
                title: 'Übersicht',
                href: '/dashboard/community',
                icon: 'ri-group-line',
            },
            {
                title: 'Benutzer',
                href: '/dashboard/community/users',
                icon: 'ri-user-line',
            },
            {
                title: 'Rollen',
                href: '/dashboard/community/roles',
                icon: 'ri-shield-user-line',
            },
        ],
    },
    {
        title: 'Einstellungen',
        href: '/dashboard/settings',
        icon: 'ri-settings-3-line',
    },
];

export default function VelzonSidebar() {
    const pathname = usePathname();

    const isActive = (href: string) => {
        if (href === '/dashboard' && pathname === '/dashboard') {
            return true;
        }
        return pathname?.startsWith(href) && href !== '/dashboard';
    };

    const renderSidebarItem = (item: SidebarItem, isChild = false) => {
        const active = isActive(item.href);
        const hasChildren = item.children && item.children.length > 0;

        if (hasChildren) {
            return (
                <li className="nav-item" key={item.href}>
                    <a
                        className={`nav-link menu-link ${active ? 'active' : ''}`}
                        href="#sidebarReports"
                        data-bs-toggle="collapse"
                        role="button"
                        aria-expanded={active}
                        aria-controls="sidebarReports"
                    >
                        <i className={item.icon}></i>
                        <span data-key="t-reports">{item.title}</span>
                        {item.badge && (
                            <span className="badge badge-pill bg-danger ms-auto">{item.badge}</span>
                        )}
                    </a>
                    <div className={`collapse menu-dropdown ${active ? 'show' : ''}`} id="sidebarReports">
                        <ul className="nav nav-sm flex-column">
                            {item.children?.map((child) => (
                                <li className="nav-item" key={child.href}>
                                    <Link
                                        href={child.href}
                                        className={`nav-link ${isActive(child.href) ? 'active' : ''}`}
                                        data-key={`t-${child.title.toLowerCase().replace(/\\s+/g, '-')}`}
                                    >
                                        {child.title}
                                    </Link>
                                </li>
                            ))}
                        </ul>
                    </div>
                </li>
            );
        }

        return (
            <li className="nav-item" key={item.href}>
                <Link
                    href={item.href}
                    className={`nav-link menu-link ${active ? 'active' : ''}`}
                    data-key={`t-${item.title.toLowerCase().replace(/\\s+/g, '-')}`}
                >
                    <i className={item.icon}></i>
                    <span>{item.title}</span>
                    {item.badge && (
                        <span className="badge badge-pill bg-danger ms-auto">{item.badge}</span>
                    )}
                </Link>
            </li>
        );
    };

    return (
        <div className="app-menu navbar-menu">
            <div className="navbar-brand-box">
                {/* Dark Logo */}
                <Link href="/dashboard" className="logo logo-dark">
                    <span className="logo-sm">
                        <div className="avatar-xs">
                            <span className="avatar-title rounded-circle bg-primary text-white">
                                <i className="ri-leaf-line fs-16"></i>
                            </span>
                        </div>
                    </span>
                    <span className="logo-lg">
                        <div className="d-flex align-items-center">
                            <div className="avatar-sm me-2">
                                <span className="avatar-title rounded-circle bg-primary text-white">
                                    <i className="ri-leaf-line fs-18"></i>
                                </span>
                            </div>
                            <div>
                                <h5 className="mb-0 text-white">Aukrug</h5>
                                <small className="text-white-75">Admin Panel</small>
                            </div>
                        </div>
                    </span>
                </Link>
                
                {/* Light Logo */}
                <Link href="/dashboard" className="logo logo-light">
                    <span className="logo-sm">
                        <div className="avatar-xs">
                            <span className="avatar-title rounded-circle bg-primary text-white">
                                <i className="ri-leaf-line fs-16"></i>
                            </span>
                        </div>
                    </span>
                    <span className="logo-lg">
                        <div className="d-flex align-items-center">
                            <div className="avatar-sm me-2">
                                <span className="avatar-title rounded-circle bg-primary text-white">
                                    <i className="ri-leaf-line fs-18"></i>
                                </span>
                            </div>
                            <div>
                                <h5 className="mb-0 text-white">Aukrug</h5>
                                <small className="text-white-75">Admin Panel</small>
                            </div>
                        </div>
                    </span>
                </Link>

                <button
                    type="button"
                    className="btn btn-sm p-0 fs-20 header-item float-end btn-vertical-sm-hover"
                    id="vertical-hover"
                >
                    <i className="ri-record-circle-line"></i>
                </button>
            </div>

            <div id="scrollbar">
                <div className="container-fluid">
                    <div id="two-column-menu"></div>
                    <ul className="navbar-nav" id="navbar-nav">
                        <li className="menu-title">
                            <span data-key="t-menu">Hauptmenü</span>
                        </li>
                        
                        {sidebarItems.map((item) => renderSidebarItem(item))}
                        
                        <li className="menu-title">
                            <span data-key="t-system">System</span>
                        </li>
                        
                        <li className="nav-item">
                            <Link
                                href="/dashboard/system/logs"
                                className="nav-link menu-link"
                                data-key="t-logs"
                            >
                                <i className="ri-file-text-line"></i>
                                <span>System Logs</span>
                            </Link>
                        </li>
                        
                        <li className="nav-item">
                            <Link
                                href="/dashboard/system/backup"
                                className="nav-link menu-link"
                                data-key="t-backup"
                            >
                                <i className="ri-hard-drive-2-line"></i>
                                <span>Backup</span>
                            </Link>
                        </li>
                    </ul>
                </div>
            </div>

            <div className="sidebar-background"></div>
        </div>
    );
}
