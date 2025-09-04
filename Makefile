# Aukrug Workspace Makefile
# Provides convenient targets for development workflow

.PHONY: bootstrap backup app-gen app-test app-analyze plugin-lint plugin-test help

help:
	@echo "🏗️  Aukrug Workspace Build Targets"
	@echo ""
	@echo "Setup:"
	@echo "  bootstrap     Set up dual-remote repository (requires FORGEJO_TOKEN, GITHUB_TOKEN)"
	@echo "  backup        Create timestamped backup archive"
	@echo ""
	@echo "Flutter App:"
	@echo "  app-gen       Generate code and get dependencies"
	@echo "  app-test      Run Flutter tests"
	@echo "  app-analyze   Run Flutter static analysis"
	@echo ""
	@echo "WordPress Plugin:"
	@echo "  plugin-lint   Run PHP CodeSniffer (PSR-12)"
	@echo "  plugin-test   Run PHPUnit tests"
	@echo ""
	@echo "Example workflow:"
	@echo "  export FORGEJO_TOKEN=your_token GITHUB_TOKEN=your_token"
	@echo "  make bootstrap"
	@echo "  source tool/scripts/dev-aliases.sh"

bootstrap:
	@echo "🚀 Setting up dual-remote repository..."
	bash tool/bootstrap_repos.sh

backup:
	@echo "🗂️  Creating backup..."
	bash tool/backup.sh

app-gen:
	@echo "📱 Generating Flutter code..."
	cd app && flutter pub get && dart run build_runner build --delete-conflicting-outputs

app-test:
	@echo "🧪 Running Flutter tests..."
	cd app && flutter test

app-analyze:
	@echo "🔍 Analyzing Flutter code..."
	cd app && flutter analyze

plugin-lint:
	@echo "🔧 Linting PHP code..."
	cd plugin && composer install --quiet && vendor/bin/phpcs --standard=PSR12 . || true

plugin-test:
	@echo "🧪 Running PHP tests..."
	cd plugin && composer install --quiet && vendor/bin/phpunit -c phpunit.xml || true
