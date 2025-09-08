<?php
/**
 * Aukrug App Database Schema
 * Creates and manages database tables for the Aukrug app
 */

// Create database tables on plugin activation
function aukrug_create_database_tables() {
    global $wpdb;
    
    $charset_collate = $wpdb->get_charset_collate();
    
    // Discover items table
    $discover_table = $wpdb->prefix . 'aukrug_discover_items';
    $discover_sql = "CREATE TABLE $discover_table (
        id int(11) NOT NULL AUTO_INCREMENT,
        title varchar(200) NOT NULL,
        description text NOT NULL,
        category varchar(50) NOT NULL,
        image_url varchar(500) DEFAULT '',
        lat decimal(10,8) NOT NULL,
        lng decimal(11,8) NOT NULL,
        is_featured tinyint(1) DEFAULT 0,
        rating tinyint(1) DEFAULT 0,
        opening_hours varchar(200) DEFAULT '',
        website_url varchar(500) DEFAULT '',
        phone_number varchar(50) DEFAULT '',
        created_at timestamp DEFAULT CURRENT_TIMESTAMP,
        updated_at timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        KEY category (category),
        KEY featured (is_featured)
    ) $charset_collate;";
    
    // Routes table
    $routes_table = $wpdb->prefix . 'aukrug_routes';
    $routes_sql = "CREATE TABLE $routes_table (
        id int(11) NOT NULL AUTO_INCREMENT,
        name varchar(200) NOT NULL,
        description text NOT NULL,
        type varchar(50) NOT NULL,
        difficulty varchar(20) NOT NULL,
        distance decimal(6,2) NOT NULL,
        duration int(11) NOT NULL,
        elevation_gain int(11) DEFAULT 0,
        start_lat decimal(10,8) NOT NULL,
        start_lng decimal(11,8) NOT NULL,
        end_lat decimal(10,8) NOT NULL,
        end_lng decimal(11,8) NOT NULL,
        gpx_url varchar(500) DEFAULT '',
        image_url varchar(500) DEFAULT '',
        created_at timestamp DEFAULT CURRENT_TIMESTAMP,
        updated_at timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        KEY type (type),
        KEY difficulty (difficulty)
    ) $charset_collate;";
    
    // Notices table
    $notices_table = $wpdb->prefix . 'aukrug_notices';
    $notices_sql = "CREATE TABLE $notices_table (
        id int(11) NOT NULL AUTO_INCREMENT,
        title varchar(200) NOT NULL,
        content text NOT NULL,
        category varchar(50) NOT NULL,
        importance varchar(20) NOT NULL,
        published_date date NOT NULL,
        valid_until date NOT NULL,
        is_pinned tinyint(1) DEFAULT 0,
        created_at timestamp DEFAULT CURRENT_TIMESTAMP,
        updated_at timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        KEY category (category),
        KEY importance (importance),
        KEY published_date (published_date),
        KEY valid_until (valid_until),
        KEY pinned (is_pinned)
    ) $charset_collate;";
    
    // Push notifications log table
    $notifications_table = $wpdb->prefix . 'aukrug_push_notifications';
    $notifications_sql = "CREATE TABLE $notifications_table (
        id int(11) NOT NULL AUTO_INCREMENT,
        title varchar(200) NOT NULL,
        message text NOT NULL,
        target_audience varchar(50) NOT NULL,
        priority varchar(20) DEFAULT 'normal',
        sent_at timestamp DEFAULT CURRENT_TIMESTAMP,
        delivery_count int(11) DEFAULT 0,
        success_count int(11) DEFAULT 0,
        failure_count int(11) DEFAULT 0,
        status varchar(20) DEFAULT 'pending',
        PRIMARY KEY (id),
        KEY target_audience (target_audience),
        KEY sent_at (sent_at),
        KEY status (status)
    ) $charset_collate;";

    // Report comments (Dialog zwischen Bürger und Verwaltung)
    $report_comments_table = $wpdb->prefix . 'aukrug_report_comments';
    $report_comments_sql = "CREATE TABLE $report_comments_table (
        id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
        report_id BIGINT UNSIGNED NOT NULL,
        author_id BIGINT UNSIGNED NULL,
        author_name varchar(100) DEFAULT '',
        author_email varchar(150) DEFAULT '',
        author_role varchar(20) DEFAULT 'user', /* user|admin|anonymous|system */
        visibility varchar(20) DEFAULT 'public', /* public|internal */
        message text NOT NULL,
        attachments longtext NULL, /* JSON serialisierte Liste von Media IDs / URLs */
        created_at timestamp DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        KEY report_id (report_id),
        KEY visibility (visibility)
    ) $charset_collate;";

    // Report activity log (Statuswechsel, Zuweisungen, SLA-Events)
    $report_activity_table = $wpdb->prefix . 'aukrug_report_activity';
    $report_activity_sql = "CREATE TABLE $report_activity_table (
        id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
        report_id BIGINT UNSIGNED NOT NULL,
        action varchar(50) NOT NULL,
        actor_id BIGINT UNSIGNED NULL,
        actor_role varchar(20) DEFAULT 'system',
        meta text NULL, /* JSON Zusatzdaten */
        created_at timestamp DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (id),
        KEY report_id (report_id),
        KEY action (action)
    ) $charset_collate;";
    
    require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
    
    dbDelta($discover_sql);
    dbDelta($routes_sql);
    dbDelta($notices_sql);
    dbDelta($notifications_sql);
    dbDelta($report_comments_sql);
    dbDelta($report_activity_sql);
}

