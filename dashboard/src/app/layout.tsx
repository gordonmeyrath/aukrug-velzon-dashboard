import type { Metadata } from 'next';
import './globals.css';

export const metadata: Metadata = {
    title: 'Aukrug Municipal Dashboard',
    description: 'Velzon Interactive Dashboard für Aukrug Gemeinde',
    icons: {
        icon: '/dashboard/favicon.ico',
    },
};

export default function RootLayout({
    children,
}: {
    children: React.ReactNode;
}) {
    return (
        <html 
            lang="de" 
            data-layout="vertical" 
            data-topbar="light" 
            data-sidebar="dark" 
            data-sidebar-size="lg" 
            data-sidebar-image="none" 
            data-theme="interactive"
            data-layout-width="fluid" 
            data-layout-position="fixed" 
            data-layout-style="default"
        >
            <head>
                <meta charSet="utf-8" />
                <meta name="viewport" content="width=device-width, initial-scale=1" />
                
                {/* Velzon Interactive Theme CSS */}
                <link 
                    href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" 
                    rel="stylesheet" 
                />
                <link 
                    href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" 
                    rel="stylesheet" 
                />
                <link 
                    href="https://cdn.jsdelivr.net/npm/remixicon@3.5.0/fonts/remixicon.css" 
                    rel="stylesheet" 
                />
                
                {/* Poppins Font */}
                <link 
                    href="https://fonts.googleapis.com/css2?family=Poppins:wght@100;200;300;400;500;600;700;800;900&display=swap" 
                    rel="stylesheet" 
                />
            </head>
            <body data-sidebar="dark">
                {children}
            </body>
        </html>
    );
}
