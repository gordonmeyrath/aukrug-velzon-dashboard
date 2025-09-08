<?php
namespace Aukrug\Connect;

class Plugin
{
    private static ?Plugin $instance = null;

    public static function instance(): Plugin
    {
        if (self::$instance === null) {
            self::$instance = new self();
        }
        return self::$instance;
    }

    public static function activate(): void
    {
        // Run DB migrations and seed terms on activation.
        (new Migrations())->run();
    $tax = new Tax();
    // Ensure taxonomies exist before seeding terms
    $tax->registerTaxonomies();
    $tax->seedDefaultTerms();
    // Allow subsystems to hook activation for own migrations
    if (\function_exists('do_action')) { \call_user_func('do_action', 'aukrug_connect_activate'); }
    }

    public static function deactivate(): void
    {
        // Reserved for cleanup if needed.
    }

    public function init(): void
    {
        // Initialize subsystems (order matters minimally at bootstrap)
        (new Settings())->init();
        (new Migrations())->init();
        (new Cpt())->init();
        (new Tax())->init();
    (new Sync())->init();
        (new Rest())->init();
        (new Downloads())->init();
        (new Reports())->init();
        (new Community())->init();
        (new Auth())->init();
        (new Privacy())->init();
        (new Media())->init();
        (new Geo())->init();
    (new \Aukrug\Connect\Crypto\E2EE())->init();
    }
}
