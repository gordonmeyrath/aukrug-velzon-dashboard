<!DOCTYPE html>
<html <?php language_attributes(); ?>>
<head>
    <meta charset="<?php bloginfo('charset'); ?>">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Meldungen - Gemeinde Aukrug</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            line-height: 1.6;
            color: #333;
            background: #f8fafc;
        }
        
        .header {
            background: #1e40af;
            color: white;
            padding: 1rem 0;
            margin-bottom: 2rem;
        }
        
        .header .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .header h1 {
            font-size: 1.8rem;
            font-weight: 600;
        }
        
        .header .subtitle {
            opacity: 0.9;
            margin-top: 0.5rem;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }
        
        .footer {
            background: #374151;
            color: white;
            text-align: center;
            padding: 2rem 0;
            margin-top: 3rem;
        }
        
        .nav-links {
            margin-top: 1rem;
        }
        
        .nav-links a {
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            margin: 0 15px;
            font-size: 0.9rem;
        }
        
        .nav-links a:hover {
            color: white;
        }
        
        .breadcrumb {
            margin-bottom: 2rem;
            font-size: 0.9rem;
            color: #6b7280;
        }
        
        .breadcrumb a {
            color: #3b82f6;
            text-decoration: none;
        }
        
        .back-link {
            display: inline-block;
            margin-bottom: 2rem;
            color: #3b82f6;
            text-decoration: none;
            font-size: 0.9rem;
        }
        
        .back-link:hover {
            text-decoration: underline;
        }
        
        .alert {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
        }
        
        .alert-success {
            background: #d1fae5;
            border: 1px solid #10b981;
            color: #065f46;
        }
        
        .alert-error {
            background: #fee2e2;
            border: 1px solid #ef4444;
            color: #991b1b;
        }
        
        .btn {
            display: inline-block;
            padding: 0.75rem 1.5rem;
            background: #3b82f6;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-weight: 500;
            border: none;
            cursor: pointer;
            font-size: 0.95rem;
            transition: background-color 0.2s;
        }
        
        .btn:hover {
            background: #2563eb;
        }
        
        .btn-secondary {
            background: #6b7280;
        }
        
        .btn-secondary:hover {
            background: #4b5563;
        }
    </style>
    <?php wp_head(); ?>
</head>
<body>
    <div class="header">
        <div class="container">
            <h1>Gemeinde Aukrug</h1>
            <div class="subtitle">Bürgermeldungen und Community Services</div>
            <div class="nav-links">
                <a href="<?php echo home_url(); ?>">Startseite</a>
                <a href="<?php echo home_url('/meldung-erstellen/'); ?>">Neue Meldung</a>
                <a href="<?php echo home_url('/meldungen/'); ?>">Alle Meldungen</a>
            </div>
        </div>
    </div>
    
    <main class="main-content">
        <div class="container">
