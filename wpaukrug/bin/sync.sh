#!/bin/bash
#
# Git Sync Script - Synchronize code between GitHub (origin) and Forgejo (mirror)
# Usage: ./bin/sync.sh [--force] [--verbose] [branch]
#

set -euo pipefail

# Colors
readonly RED='\033[31m'
readonly GREEN='\033[32m'
readonly YELLOW='\033[33m'
readonly BLUE='\033[34m'
readonly RESET='\033[0m'

# Script info
readonly SCRIPT_NAME="$(basename "$0")"
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

# Default values
FORCE_MODE=false
VERBOSE=false
TARGET_BRANCH=""

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${RESET} $*" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${RESET} $*" >&2
}

log_error() {
    echo -e "${RED}[ERROR]${RESET} $*" >&2
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${RESET} $*" >&2
}

log_debug() {
    if [[ "$VERBOSE" == true ]]; then
        echo -e "${BLUE}[DEBUG]${RESET} $*" >&2
    fi
}

# Usage information
usage() {
    cat << EOF
Usage: $SCRIPT_NAME [OPTIONS] [BRANCH]

Synchronize Git repository between GitHub (origin) and Forgejo (mirror).

OPTIONS:
    -f, --force     Force push/pull operations (use with caution)
    -v, --verbose   Enable verbose output
    -h, --help      Show this help message

ARGUMENTS:
    BRANCH          Target branch to sync (defaults to current branch)

EXAMPLES:
    $SCRIPT_NAME                    # Sync current branch
    $SCRIPT_NAME main              # Sync main branch
    $SCRIPT_NAME --force develop   # Force sync develop branch
    $SCRIPT_NAME --verbose         # Sync with detailed output

EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -f|--force)
                FORCE_MODE=true
                log_warn "Force mode enabled - this will overwrite remote changes!"
                shift
                ;;
            -v|--verbose)
                VERBOSE=true
                shift
                ;;
            -h|--help)
                usage
                exit 0
                ;;
            -*)
                log_error "Unknown option: $1"
                usage
                exit 1
                ;;
            *)
                TARGET_BRANCH="$1"
                shift
                ;;
        esac
    done
}

# Validate Git repository
validate_repo() {
    log_debug "Validating Git repository..."
    
    if ! git rev-parse --git-dir >/dev/null 2>&1; then
        log_error "Not a Git repository: $REPO_ROOT"
        exit 1
    fi
    
    # Check if remotes exist
    if ! git remote | grep -q "^origin$"; then
        log_error "Remote 'origin' not found. Please configure GitHub remote as 'origin'."
        exit 1
    fi
    
    if ! git remote | grep -q "^mirror$"; then
        log_error "Remote 'mirror' not found. Please configure Forgejo remote as 'mirror'."
        exit 1
    fi
    
    log_debug "Repository validation passed"
}

# Get current or specified branch
get_target_branch() {
    if [[ -n "$TARGET_BRANCH" ]]; then
        if ! git show-ref --verify --quiet "refs/heads/$TARGET_BRANCH"; then
            log_error "Branch '$TARGET_BRANCH' does not exist locally"
            exit 1
        fi
        echo "$TARGET_BRANCH"
    else
        git rev-parse --abbrev-ref HEAD
    fi
}

# Check remote connectivity
check_remotes() {
    local errors=0
    
    log_info "Checking remote connectivity..."
    
    if ! git fetch origin --dry-run >/dev/null 2>&1; then
        log_error "Cannot reach 'origin' remote (GitHub)"
        ((errors++))
    else
        log_debug "Origin remote (GitHub) is reachable"
    fi
    
    if ! git fetch mirror --dry-run >/dev/null 2>&1; then
        log_error "Cannot reach 'mirror' remote (Forgejo)"
        ((errors++))
    else
        log_debug "Mirror remote (Forgejo) is reachable"
    fi
    
    if [[ $errors -gt 0 ]]; then
        log_error "Remote connectivity check failed"
        exit 1
    fi
    
    log_success "All remotes are reachable"
}