// Insert sample data
function aukrug_insert_sample_data() {
    global $wpdb;
    
    // Check if data already exists
    $discover_count = $wpdb->get_var("SELECT COUNT(*) FROM {$wpdb->prefix}aukrug_discover_items");
    
    if ($discover_count > 0) {
        return; // Data already exists
    }
    
    // Sample discover items
    $discover_items = [
        [
            'title' => 'Naturpark Aukrug',
            'description' => 'Ein wunderschöner Naturpark mit vielfältigen Wanderwegen und beeindruckender Flora und Fauna. Ideal für Naturliebhaber und Familien mit ausgezeichneten Picknickplätzen.',
            'category' => 'natur',
            'lat' => 54.0234,
            'lng' => 9.7456,
            'is_featured' => 1,
            'rating' => 5,
            'opening_hours' => 'Täglich 6:00-22:00',
            'image_url' => 'https://picsum.photos/400/300?random=1',
        ],
        [
            'title' => 'Gut Altenkrempe',
            'description' => 'Historisches Gut mit wunderschöner Architektur und gepflegten Gartenanlagen. Bietet Führungen und Veranstaltungen mit original erhaltener Bausubstanz aus dem 18. Jahrhundert.',
            'category' => 'sehenswuerdigkeit',
            'lat' => 54.0156,
            'lng' => 9.7234,
            'is_featured' => 1,
            'rating' => 4,
            'opening_hours' => 'Mi-So 10:00-17:00',
            'website_url' => 'https://www.gut-altenkrempe.de',
            'phone_number' => '+49 4873 123456',
            'image_url' => 'https://picsum.photos/400/300?random=2',
        ],
        [
            'title' => 'Gasthof Zur Linde',
            'description' => 'Traditioneller Gasthof mit regionaler Küche und gemütlicher Atmosphäre. Bekannt für seine hausgemachten Spezialitäten und lokale Gerichte aus frischen Zutaten.',
            'category' => 'gastronomie',
            'lat' => 54.0278,
            'lng' => 9.7512,
            'is_featured' => 0,
            'rating' => 4,
            'opening_hours' => 'Di-So 11:30-22:00',
            'website_url' => 'https://www.gasthof-zur-linde-aukrug.de',
            'phone_number' => '+49 4873 987654',
            'image_url' => 'https://picsum.photos/400/300?random=3',
        ],
        [
            'title' => 'Aukruger Waldmuseum',
            'description' => 'Informatives Museum über die Waldgeschichte der Region mit interaktiven Ausstellungen für Jung und Alt. Zeigt die Entwicklung des Waldes über die Jahrhunderte.',
            'category' => 'kultur',
            'lat' => 54.0201,
            'lng' => 9.7389,
            'is_featured' => 0,
            'rating' => 4,
            'opening_hours' => 'Sa-So 14:00-17:00',
            'phone_number' => '+49 4873 246810',
            'image_url' => 'https://picsum.photos/400/300?random=4',
        ],
        [
            'title' => 'Hotel Waldeck',
            'description' => 'Gemütliches Hotel im Herzen des Naturparks mit komfortablen Zimmern und herzlichem Service. Perfekt für Naturliebhaber und Wanderer.',
            'category' => 'unterkunft',
            'lat' => 54.0189,
            'lng' => 9.7445,
            'is_featured' => 0,
            'rating' => 4,
            'website_url' => 'https://www.hotel-waldeck-aukrug.de',
            'phone_number' => '+49 4873 135790',
            'image_url' => 'https://picsum.photos/400/300?random=5',
        ],
        [
            'title' => 'Klettergarten Aukrug',
            'description' => 'Abenteuerlicher Hochseilgarten mit verschiedenen Schwierigkeitsgraden für Groß und Klein. Bietet aufregende Parcours in luftiger Höhe.',
            'category' => 'aktivitaet',
            'lat' => 54.0312,
            'lng' => 9.7523,
            'is_featured' => 1,
            'rating' => 5,
            'opening_hours' => 'Apr-Okt: Sa-So 10:00-18:00',
            'website_url' => 'https://www.klettergarten-aukrug.de',
            'phone_number' => '+49 4873 369258',
            'image_url' => 'https://picsum.photos/400/300?random=6',
        ],
        [
            'title' => 'Aukruger Dorfladen',
            'description' => 'Gemütlicher Dorfladen mit regionalen Produkten und Kunsthandwerk. Hier finden Sie alles für den täglichen Bedarf und schöne Souvenirs.',
            'category' => 'shopping',
            'lat' => 54.0245,
            'lng' => 9.7467,
            'is_featured' => 0,
            'rating' => 4,
            'opening_hours' => 'Mo-Fr 8:00-18:00, Sa 8:00-14:00',
            'phone_number' => '+49 4873 456789',
            'image_url' => 'https://picsum.photos/400/300?random=7',
        ],
        [
            'title' => 'Café am Teich',
            'description' => 'Charmantes Café mit Blick auf den idyllischen Dorfteich. Serviert hausgemachte Kuchen und aroomatischen Kaffee in entspannter Atmosphäre.',
            'category' => 'gastronomie',
            'lat' => 54.0267,
            'lng' => 9.7489,
            'is_featured' => 0,
            'rating' => 4,
            'opening_hours' => 'Mi-So 9:00-18:00',
            'image_url' => 'https://picsum.photos/400/300?random=8',
        ],
        [
            'title' => 'Aukruger Heimatmuseum',
            'description' => 'Kleines aber feines Museum zur Ortsgeschichte von Aukrug. Zeigt Exponate aus vergangenen Zeiten und erzählt die Geschichte der Gemeinde.',
            'category' => 'kultur',
            'lat' => 54.0223,
            'lng' => 9.7434,
            'is_featured' => 0,
            'rating' => 3,
            'opening_hours' => 'So 15:00-17:00',
            'phone_number' => '+49 4873 789012',
            'image_url' => 'https://picsum.photos/400/300?random=9',
        ],
        [
            'title' => 'Pension Waldblick',
            'description' => 'Familiäre Pension mit schönem Blick in den Wald. Bietet gemütliche Zimmer und ein reichhaltiges Frühstück mit regionalen Produkten.',
            'category' => 'unterkunft',
            'lat' => 54.0298,
            'lng' => 9.7501,
            'is_featured' => 0,
            'rating' => 4,
            'phone_number' => '+49 4873 345678',
            'image_url' => 'https://picsum.photos/400/300?random=10',
        ],
    ];
    
    $discover_table = $wpdb->prefix . 'aukrug_discover_items';
    foreach ($discover_items as $item) {
        $wpdb->insert($discover_table, $item);
    }
    
    // Sample routes
    $routes = [
        [
            'name' => 'Aukruger Naturpfad',
            'description' => 'Ein wunderschöner Rundweg durch den Naturpark Aukrug mit Aussichtspunkten und Rastplätzen.',
            'type' => 'wandern',
            'difficulty' => 'leicht',
            'distance' => 8.5,
            'duration' => 150,
            'elevation_gain' => 120,
            'start_lat' => 54.0234,
            'start_lng' => 9.7456,
            'end_lat' => 54.0234,
            'end_lng' => 9.7456,
        ],
        [
            'name' => 'Aukrug-Runde per Rad',
            'description' => 'Mittelschwere Radtour durch die Aukruger Landschaft mit schönen Ausblicken.',
            'type' => 'radfahren',
            'difficulty' => 'mittel',
            'distance' => 25.3,
            'duration' => 120,
            'elevation_gain' => 180,
            'start_lat' => 54.0189,
            'start_lng' => 9.7445,
            'end_lat' => 54.0189,
            'end_lng' => 9.7445,
        ],
        [
            'name' => 'Jogging-Track Aukrug',
            'description' => 'Kurze Laufstrecke für den täglichen Sport mit festem Untergrund.',
            'type' => 'laufen',
            'difficulty' => 'leicht',
            'distance' => 5.2,
            'duration' => 30,
            'elevation_gain' => 45,
            'start_lat' => 54.0201,
            'start_lng' => 9.7389,
            'end_lat' => 54.0201,
            'end_lng' => 9.7389,
        ],
        [
            'name' => 'Nordic Walking Parcours',
            'description' => 'Speziell angelegter Nordic Walking Weg mit verschiedenen Übungsstationen.',
            'type' => 'nordic_walking',
            'difficulty' => 'leicht',
            'distance' => 6.8,
            'duration' => 90,
            'elevation_gain' => 80,
            'start_lat' => 54.0278,
            'start_lng' => 9.7512,
            'end_lat' => 54.0278,
            'end_lng' => 9.7512,
        ],
        [
            'name' => 'Bergwanderung Aukruger Höhen',
            'description' => 'Anspruchsvolle Wandertour zu den höchsten Punkten der Region.',
            'type' => 'wandern',
            'difficulty' => 'schwer',
            'distance' => 18.7,
            'duration' => 360,
            'elevation_gain' => 450,
            'start_lat' => 54.0312,
            'start_lng' => 9.7523,
            'end_lat' => 54.0234,
            'end_lng' => 9.7456,
        ],
    ];
    
    $routes_table = $wpdb->prefix . 'aukrug_routes';
    foreach ($routes as $route) {
        $wpdb->insert($routes_table, $route);
    }
    
    // Sample notices
    $notices = [
        [
            'title' => 'Straßensperrung Hauptstraße',
            'content' => 'Aufgrund von Bauarbeiten ist die Hauptstraße vom 15.01. bis 20.01.2024 zwischen den Hausnummern 10-30 gesperrt. Eine Umleitung ist ausgeschildert.',
            'category' => 'verkehr',
            'importance' => 'hoch',
            'published_date' => '2024-01-10',
            'valid_until' => '2024-01-25',
            'is_pinned' => 1,
        ],
        [
            'title' => 'Gemeindeversammlung Januar',
            'content' => 'Die nächste öffentliche Gemeindeversammlung findet am 25.01.2024 um 19:00 Uhr im Gemeindehaus statt. Tagesordnung ab 20.01. verfügbar.',
            'category' => 'sitzung',
            'importance' => 'mittel',
            'published_date' => '2024-01-05',
            'valid_until' => '2024-01-26',
            'is_pinned' => 0,
        ],
        [
            'title' => 'Winterdienst Information',
            'content' => 'Der Winterdienst ist ab sofort im Einsatz. Bitte beachten Sie die Parkverbote während der Räumzeiten (22:00-06:00 Uhr).',
            'category' => 'allgemein',
            'importance' => 'mittel',
            'published_date' => '2024-01-01',
            'valid_until' => '2024-03-31',
            'is_pinned' => 0,
        ],
        [
            'title' => 'Ausschreibung Spielplatz-Sanierung',
            'content' => 'Die Gemeinde schreibt die Sanierung des Spielplatzes am Dorfteich aus. Bewerbungsfrist bis 31.01.2024.',
            'category' => 'ausschreibung',
            'importance' => 'niedrig',
            'published_date' => '2024-01-08',
            'valid_until' => '2024-02-01',
            'is_pinned' => 0,
        ],
        [
            'title' => 'Neujahrsempfang der Gemeinde',
            'content' => 'Herzliche Einladung zum Neujahrsempfang am 20.01.2024 ab 16:00 Uhr im Bürgerhaus. Anmeldung bis 18.01. erbeten.',
            'category' => 'veranstaltung',
            'importance' => 'mittel',
            'published_date' => '2024-01-03',
            'valid_until' => '2024-01-21',
            'is_pinned' => 1,
        ],
        [
            'title' => 'Biotonne-Leerung verschoben',
            'content' => 'Aufgrund der Feiertage wird die Biotonne eine Woche später geleert. Neue Termine siehe Abfallkalender.',
            'category' => 'umwelt',
            'importance' => 'niedrig',
            'published_date' => '2024-01-02',
            'valid_until' => '2024-01-15',
            'is_pinned' => 0,
        ],
        [
            'title' => 'Bürgersprechstunde Bürgermeister',
            'content' => 'Der Bürgermeister bietet jeden ersten Donnerstag im Monat von 17:00-19:00 Uhr eine Bürgersprechstunde an.',
            'category' => 'allgemein',
            'importance' => 'niedrig',
            'published_date' => '2024-01-01',
            'valid_until' => '2024-12-31',
            'is_pinned' => 0,
        ],
        [
            'title' => 'Baustelle Kindergarten',
            'content' => 'Der Kindergarten wird vom 01.02. bis 30.04.2024 erweitert. Während der Bauzeit steht ein Containerprovisorium zur Verfügung.',
            'category' => 'baustelle',
            'importance' => 'hoch',
            'published_date' => '2024-01-12',
            'valid_until' => '2024-05-01',
            'is_pinned' => 1,
        ],
    ];
    
    $notices_table = $wpdb->prefix . 'aukrug_notices';
    foreach ($notices as $notice) {
        $wpdb->insert($notices_table, $notice);
    }
}

