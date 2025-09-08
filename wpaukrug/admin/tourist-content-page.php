<?php
/**
 * Aukrug App Content Management Panel
 * WordPress Admin Interface for Tourist Features
 */

// Security check
if (!current_user_can('manage_options')) {
    wp_die(__('Sie haben keine Berechtigung für diese Seite.'));
}

// Handle form submissions
if (isset($_POST['action'])) {
    $result = handle_tourist_content_action($_POST);
    if ($result['success']) {
        echo '<div class="notice notice-success"><p>' . esc_html($result['message']) . '</p></div>';
    } else {
        echo '<div class="notice notice-error"><p>' . esc_html($result['message']) . '</p></div>';
    }
}

// Fetch current data
$discover_items = get_discover_items();
$routes = get_route_items();
$info_settings = get_option('aukrug_info_settings', []);
?>

<div class="wrap">
    <h1>Aukrug App - Tourist Content</h1>
    
    <div class="nav-tab-wrapper">
        <a href="#discover" class="nav-tab nav-tab-active">Entdecken</a>
        <a href="#routes" class="nav-tab">Routen & Wege</a>
        <a href="#info" class="nav-tab">App-Informationen</a>
    </div>

    <!-- Discover Content Tab -->
    <div id="discover" class="tab-content">
        <h2>Sehenswürdigkeiten & Entdeckungen</h2>
        
        <div class="discover-actions">
            <button class="button button-primary" onclick="openDiscoverModal()">Neue Entdeckung hinzufügen</button>
            <button class="button" onclick="importDiscoverData()">Daten importieren</button>
        </div>

        <table class="wp-list-table widefat fixed striped">
            <thead>
                <tr>
                    <th>Titel</th>
                    <th>Kategorie</th>
                    <th>Featured</th>
                    <th>Bewertung</th>
                    <th>Aktionen</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($discover_items as $item): ?>
                <tr>
                    <td><strong><?php echo esc_html($item['title']); ?></strong><br>
                        <small><?php echo esc_html(wp_trim_words($item['description'], 10)); ?></small>
                    </td>
                    <td><span class="category-badge category-<?php echo esc_attr($item['category']); ?>">
                        <?php echo get_category_display_name($item['category']); ?>
                    </span></td>
                    <td><?php echo $item['is_featured'] ? '<span class="dashicons dashicons-star-filled"></span>' : '-'; ?></td>
                    <td><?php echo $item['rating'] > 0 ? str_repeat('⭐', $item['rating']) : '-'; ?></td>
                    <td>
                        <button class="button button-small" onclick="editDiscoverItem('<?php echo esc_js($item['id']); ?>')">Bearbeiten</button>
                        <button class="button button-small button-link-delete" onclick="deleteDiscoverItem('<?php echo esc_js($item['id']); ?>')">Löschen</button>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>

    <!-- Routes Tab -->
    <div id="routes" class="tab-content" style="display: none;">
        <h2>Routen & Wanderwege</h2>
        
        <div class="routes-actions">
            <button class="button button-primary" onclick="openRouteModal()">Neue Route hinzufügen</button>
            <button class="button" onclick="importGPXData()">GPX-Dateien importieren</button>
        </div>

        <table class="wp-list-table widefat fixed striped">
            <thead>
                <tr>
                    <th>Name</th>
                    <th>Typ</th>
                    <th>Schwierigkeit</th>
                    <th>Distanz</th>
                    <th>Dauer</th>
                    <th>Aktionen</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach ($routes as $route): ?>
                <tr>
                    <td><strong><?php echo esc_html($route['name']); ?></strong><br>
                        <small><?php echo esc_html(wp_trim_words($route['description'], 8)); ?></small>
                    </td>
                    <td><span class="type-badge type-<?php echo esc_attr($route['type']); ?>">
                        <?php echo get_route_type_display_name($route['type']); ?>
                    </span></td>
                    <td><span class="difficulty-badge difficulty-<?php echo esc_attr($route['difficulty']); ?>">
                        <?php echo get_difficulty_display_name($route['difficulty']); ?>
                    </span></td>
                    <td><?php echo number_format($route['distance'], 1); ?> km</td>
                    <td><?php echo format_duration($route['duration']); ?></td>
                    <td>
                        <button class="button button-small" onclick="editRoute('<?php echo esc_js($route['id']); ?>')">Bearbeiten</button>
                        <button class="button button-small" onclick="downloadGPX('<?php echo esc_js($route['id']); ?>')">GPX</button>
                        <button class="button button-small button-link-delete" onclick="deleteRoute('<?php echo esc_js($route['id']); ?>')">Löschen</button>
                    </td>
                </tr>
                <?php endforeach; ?>
            </tbody>
        </table>
    </div>

    <!-- Info Tab -->
    <div id="info" class="tab-content" style="display: none;">
        <h2>App-Informationen verwalten</h2>
        
        <form method="post" action="">
            <input type="hidden" name="action" value="update_info_settings">
            <?php wp_nonce_field('aukrug_info_settings'); ?>
            
            <table class="form-table">
                <tr>
                    <th scope="row">Gemeinde-Kontakt</th>
                    <td>
                        <fieldset>
                            <legend class="screen-reader-text">Kontaktdaten</legend>
                            <label>
                                Adresse<br>
                                <textarea name="contact_address" rows="3" cols="50"><?php echo esc_textarea($info_settings['contact_address'] ?? 'Hauptstraße 17\n24613 Aukrug'); ?></textarea>
                            </label><br><br>
                            <label>
                                Telefon<br>
                                <input type="text" name="contact_phone" value="<?php echo esc_attr($info_settings['contact_phone'] ?? '+49 4873 8779-0'); ?>" class="regular-text">
                            </label><br><br>
                            <label>
                                E-Mail<br>
                                <input type="email" name="contact_email" value="<?php echo esc_attr($info_settings['contact_email'] ?? 'info@aukrug.de'); ?>" class="regular-text">
                            </label><br><br>
                            <label>
                                Website<br>
                                <input type="url" name="contact_website" value="<?php echo esc_attr($info_settings['contact_website'] ?? 'https://www.aukrug.de'); ?>" class="regular-text">
                            </label>
                        </fieldset>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Öffnungszeiten</th>
                    <td>
                        <textarea name="opening_hours" rows="7" cols="70"><?php echo esc_textarea($info_settings['opening_hours'] ?? "Montag: 08:00 - 12:00\nDienstag: 08:00 - 12:00, 14:00 - 18:00\nMittwoch: 08:00 - 12:00\nDonnerstag: 08:00 - 12:00, 14:00 - 16:00\nFreitag: 08:00 - 12:00\nSamstag: Geschlossen\nSonntag: Geschlossen"); ?></textarea>
                        <p class="description">Eine Zeile pro Wochentag im Format "Tag: Öffnungszeiten"</p>
                    </td>
                </tr>
                <tr>
                    <th scope="row">App-Beschreibung</th>
                    <td>
                        <textarea name="app_description" rows="4" cols="70"><?php echo esc_textarea($info_settings['app_description'] ?? 'Die offizielle App der Gemeinde Aukrug.\n\nEntwickelt für die Bürgerinnen und Bürger von Aukrug.'); ?></textarea>
                    </td>
                </tr>
                <tr>
                    <th scope="row">App-Version</th>
                    <td>
                        <input type="text" name="app_version" value="<?php echo esc_attr($info_settings['app_version'] ?? '1.0.0'); ?>" class="small-text">
                        <p class="description">Aktuelle Version der mobilen App</p>
                    </td>
                </tr>
            </table>
            
            <?php submit_button('Informationen speichern'); ?>
        </form>
    </div>