# Check working directory status
check_working_dir() {
    log_debug "Checking working directory status..."
    
    if [[ -n "$(git status --porcelain)" ]]; then
        if [[ "$FORCE_MODE" == true ]]; then
            log_warn "Working directory not clean - auto-committing changes (force mode)"
            git add -A
            git commit -m "chore: sync script auto-commit - $(date '+%Y-%m-%d %H:%M:%S')"
        else
            log_error "Working directory not clean. Please commit or stash changes first."
            log_info "Or use --force to auto-commit changes"
            exit 1
        fi
    else
        log_debug "Working directory is clean"
    fi
}

# Fetch from all remotes
fetch_all() {
    log_info "Fetching latest changes from all remotes..."
    
    log_debug "Fetching from origin..."
    if ! git fetch origin; then
        log_error "Failed to fetch from origin"
        exit 1
    fi
    
    log_debug "Fetching from mirror..."
    if ! git fetch mirror; then
        log_error "Failed to fetch from mirror"
        exit 1
    fi
    
    log_success "Fetch completed successfully"
}

# Sync branch
sync_branch() {
    local branch="$1"
    
    log_info "Syncing branch: $branch"
    
    # Checkout target branch if needed
    local current_branch
    current_branch="$(git rev-parse --abbrev-ref HEAD)"
    
    if [[ "$current_branch" != "$branch" ]]; then
        log_debug "Switching to branch: $branch"
        git checkout "$branch"
    fi
    
    # Pull with rebase from origin
    log_debug "Pulling changes from origin with rebase..."
    if [[ "$FORCE_MODE" == true ]]; then
        git reset --hard "origin/$branch"
    else
        if ! git pull --rebase origin "$branch"; then
            log_error "Rebase failed. Please resolve conflicts manually and run 'git rebase --continue'"
            exit 1
        fi
    fi
    
    # Push to both remotes
    log_info "Pushing branch '$branch' to all remotes..."
    
    local push_flags="-u"
    if [[ "$FORCE_MODE" == true ]]; then
        push_flags="$push_flags --force"
    fi
    
    if ! git push $push_flags origin "$branch"; then
        log_error "Failed to push to origin"
        exit 1
    fi
    
    if ! git push $push_flags mirror "$branch"; then
        log_error "Failed to push to mirror"
        exit 1
    fi
    
    log_success "Branch '$branch' synced successfully"
}

# Sync tags
sync_tags() {
    log_info "Syncing tags to all remotes..."
    
    local push_flags=""
    if [[ "$FORCE_MODE" == true ]]; then
        push_flags="--force"
    fi
    
    if ! git push $push_flags origin --tags; then
        log_error "Failed to push tags to origin"
        exit 1
    fi
    
    if ! git push $push_flags mirror --tags; then
        log_error "Failed to push tags to mirror"
        exit 1
    fi
    
    log_success "Tags synced successfully"
}

# Show final status
show_status() {
    log_info "Sync Status Report"
    echo "===================="
    
    echo -e "${YELLOW}Remotes:${RESET}"
    git remote -v
    echo ""
    
    echo -e "${YELLOW}Current Branch:${RESET} $(git rev-parse --abbrev-ref HEAD)"
    echo ""
    
    echo -e "${YELLOW}Recent Commits:${RESET}"
    git log --oneline --graph --decorate -n 5
    echo ""
    
    echo -e "${YELLOW}Working Directory:${RESET}"
    if [[ -z "$(git status --porcelain)" ]]; then
        echo "✅ Clean"
    else
        git status --short
    fi
}

# Main function
main() {
    log_info "Starting Git sync process..."
    
    # Change to repository root
    cd "$REPO_ROOT"
    
    parse_args "$@"
    validate_repo
    
    local target_branch
    target_branch="$(get_target_branch)"
    
    log_info "Target branch: $target_branch"
    
    check_remotes
    check_working_dir
    fetch_all
    sync_branch "$target_branch"
    sync_tags
    
    echo ""
    show_status
    echo ""
    
    log_success "🎉 Git sync completed successfully!"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
