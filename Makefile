.PHONY: status pull-all push-all sync-all tags

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
