.PHONY: status pull-all push-all sync-all tags dashboard-provision dashboard-deploy dashboard-dev dashboard-build

status:
	@echo "=== Git Status ==="
	@git status --porcelain
	@echo "\n=== Remotes ==="
	@git remote -v
	@echo "\n=== Current Branch ==="
	@git branch --show-current

pull-all:
	@echo "=== Pulling from origin (GitHub) ==="
	@git pull origin main
	@echo "\n=== Pulling from mirror (Forgejo) ==="
	@git pull mirror main

push-all:
	@echo "=== Pushing to origin (GitHub) ==="
	@git push origin main
	@echo "\n=== Pushing to mirror (Forgejo) ==="
	@git push mirror main

sync-all: pull-all push-all
	@echo "=== Sync completed ==="

tags:
	@echo "=== Local Tags ==="
	@git tag -l
	@echo "\n=== Remote Tags (origin) ==="
	@git ls-remote --tags origin
	@echo "\n=== Remote Tags (mirror) ==="
	@git ls-remote --tags mirror

# Dashboard Management Targets

dashboard-provision:
	@echo "=== Provisioning LXC Container ==="
	ssh root@10.0.1.12 "bash -s" < dashboard/tool/remote/remote_provision.sh

dashboard-deploy:
	@echo "=== Deploying Dashboard ==="
	cd dashboard && ./tool/remote/remote_deploy.sh

dashboard-dev:
	@echo "=== Starting Dashboard Development Server ==="
	cd dashboard && pnpm install && pnpm dev

dashboard-build:
	@echo "=== Building Dashboard for Production ==="
	cd dashboard && pnpm install && pnpm build

dashboard-logs:
	@echo "=== Checking Dashboard Logs ==="
	ssh root@10.0.1.12 "journalctl -u aukrug-dashboard -f --no-pager"

dashboard-status:
	@echo "=== Dashboard Service Status ==="
	ssh root@10.0.1.12 "systemctl status aukrug-dashboard --no-pager"

dashboard-restart:
	@echo "=== Restarting Dashboard Service ==="
	ssh root@10.0.1.12 "systemctl restart aukrug-dashboard && systemctl status aukrug-dashboard --no-pager"
