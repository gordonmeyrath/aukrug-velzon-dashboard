'use client';

import { ReactNode } from 'react';
import VelzonSidebar from './VelzonSidebar';
import VelzonTopbar from './VelzonTopbar';

interface VelzonLayoutProps {
    children: ReactNode;
}

export default function VelzonLayout({ children }: VelzonLayoutProps) {
    return (
        <div id="layout-wrapper">
            {/* Topbar */}
            <VelzonTopbar />
            
            {/* Sidebar */}
            <VelzonSidebar />
            
            {/* Vertical Overlay for Mobile */}
            <div className="vertical-overlay"></div>
            
            {/* Main Content */}
            <div className="main-content">
                {children}
                
                {/* Footer */}
                <footer className="footer">
                    <div className="container-fluid">
                        <div className="row">
                            <div className="col-sm-6">
                                © {new Date().getFullYear()} Aukrug Dashboard. Powered by Velzon Interactive.
                            </div>
                            <div className="col-sm-6">
                                <div className="text-sm-end d-none d-sm-block">
                                    Design & Develop by{' '}
                                    <a href="#!" className="text-decoration-underline">
                                        Themesbrand
                                    </a>
                                </div>
                            </div>
                        </div>
                    </div>
                </footer>
            </div>
        </div>
    );
}
