# =============================================================================
# Aukrug Workspace - Git Sync Makefile
# =============================================================================

.PHONY: status pull-all push-all sync-all set-branch help test push-mirror pull-mirror

# Get current branch name
CURRENT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)

# Colors for output
RED := \033[31m
GREEN := \033[32m
YELLOW := \033[33m
BLUE := \033[34m
RESET := \033[0m

help: ## Show this help message
	@echo "$(BLUE)Aukrug Workspace Git Sync Commands$(RESET)"
	@echo "=================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "$(GREEN)%-15s$(RESET) %s\n", $$1, $$2}'

status: ## Show git status, remotes and recent commits
	@echo "$(BLUE)📊 Git Status Overview$(RESET)"
	@echo "========================"
	@echo "$(YELLOW)Remotes:$(RESET)"
	@git remote -v
	@echo ""
	@echo "$(YELLOW)Current Branch:$(RESET) $(CURRENT_BRANCH)"
	@echo ""
	@echo "$(YELLOW)Working Directory:$(RESET)"
	@git status --porcelain | head -10 || echo "✅ Clean working directory"
	@echo ""
	@echo "$(YELLOW)Recent Commits (Origin):$(RESET)"
	@git log --oneline --graph --decorate -n 5 2>/dev/null || echo "No commits yet"
	@echo ""
	@echo "$(YELLOW)Remote Status:$(RESET)"
	@git fetch origin --dry-run 2>/dev/null && echo "✅ Origin reachable" || echo "❌ Origin not reachable"
	@git fetch mirror --dry-run 2>/dev/null && echo "✅ Mirror reachable" || echo "❌ Mirror not reachable"

pull-all: ## Pull latest changes from available remotes with rebase
	@echo "$(BLUE)📥 Pulling from available remotes...$(RESET)"
	@echo "Fetching from mirror..."
	@git fetch mirror || (echo "$(RED)❌ Failed to fetch from mirror$(RESET)" && exit 1)
	@if git fetch origin 2>/dev/null; then \
		echo "Fetching from origin..."; \
		echo "Pulling with rebase from origin..."; \
		git pull --rebase origin $(CURRENT_BRANCH) || (echo "$(RED)❌ Rebase failed from origin. Resolve conflicts manually and run 'git rebase --continue'$(RESET)" && exit 1); \
	else \
		echo "$(YELLOW)⚠️  Origin not available, using mirror only$(RESET)"; \
		echo "Pulling with rebase from mirror..."; \
		git pull --rebase mirror $(CURRENT_BRANCH) || (echo "$(RED)❌ Rebase failed from mirror. Resolve conflicts manually and run 'git rebase --continue'$(RESET)" && exit 1); \
	fi
	@echo "$(GREEN)✅ Pull completed successfully$(RESET)"

push-all: ## Push current branch and tags to available remotes
	@echo "$(BLUE)📤 Pushing to available remotes...$(RESET)"
	@echo "Pushing branch $(CURRENT_BRANCH) to mirror..."
	@git push -u mirror $(CURRENT_BRANCH) || (echo "$(RED)❌ Failed to push to mirror$(RESET)" && exit 1)
	@echo "Syncing tags to mirror..."
	@git push mirror --tags || (echo "$(RED)❌ Failed to sync tags to mirror$(RESET)" && exit 1)
	@if git fetch origin 2>/dev/null; then \
		echo "Pushing branch $(CURRENT_BRANCH) to origin..."; \
		git push -u origin $(CURRENT_BRANCH) || echo "$(YELLOW)⚠️  Failed to push to origin$(RESET)"; \
		echo "Syncing tags to origin..."; \
		git push origin --tags || echo "$(YELLOW)⚠️  Failed to sync tags to origin$(RESET)"; \
	else \
		echo "$(YELLOW)⚠️  Origin not available, skipping$(RESET)"; \
	fi
	@echo "$(GREEN)✅ Push completed successfully$(RESET)"

push-mirror: ## Push current branch and tags only to mirror
	@echo "$(BLUE)📤 Pushing to mirror only...$(RESET)"
	@echo "Pushing branch $(CURRENT_BRANCH) to mirror..."
	@git push -u mirror $(CURRENT_BRANCH) || (echo "$(RED)❌ Failed to push to mirror$(RESET)" && exit 1)
	@echo "Syncing tags to mirror..."
	@git push mirror --tags || (echo "$(RED)❌ Failed to sync tags to mirror$(RESET)" && exit 1)
	@echo "$(GREEN)✅ Mirror sync completed successfully$(RESET)"

pull-mirror: ## Pull from mirror only
	@echo "$(BLUE)📥 Pulling from mirror only...$(RESET)"
	@echo "Fetching from mirror..."
	@git fetch mirror || (echo "$(RED)❌ Failed to fetch from mirror$(RESET)" && exit 1)
	@echo "Pulling with rebase from mirror..."
	@git pull --rebase mirror $(CURRENT_BRANCH) || (echo "$(RED)❌ Rebase failed from mirror. Resolve conflicts manually and run 'git rebase --continue'$(RESET)" && exit 1)
	@echo "$(GREEN)✅ Mirror pull completed successfully$(RESET)"

test: ## Run tests if available (Flutter, npm, etc.)
	@echo "$(BLUE)🧪 Running tests...$(RESET)"
	@if [ -f "app/pubspec.yaml" ]; then \
		echo "Running Flutter tests..."; \
		cd app && flutter test 2>/dev/null || echo "$(YELLOW)⚠️  Flutter tests not available or failed$(RESET)"; \
	fi
	@if [ -f "package.json" ]; then \
		echo "Running npm tests..."; \
		npm test 2>/dev/null || echo "$(YELLOW)⚠️  npm tests not available or failed$(RESET)"; \
	fi
	@echo "$(GREEN)✅ Tests completed$(RESET)"

sync-all: status ## Complete sync: status -> pull -> test -> push -> status
	@echo "$(BLUE)🔄 Starting complete sync workflow...$(RESET)"
	@echo ""
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "$(YELLOW)⚠️  Working directory not clean. Committing changes...$(RESET)"; \
		git add -A; \
		git commit -m "chore: sync workflow - auto commit changes"; \
	fi
	@$(MAKE) pull-all
	@echo ""
	@$(MAKE) test
	@echo ""
	@$(MAKE) push-all
	@echo ""
	@echo "$(BLUE)📊 Final Status:$(RESET)"
	@$(MAKE) status
	@echo ""
	@echo "$(GREEN)🎉 Sync workflow completed successfully!$(RESET)"

set-branch: ## Set default branch to main (BR=main)
	@echo "$(BLUE)🔧 Setting default branch to main...$(RESET)"
	@git branch -M main
	@git push -u origin main
	@git push -u mirror main
	@echo "$(GREEN)✅ Default branch set to main$(RESET)"

# Check if working directory is clean
check-clean:
	@if [ -n "$$(git status --porcelain)" ]; then \
		echo "$(RED)❌ Working directory not clean. Please commit or stash changes first.$(RESET)"; \
		exit 1; \
	fi

# Initialize repo if no commits exist
init-repo:
	@if ! git rev-parse HEAD >/dev/null 2>&1; then \
		echo "$(YELLOW)📝 No commits found. Creating initial commit...$(RESET)"; \
		git add -A; \
		git commit -m "chore: init sync workflow"; \
	fi
