# Aukrug Municipality Platform - Velzon Interactive Dashboard

🏛️ **Professional Municipal Management Platform** with modern Velzon Interactive Theme

## 🚀 Overview

Complete municipal platform featuring:
- 📱 **Flutter Mobile App** (`/app`) - For tourists and residents 
- 🌐 **Next.js Admin Dashboard** (`/dashboard`) - Professional management interface with Velzon Interactive Theme
- 🔌 **WordPress Plugin** (`/plugin`) - GDPR-compliant REST API backend

## ✨ Velzon Interactive Theme Features

### 🎨 Design System
- **Bootstrap 5.3.2** with custom Velzon styling
- **Poppins Font Family** (100-900 weights)
- **Interactive Color Palette** with gradient backgrounds
- **Responsive Layout** optimized for all devices
- **Professional Admin Interface** with modern aesthetics

### 🧩 Components
- **VelzonLayout** - Main responsive layout wrapper
- **VelzonSidebar** - Interactive navigation with dropdown menus
- **VelzonTopbar** - Modern top bar with search and controls
- **Statistics Cards** with gradient backgrounds and hover effects
- **Data Tables** with professional styling
- **Modal Dialogs** and form components

### ⚡ Performance
- **101kB First Load JS** - Optimized bundle size
- **Static Generation** - Pre-rendered pages
- **Mobile-First** responsive design
- **CSS Variables** for consistent theming
- **Smooth Animations** and transitions

## 🛠️ Quick Start

### Dashboard Development
```bash
cd dashboard
npm install
npm run dev
# Opens http://localhost:3000
```

### Flutter App Development  
```bash
cd app
flutter pub get
dart run build_runner build
flutter run
```

### WordPress Plugin Development
```bash
cd plugin  
composer install
composer test
```

## 📁 Project Structure

```
aukrug/
├── app/                    # Flutter mobile app
│   ├── lib/features/      # Feature-first architecture
│   ├── lib/core/          # Core modules (config, network, storage)
│   └── lib/shared/        # Shared widgets and utilities
├── dashboard/             # Next.js Admin Dashboard (Velzon Theme)
│   ├── src/app/          # App Router pages
│   ├── src/components/   # Reusable UI components
│   └── src/lib/          # Utilities and API client
├── plugin/               # WordPress REST API plugin
│   ├── includes/         # Core plugin classes
│   ├── public/           # Frontend assets
│   └── admin/            # Admin interface
└── tool/                 # Development scripts and automation
```

## 🎯 Dashboard Pages

- **`/`** - Main dashboard with statistics and activity timeline
- **`/community`** - Community management and user oversight
- **`/reports`** - Issue reporting system (Mängelmelder)
- **Additional pages** can be easily added with consistent theming

## 🔧 Technical Stack

### Frontend (Dashboard)
- **Next.js 14.2.32** - React framework with App Router
- **TypeScript** - Type safety and developer experience
- **Velzon Interactive Theme** - Professional admin interface
- **Bootstrap 5.3.2** - CSS framework with custom components
- **Font Awesome 6.4.0** - Icon system
- **RemixIcon 3.5.0** - Additional icons

### Mobile App
- **Flutter 3.x** - Cross-platform mobile framework
- **Riverpod** - State management with code generation
- **GoRouter** - Declarative routing
- **Isar Database** - Offline-first local storage
- **Dio HTTP Client** - Network requests with interceptors

### Backend
- **WordPress 6.0+** - Content management system
- **PHP 8.2+** - Server-side language
- **Custom REST API** - GDPR-compliant data endpoints
- **PSR-12 Standards** - Code quality and consistency

## 🌟 Key Features

### Dual-Audience Support
- **Tourists**: Discover places, routes, events, info
- **Residents**: Notices, downloads, reports, settings

### GDPR Compliance
- **Consent Management** - Analytics, notifications, location
- **Data Minimization** - Only store necessary data locally
- **Audit Logging** - Track all data access in WordPress

### Offline-First Architecture
- **Repository Pattern** - Load fixtures first, sync later
- **ETag Caching** - Efficient bandwidth usage
- **Local Storage** - Isar database for mobile, localStorage for web

## 📱 Responsive Design

The Velzon Interactive theme provides:
- **Desktop**: Full sidebar navigation with expanded menus
- **Tablet**: Collapsible sidebar with optimized spacing
- **Mobile**: Hidden sidebar with overlay toggle

## 🎨 Customization

### Theme Variables
```css
:root {
  --vz-primary: #664dc9;
  --vz-secondary: #74788d;
  --vz-success: #25a0e2;
  --vz-body-bg: #f8f9fc;
}
```

### Interactive Colors
The theme includes special gradient backgrounds and hover effects for interactive elements.

## 🚀 Deployment

### Production Build
```bash
cd dashboard
npm run build
# Generates optimized static files in .next/
```

### Development Aliases
```bash
source tool/scripts/dev-aliases.sh
gpub          # Push to both remotes (Forgejo + GitHub)
app-build     # Flutter build with code generation
app-test      # Run Flutter tests
plugin-test   # PHPUnit tests
```

## 📊 Build Output

```
Route (app)                              Size     First Load JS
┌ ○ /                                    5.34 kB         101 kB
├ ○ /community                           1.95 kB         104 kB
├ ○ /reports                             2.35 kB         104 kB
└ ○ /_not-found                          875 B          88.1 kB
```

## 🔗 Links

- **GitHub Repository**: https://github.com/gordonmeyrath/aukrug-velzon-dashboard
- **Velzon Theme Docs**: https://themesbrand.com/velzon/docs/nodejs/
- **Bootstrap Docs**: https://getbootstrap.com/docs/5.3/
- **Next.js Docs**: https://nextjs.org/docs

## 🏗️ Architecture Decisions

### Component-First Design
- Modular Velzon components for consistency
- TypeScript interfaces for type safety
- Responsive breakpoints using CSS Grid and Flexbox

### Performance Optimization
- Static generation for fast loading
- CSS variables for efficient theming
- Minimal JavaScript bundle size

### Developer Experience
- Hot reload for instant feedback
- ESLint and TypeScript for code quality
- Consistent file naming and structure

---

**Built with ❤️ for Aukrug Municipality**  
*Professional municipal management made simple and beautiful*
