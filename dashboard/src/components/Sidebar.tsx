'use client';

import Link from 'next/link';
import { usePathname } from 'next/navigation';

interface SidebarProps {
    isOpen: boolean;
    onToggle: () => void;
}

const menuItems = [
    {
        title: 'Dashboard',
        icon: 'fas fa-tachometer-alt',
        href: '/dashboard/',
    },
    {
        title: 'Community',
        icon: 'fas fa-users',
        href: '/dashboard/community/',
    },
    {
        title: 'Wanderwege',
        icon: 'fas fa-route',
        href: '/dashboard/routes/',
    },
    {
        title: 'Meldungen',
        icon: 'fas fa-exclamation-triangle',
        href: '/dashboard/reports/',
    },
    {
        title: 'Termine',
        icon: 'fas fa-calendar-alt',
        href: '/dashboard/events/',
    },
    {
        title: 'Downloads',
        icon: 'fas fa-download',
        href: '/dashboard/downloads/',
    },
    {
        title: 'Geocaching',
        icon: 'fas fa-map-marker-alt',
        href: '/dashboard/geocaching/',
    },
    {
        title: 'Marktplatz',
        icon: 'fas fa-shopping-cart',
        href: '/dashboard/marketplace/',
    },
    {
        title: 'Verifizierung',
        icon: 'fas fa-shield-alt',
        href: '/dashboard/verification/',
    },
    {
        title: 'Nachrichten',
        icon: 'fas fa-envelope',
        href: '/dashboard/messenger/',
    },
    {
        title: 'Hinweise',
        icon: 'fas fa-bell',
        href: '/dashboard/notices/',
    },
    {
        title: 'Synchronisation',
        icon: 'fas fa-sync',
        href: '/dashboard/sync/',
    },
    {
        title: 'Einstellungen',
        icon: 'fas fa-cog',
        href: '/dashboard/settings/',
    },
];

export default function Sidebar({ isOpen, onToggle }: SidebarProps) {
    const pathname = usePathname();

    return (
        <>
            {/* Sidebar Overlay for Mobile */}
            {isOpen && (
                <div
                    className="position-fixed top-0 start-0 w-100 h-100 bg-dark opacity-50 d-lg-none"
                    style={{ zIndex: 1040 }}
                    onClick={onToggle}
                />
            )}

            {/* Sidebar */}
            <div
                className={`sidebar position-fixed top-0 start-0 h-100 bg-white border-end d-flex flex-column ${isOpen ? 'sidebar-open' : ''
                    }`}
                style={{
                    width: 'var(--vz-sidebar-width)',
                    zIndex: 1050,
                    transform: isOpen ? 'translateX(0)' : 'translateX(-100%)',
                    transition: 'transform 0.3s ease-in-out',
                }}
            >
                {/* Sidebar Header */}
                <div className="sidebar-header p-3 border-bottom">
                    <div className="d-flex align-items-center">
                        <div className="flex-shrink-0">
                            <div className="bg-primary rounded p-2">
                                <i className="fas fa-leaf text-white fs-5"></i>
                            </div>
                        </div>
                        <div className="flex-grow-1 ms-3">
                            <h5 className="mb-0 text-dark">Aukrug</h5>
                            <small className="text-muted">Dashboard</small>
                        </div>
                    </div>
                </div>

                {/* Sidebar Navigation */}
                <nav className="sidebar-nav flex-grow-1 p-2">
                    <ul className="nav nav-pills flex-column">
                        {menuItems.map((item, index) => {
                            const isActive = pathname === item.href;
                            return (
                                <li key={index} className="nav-item mb-1">
                                    <Link
                                        href={item.href}
                                        className={`nav-link d-flex align-items-center px-3 py-2 rounded ${isActive
                                                ? 'active bg-primary text-white'
                                                : 'text-dark hover-bg-light'
                                            }`}
                                        onClick={() => window.innerWidth < 992 && onToggle()}
                                    >
                                        <i className={`${item.icon} me-3 flex-shrink-0`}></i>
                                        <span>{item.title}</span>
                                    </Link>
                                </li>
                            );
                        })}
                    </ul>
                </nav>

                {/* Sidebar Footer */}
                <div className="sidebar-footer p-3 border-top">
                    <div className="d-flex align-items-center text-muted">
                        <i className="fas fa-info-circle me-2"></i>
                        <small>Version 1.0.0</small>
                    </div>
                </div>
            </div>

            <style jsx>{`
        .sidebar {
          box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        
        .nav-link:hover:not(.active) {
          background-color: rgba(0, 0, 0, 0.05);
        }
        
        @media (min-width: 992px) {
          .sidebar {
            transform: translateX(0) !important;
          }
        }
      `}</style>
        </>
    );
}
