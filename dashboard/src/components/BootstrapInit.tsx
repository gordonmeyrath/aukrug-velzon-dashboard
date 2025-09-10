'use client';

import { useEffect } from 'react';

export default function BootstrapInit() {
    useEffect(() => {
        // Dynamically import Bootstrap JS only on client side
        const initBootstrap = async () => {
            if (typeof window !== 'undefined') {
                // @ts-ignore
                const bootstrap = await import('bootstrap/dist/js/bootstrap.bundle.min.js');

                // Initialize tooltips
                const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
                tooltipTriggerList.forEach(tooltipTriggerEl => {
                    new bootstrap.Tooltip(tooltipTriggerEl);
                });
            }
        };

        initBootstrap();
    }, []);

    return null;
}
