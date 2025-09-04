<?php
/**
 * Admin settings page for Aukrug Connect
 */

if (!defined('ABSPATH')) {
    exit;
}

class AukrugSettings
{
    public function __construct()
    {
        add_action('admin_menu', [$this, 'addMenuPage']);
        add_action('admin_init', [$this, 'initSettings']);
    }

    public function addMenuPage()
    {
        add_options_page(
            __('Aukrug Connect Settings', 'aukrug-connect'),
            __('Aukrug Connect', 'aukrug-connect'),
            'manage_options',
            'aukrug-connect',
            [$this, 'renderSettingsPage']
        );
    }

    public function initSettings()
    {
        register_setting('aukrug_connect_settings', 'aukrug_connect_options');

        add_settings_section(
            'aukrug_api_section',
            __('API Settings', 'aukrug-connect'),
            [$this, 'renderApiSection'],
            'aukrug-connect'
        );

        add_settings_field(
            'api_cache_ttl',
            __('Cache TTL (seconds)', 'aukrug-connect'),
            [$this, 'renderCacheTtlField'],
            'aukrug-connect',
            'aukrug_api_section'
        );

        add_settings_field(
            'jwt_secret',
            __('JWT Secret Key', 'aukrug-connect'),
            [$this, 'renderJwtSecretField'],
            'aukrug-connect',
            'aukrug_api_section'
        );

        add_settings_section(
            'aukrug_content_section',
            __('Content Settings', 'aukrug-connect'),
            [$this, 'renderContentSection'],
            'aukrug-connect'
        );

        add_settings_field(
            'consent_text',
            __('GDPR Consent Text', 'aukrug-connect'),
            [$this, 'renderConsentTextField'],
            'aukrug-connect',
            'aukrug_content_section'
        );
    }

    public function renderSettingsPage()
    {
        if (isset($_GET['tab'])) {
            $active_tab = $_GET['tab'];
        } else {
            $active_tab = 'settings';
        }
        ?>
        <div class="wrap">
            <h1><?php _e('Aukrug Connect Settings', 'aukrug-connect'); ?></h1>
            
            <h2 class="nav-tab-wrapper">
                <a href="?page=aukrug-connect&tab=settings" class="nav-tab <?php echo $active_tab == 'settings' ? 'nav-tab-active' : ''; ?>">
                    <?php _e('Settings', 'aukrug-connect'); ?>
                </a>
                <a href="?page=aukrug-connect&tab=reports" class="nav-tab <?php echo $active_tab == 'reports' ? 'nav-tab-active' : ''; ?>">
                    <?php _e('Reports', 'aukrug-connect'); ?>
                </a>
                <a href="?page=aukrug-connect&tab=sync" class="nav-tab <?php echo $active_tab == 'sync' ? 'nav-tab-active' : ''; ?>">
                    <?php _e('Sync Status', 'aukrug-connect'); ?>
                </a>
            </h2>

            <?php
            switch ($active_tab) {
                case 'reports':
                    $this->renderReportsTab();
                    break;
                case 'sync':
                    $this->renderSyncTab();
                    break;
                default:
                    $this->renderSettingsTab();
                    break;
            }
            ?>
        </div>
        <?php
    }

    private function renderSettingsTab()
    {
        ?>
        <form method="post" action="options.php">
            <?php
            settings_fields('aukrug_connect_settings');
            do_settings_sections('aukrug-connect');
            submit_button();
            ?>
        </form>
        <?php
    }

    private function renderReportsTab()
    {
        $reports = new AukrugReports();
        $stats = $reports->getReportStats();
        ?>
        <div class="aukrug-reports-dashboard">
            <h3><?php _e('Reports Overview', 'aukrug-connect'); ?></h3>
            
            <div class="stats-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin: 20px 0;">
                <div class="stat-box" style="background: #f9f9f9; padding: 20px; border-radius: 8px;">
                    <h4><?php _e('Total Reports', 'aukrug-connect'); ?></h4>
                    <p style="font-size: 24px; font-weight: bold; color: #0073aa;"><?php echo esc_html($stats['total']); ?></p>
                </div>
                
                <div class="stat-box" style="background: #f9f9f9; padding: 20px; border-radius: 8px;">
                    <h4><?php _e('Recent (30 days)', 'aukrug-connect'); ?></h4>
                    <p style="font-size: 24px; font-weight: bold; color: #00a32a;"><?php echo esc_html($stats['recent']); ?></p>
                </div>
            </div>

            <?php if (!empty($stats['by_category'])): ?>
            <h4><?php _e('Reports by Category', 'aukrug-connect'); ?></h4>
            <table class="widefat" style="margin-top: 10px;">
                <thead>
                    <tr>
                        <th><?php _e('Category', 'aukrug-connect'); ?></th>
                        <th><?php _e('Count', 'aukrug-connect'); ?></th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($stats['by_category'] as $category => $count): ?>
                    <tr>
                        <td><?php echo esc_html(ucfirst($category)); ?></td>
                        <td><?php echo esc_html($count); ?></td>
                    </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>
            <?php endif; ?>
            
            <p style="margin-top: 20px;">
                <a href="<?php echo admin_url('edit.php?post_type=aukrug_report'); ?>" class="button button-primary">
                    <?php _e('View All Reports', 'aukrug-connect'); ?>
                </a>
            </p>
        </div>
        <?php
    }