</div>

<!-- Discover Item Modal -->
<div id="discover-modal" class="aukrug-modal" style="display: none;">
    <div class="aukrug-modal-content">
        <span class="aukrug-modal-close">&times;</span>
        <h2>Entdeckung bearbeiten</h2>
        <form id="discover-form">
            <table class="form-table">
                <tr>
                    <th scope="row">Titel</th>
                    <td><input type="text" id="discover-title" name="title" class="regular-text" required></td>
                </tr>
                <tr>
                    <th scope="row">Beschreibung</th>
                    <td><textarea id="discover-description" name="description" rows="4" cols="50" required></textarea></td>
                </tr>
                <tr>
                    <th scope="row">Kategorie</th>
                    <td>
                        <select id="discover-category" name="category" required>
                            <option value="sehenswuerdigkeit">Sehenswürdigkeit</option>
                            <option value="gastronomie">Gastronomie</option>
                            <option value="unterkunft">Unterkunft</option>
                            <option value="aktivitaet">Aktivität</option>
                            <option value="kultur">Kultur</option>
                            <option value="natur">Natur</option>
                            <option value="shopping">Shopping</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Position</th>
                    <td>
                        <label>
                            Breitengrad<br>
                            <input type="number" id="discover-lat" name="lat" step="0.000001" min="53" max="55" required>
                        </label><br><br>
                        <label>
                            Längengrad<br>
                            <input type="number" id="discover-lng" name="lng" step="0.000001" min="9" max="11" required>
                        </label>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Einstellungen</th>
                    <td>
                        <label>
                            <input type="checkbox" id="discover-featured" name="is_featured" value="1">
                            Als Featured markieren
                        </label><br><br>
                        <label>
                            Bewertung<br>
                            <select id="discover-rating" name="rating">
                                <option value="0">Keine Bewertung</option>
                                <option value="1">⭐</option>
                                <option value="2">⭐⭐</option>
                                <option value="3">⭐⭐⭐</option>
                                <option value="4">⭐⭐⭐⭐</option>
                                <option value="5">⭐⭐⭐⭐⭐</option>
                            </select>
                        </label>
                    </td>
                </tr>
                <tr>
                    <th scope="row">Zusätzliche Informationen</th>
                    <td>
                        <label>
                            Öffnungszeiten<br>
                            <input type="text" id="discover-hours" name="opening_hours" class="regular-text" placeholder="z.B. Täglich 9:00 - 18:00">
                        </label><br><br>
                        <label>
                            Website<br>
                            <input type="url" id="discover-website" name="website_url" class="regular-text" placeholder="https://...">
                        </label><br><br>
                        <label>
                            Telefon<br>
                            <input type="tel" id="discover-phone" name="phone_number" class="regular-text" placeholder="+49 ...">
                        </label>
                    </td>
                </tr>
            </table>
            
            <p class="submit">
                <button type="submit" class="button button-primary">Speichern</button>
                <button type="button" class="button" onclick="closeDiscoverModal()">Abbrechen</button>
            </p>
        </form>
    </div>
