<?php
// PHPUnit bootstrap: try to load Composer autoload if available
$autoload = __DIR__ . '/../vendor/autoload.php';
if (is_readable($autoload)) {
	require_once $autoload;
}

// Minimal polyfill for PHPUnit TestCase to satisfy static analysis when vendor isn't installed.
if (!class_exists('PHPUnit\\Framework\\TestCase')) {
	class _AuPolyfillTestCase {
		protected function assertIsArray($v): void { if (!is_array($v)) { throw new Exception('Expected array'); } }
		protected function assertArrayHasKey($k, $arr): void { if (!is_array($arr) || !array_key_exists($k, $arr)) { throw new Exception('Key missing'); } }
		protected function assertFalse($v): void { if ($v !== false) { throw new Exception('Expected false'); } }
		protected function assertSame($a, $b): void { if ($a !== $b) { throw new Exception('Not identical'); } }
	protected function markTestSkipped(string $msg = ''): void { /* no-op in polyfill */ }
	}
	class_alias('_AuPolyfillTestCase', 'PHPUnit\\Framework\\TestCase');
}

// WP test scaffolding can be wired later if needed.