// Drop database tables on plugin uninstall
function aukrug_drop_database_tables() {
    global $wpdb;
    
    $tables = [
        $wpdb->prefix . 'aukrug_discover_items',
        $wpdb->prefix . 'aukrug_routes',
        $wpdb->prefix . 'aukrug_notices',
        $wpdb->prefix . 'aukrug_push_notifications',
    ];
    
    foreach ($tables as $table) {
        $wpdb->query("DROP TABLE IF EXISTS $table");
    }
    
    // Also clean up options
    delete_option('aukrug_info_settings');
    delete_option('aukrug_resident_settings');
    delete_option('aukrug_db_version');
}

// Database version management
function aukrug_check_database_version() {
    $current_version = get_option('aukrug_db_version', '0');
    // Neue Version 1.1.0: Kommentar- / Aktivitäts-Tabellen für Meldungs-Dialoge
    $target_version = '1.1.0';
    
    if (version_compare($current_version, $target_version, '<')) {
        aukrug_create_database_tables();
        // Nur Seed-Daten beim allerersten Setup (Version '0') einspielen
        if ($current_version === '0') {
            aukrug_insert_sample_data();
        }
        update_option('aukrug_db_version', $target_version);
    }
}

// Hook for plugin activation
register_activation_hook(__FILE__, 'aukrug_check_database_version');

// Hook for plugin updates
add_action('plugins_loaded', 'aukrug_check_database_version');
?>