    private function renderSyncTab()
    {
        $sync = new AukrugSync();
        $post_types = ['place', 'route', 'event', 'notice', 'download'];
        ?>
        <div class="aukrug-sync-status">
            <h3><?php _e('Synchronization Status', 'aukrug-connect'); ?></h3>
            
            <table class="widefat" style="margin-top: 20px;">
                <thead>
                    <tr>
                        <th><?php _e('Content Type', 'aukrug-connect'); ?></th>
                        <th><?php _e('Last Modified', 'aukrug-connect'); ?></th>
                        <th><?php _e('Count', 'aukrug-connect'); ?></th>
                    </tr>
                </thead>
                <tbody>
                    <?php foreach ($post_types as $type): ?>
                    <?php
                    $post_type = 'aukrug_' . $type;
                    $last_modified = $sync->getLastModified($post_type);
                    $count = wp_count_posts($post_type);
                    ?>
                    <tr>
                        <td><?php echo esc_html(ucfirst($type)); ?></td>
                        <td>
                            <?php if ($last_modified): ?>
                                <?php echo esc_html(human_time_diff(strtotime($last_modified), current_time('timestamp')) . ' ago'); ?>
                            <?php else: ?>
                                <em><?php _e('Never', 'aukrug-connect'); ?></em>
                            <?php endif; ?>
                        </td>
                        <td><?php echo esc_html($count->publish); ?></td>
                    </tr>
                    <?php endforeach; ?>
                </tbody>
            </table>

            <div style="margin-top: 20px; padding: 15px; background: #f0f8ff; border-left: 4px solid #0073aa;">
                <h4><?php _e('API Endpoints', 'aukrug-connect'); ?></h4>
                <ul>
                    <?php foreach ($post_types as $type): ?>
                    <li><code><?php echo home_url("/wp-json/aukrug/v1/{$type}s"); ?></code></li>
                    <?php endforeach; ?>
                    <li><code><?php echo home_url('/wp-json/aukrug/v1/sync/changes'); ?></code></li>
                    <li><code><?php echo home_url('/wp-json/aukrug/v1/reports'); ?></code> (POST)</li>
                </ul>
            </div>
        </div>
        <?php
    }

    public function renderApiSection()
    {
        echo '<p>' . __('Configure API behavior and caching.', 'aukrug-connect') . '</p>';
    }

    public function renderCacheTtlField()
    {
        $options = get_option('aukrug_connect_options');
        $value = $options['api_cache_ttl'] ?? 3600;
        echo '<input type="number" name="aukrug_connect_options[api_cache_ttl]" value="' . esc_attr($value) . '" min="0" max="86400" />';
        echo '<p class="description">' . __('Cache duration in seconds (0 to disable caching).', 'aukrug-connect') . '</p>';
    }

    public function renderJwtSecretField()
    {
        $options = get_option('aukrug_connect_options');
        $value = $options['jwt_secret'] ?? '';
        
        if (empty($value)) {
            $value = wp_generate_password(32, false);
        }
        
        echo '<input type="text" name="aukrug_connect_options[jwt_secret]" value="' . esc_attr($value) . '" size="50" />';
        echo '<p class="description">' . __('Secret key for JWT token generation. Generated automatically if empty.', 'aukrug-connect') . '</p>';
    }

    public function renderContentSection()
    {
        echo '<p>' . __('Configure content and privacy settings.', 'aukrug-connect') . '</p>';
    }

    public function renderConsentTextField()
    {
        $options = get_option('aukrug_connect_options');
        $value = $options['consent_text'] ?? $this->getDefaultConsentText();
        
        wp_editor($value, 'aukrug_consent_text', [
            'textarea_name' => 'aukrug_connect_options[consent_text]',
            'textarea_rows' => 6,
            'media_buttons' => false,
            'teeny' => true,
        ]);
        
        echo '<p class="description">' . __('GDPR consent text shown to users when submitting reports.', 'aukrug-connect') . '</p>';
    }

    private function getDefaultConsentText()
    {
        return __('By submitting this report, you consent to the processing of your data according to our privacy policy. Your IP address and submitted content will be stored for administrative purposes. You have the right to request deletion of your data at any time.', 'aukrug-connect');
    }
}