</div>

<style>
.category-badge, .type-badge, .difficulty-badge {
    padding: 2px 8px;
    border-radius: 12px;
    font-size: 11px;
    font-weight: bold;
    color: white;
}

.category-sehenswuerdigkeit { background: #8e44ad; }
.category-gastronomie { background: #e67e22; }
.category-unterkunft { background: #3498db; }
.category-aktivitaet { background: #f39c12; }
.category-kultur { background: #9b59b6; }
.category-natur { background: #27ae60; }
.category-shopping { background: #e74c3c; }

.type-wandern { background: #2ecc71; }
.type-radfahren { background: #3498db; }
.type-laufen { background: #e74c3c; }
.type-nordic_walking { background: #9b59b6; }

.difficulty-leicht { background: #27ae60; }
.difficulty-mittel { background: #f39c12; }
.difficulty-schwer { background: #e74c3c; }

.aukrug-modal {
    position: fixed;
    z-index: 100000;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    background-color: rgba(0,0,0,0.5);
}

.aukrug-modal-content {
    background-color: #fefefe;
    margin: 5% auto;
    padding: 20px;
    border: none;
    border-radius: 8px;
    width: 80%;
    max-width: 800px;
    max-height: 90vh;
    overflow-y: auto;
}

.aukrug-modal-close {
    color: #aaa;
    float: right;
    font-size: 28px;
    font-weight: bold;
    cursor: pointer;
}

.tab-content {
    background: white;
    padding: 20px;
    border: 1px solid #ccd0d4;
    border-top: none;
}

.discover-actions, .routes-actions {
    margin: 20px 0;
}

.nav-tab-wrapper {
    border-bottom: 1px solid #ccd0d4;
}
</style>

<script>
// Tab functionality
document.addEventListener('DOMContentLoaded', function() {
    const tabs = document.querySelectorAll('.nav-tab');
    const contents = document.querySelectorAll('.tab-content');
    
    tabs.forEach((tab, index) => {
        tab.addEventListener('click', function(e) {
            e.preventDefault();
            
            // Remove active class from all tabs
            tabs.forEach(t => t.classList.remove('nav-tab-active'));
            contents.forEach(c => c.style.display = 'none');
            
            // Add active class to clicked tab
            this.classList.add('nav-tab-active');
            contents[index].style.display = 'block';
        });
    });
});

// Modal functions
function openDiscoverModal(id = null) {
    if (id) {
        // Load existing data for editing
        loadDiscoverItem(id);
    } else {
        // Clear form for new item
        document.getElementById('discover-form').reset();
    }
    document.getElementById('discover-modal').style.display = 'block';
}

function closeDiscoverModal() {
    document.getElementById('discover-modal').style.display = 'none';
}

function editDiscoverItem(id) {
    openDiscoverModal(id);
}

function deleteDiscoverItem(id) {
    if (confirm('Möchten Sie diese Entdeckung wirklich löschen?')) {
        // AJAX call to delete item
        deleteItemAjax('discover', id);
    }
}

function loadDiscoverItem(id) {
    // AJAX call to load item data
    const data = new FormData();
    data.append('action', 'load_discover_item');
    data.append('id', id);
    data.append('nonce', '<?php echo wp_create_nonce("aukrug_admin"); ?>');
    
    fetch(ajaxurl, {
        method: 'POST',
        body: data
    })
    .then(response => response.json())
    .then(item => {
        if (item.success) {
            const data = item.data;
            document.getElementById('discover-title').value = data.title;
            document.getElementById('discover-description').value = data.description;
            document.getElementById('discover-category').value = data.category;
            document.getElementById('discover-lat').value = data.lat;
            document.getElementById('discover-lng').value = data.lng;
            document.getElementById('discover-featured').checked = data.is_featured;
            document.getElementById('discover-rating').value = data.rating;
            document.getElementById('discover-hours').value = data.opening_hours || '';
            document.getElementById('discover-website').value = data.website_url || '';
            document.getElementById('discover-phone').value = data.phone_number || '';
        }
    });
}

// Close modal when clicking outside
window.onclick = function(event) {
    const modal = document.getElementById('discover-modal');
    if (event.target === modal) {
        modal.style.display = 'none';
    }
}
</script>

<?php

// Helper functions
function get_discover_items() {
    // Return mock data for now - will be replaced with database calls
    return [
        [
            'id' => '1',
            'title' => 'Naturpark Aukrug',
            'description' => 'Ein wunderschöner Naturpark mit vielfältigen Wanderwegen...',
            'category' => 'natur',
            'is_featured' => true,
            'rating' => 5,
        ],
        [
            'id' => '2',
            'title' => 'Gut Altenkrempe',
            'description' => 'Historisches Gut mit wunderschöner Architektur...',
            'category' => 'sehenswuerdigkeit',
            'is_featured' => true,
            'rating' => 4,
        ],
    ];
}

function get_route_items() {
    return [
        [
            'id' => '1',
            'name' => 'Aukruger Naturpfad',
            'description' => 'Ein wunderschöner Rundweg durch den Naturpark...',
            'type' => 'wandern',
            'difficulty' => 'leicht',
            'distance' => 8.5,
            'duration' => 150, // minutes
        ],
    ];
}

function get_category_display_name($category) {
    $names = [
        'sehenswuerdigkeit' => 'Sehenswürdigkeit',
        'gastronomie' => 'Gastronomie',
        'unterkunft' => 'Unterkunft',
        'aktivitaet' => 'Aktivität',
        'kultur' => 'Kultur',
        'natur' => 'Natur',
        'shopping' => 'Shopping',
    ];
    return $names[$category] ?? $category;
}

function get_route_type_display_name($type) {
    $names = [
        'wandern' => 'Wandern',
        'radfahren' => 'Radfahren',
        'laufen' => 'Laufen',
        'nordic_walking' => 'Nordic Walking',
    ];
    return $names[$type] ?? $type;
}

function get_difficulty_display_name($difficulty) {
    $names = [
        'leicht' => 'Leicht',
        'mittel' => 'Mittel',
        'schwer' => 'Schwer',
    ];
    return $names[$difficulty] ?? $difficulty;
}

function format_duration($minutes) {
    $hours = floor($minutes / 60);
    $mins = $minutes % 60;
    
    if ($hours > 0) {
        return $hours . 'h ' . $mins . 'min';
    } else {
        return $mins . 'min';
    }
}

function handle_tourist_content_action($post_data) {
    switch ($post_data['action']) {
        case 'update_info_settings':
            if (!wp_verify_nonce($post_data['_wpnonce'], 'aukrug_info_settings')) {
                return ['success' => false, 'message' => 'Sicherheitsprüfung fehlgeschlagen.'];
            }
            
            $settings = [
                'contact_address' => sanitize_textarea_field($post_data['contact_address']),
                'contact_phone' => sanitize_text_field($post_data['contact_phone']),
                'contact_email' => sanitize_email($post_data['contact_email']),
                'contact_website' => esc_url_raw($post_data['contact_website']),
                'opening_hours' => sanitize_textarea_field($post_data['opening_hours']),
                'app_description' => sanitize_textarea_field($post_data['app_description']),
                'app_version' => sanitize_text_field($post_data['app_version']),
            ];
            
            update_option('aukrug_info_settings', $settings);
            return ['success' => true, 'message' => 'Informationen erfolgreich gespeichert.'];
            
        default:
            return ['success' => false, 'message' => 'Unbekannte Aktion.'];
    }
}
?>
