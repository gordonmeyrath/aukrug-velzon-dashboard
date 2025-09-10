# Aukrug LXC Dashboard Template 🏘️

Complete reusable LXC template for hosting **WordPress CMS** and **Next.js Dashboard** in a single container, designed for German municipalities using the **Aukrug Community Platform**.

## 🎯 Features

- **Dual Application Hosting**: WordPress CMS + Next.js Dashboard in one container
- **Domain-Based Routing**: `/cms/` for WordPress, `/dashboard/` for administrative interface
- **Production-Ready**: nginx reverse proxy, PM2 process management, systemd integration
- **Velzon UI**: Professional admin dashboard using Bootstrap 5 + Velzon theme components
- **Full LAMP+Node Stack**: MariaDB, PHP 8.2-FPM, Node.js 20 LTS, nginx
- **Security Hardened**: SSL-ready, security headers, file access restrictions
- **Template-Based**: Easy replication for multiple villages/municipalities

## 🚀 Quick Start

### Prerequisites

- LXC container with Debian 12 (bookworm)
- Root SSH access to target container
- Domain pointed to container IP

### One-Command Deployment

```bash
git clone <repository>
cd dashboard
make setup-complete HOST=10.0.1.12
```

This will:

1. ✅ Install complete LAMP+Node.js stack
2. ✅ Configure nginx with dual routing
3. ✅ Deploy and start Next.js dashboard  
4. ✅ Set up WordPress with database
5. ✅ Configure PM2 with systemd integration

## 🔧 System Management

### Service Management

```bash
# Check status
make status HOST=<target-ip>

# View logs  
make logs HOST=<target-ip>

# Restart services
make restart HOST=<target-ip>
```

### Current Status

✅ **WordPress CMS**: <http://10.0.1.12/cms/>  
✅ **Next.js Dashboard**: <http://10.0.1.12/dashboard/>  
✅ **PM2 Process Manager**: Running with systemd integration  
✅ **Nginx Reverse Proxy**: Configured with security headers  

## 📊 Live System

The template has been successfully deployed and tested:

- **Infrastructure**: Full LAMP+Node.js stack installed
- **WordPress**: Ready for initial setup at `/cms/`
- **Dashboard**: Live Next.js application with Velzon UI
- **Services**: PM2 managing Node.js, systemd integration complete
- **Routing**: nginx properly routing `/cms/` → WordPress, `/dashboard/` → Next.js

## 🎨 Velzon UI Components

Professional admin interface using Bootstrap 5 + Velzon theme:

- Dashboard overview with statistics cards
- Community management interface
- Reports (Mängelmelder) system  
- Responsive sidebar navigation
- Modern data tables and forms

## Features

- **Community Management**: Verwaltung von Mitgliedern und Gruppen
- **Wanderwege**: Routen und Trails verwalten  
- **Meldungen**: Bürgermeldungen bearbeiten
- **Termine**: Veranstaltungsmanagement
- **Downloads**: Dokumente und Dateien
- **Geocaching**: Standortverwaltung
- **Marktplatz**: Kleinanzeigen moderieren
- **Verifizierung**: Nutzerverifizierung
- **Nachrichten**: Messenger-System
- **Hinweise**: Gemeinde-Mitteilungen
- **Synchronisation**: Datenabgleich
- **Einstellungen**: System-Konfiguration

## Tech Stack

- **Framework**: Next.js 14 mit TypeScript
- **UI**: Bootstrap 5 + Velzon Theme Components
- **Icons**: FontAwesome
- **Build**: Standalone Output für LXC Container
- **API**: WordPress REST API Integration

## Development

```bash
# Install dependencies
pnpm install

# Start development server
pnpm dev

# Build for production
pnpm build
```

## Deployment

Das Dashboard wird in einem LXC Container zusammen mit WordPress gehostet:

```bash
# Provision LXC container
make dashboard-provision

# Deploy dashboard
make dashboard-deploy

# Check status
make dashboard-status
```

## URL Structure

- **Root Domain**: `https://appmin.miocitynet.com/` → redirects to `/cms/`
- **WordPress**: `https://appmin.miocitynet.com/cms/` 
- **Dashboard**: `https://appmin.miocitynet.com/dashboard/`

## Environment Variables

Das System verwendet `/etc/aukrug-dashboard.env`:

```bash
DOMAIN=appmin.miocitynet.com
DASHBOARD_BASE_URL=https://appmin.miocitynet.com/dashboard
WP_BASE_URL=https://appmin.miocitynet.com/cms
TENANT_NAME=Aukrug
VILLAGE_NAME=appmin
```

## Architecture

- **Frontend**: Next.js Dashboard (Port 3000)
- **Backend**: WordPress + Aukrug Plugin
- **Database**: MariaDB
- **Reverse Proxy**: Nginx
- **Process Manager**: systemd
- **SSL**: Let's Encrypt via certbot
