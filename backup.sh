#!/bin/bash
set -e

# Load configuration
export $(grep -v '^#' /app/secrets.env | xargs)
export $(grep -v '^#' /app/config.env | xargs)

# Logging function
log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

# Check if required environment variables are set
if [ -z "$GITHUB_TOKEN" ] || [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
    log "Error: GITHUB_TOKEN, AWS_ACCESS_KEY_ID, or AWS_SECRET_ACCESS_KEY is not set"
    exit 1
fi

# Create temp directory
LOCAL_DIR=$(mktemp -d)
REPOS_DIR="$LOCAL_DIR/github-repos"
mkdir -p "$REPOS_DIR"
trap 'rm -rf "$LOCAL_DIR"' EXIT

log "Starting backup process"

# List all repos
REPOS=$(curl -s -H "Authorization: token $GITHUB_TOKEN" "https://api.github.com/users/$GITHUB_USERNAME/repos?per_page=100" | jq -r '.[].clone_url')
if [ -z "$REPOS" ]; then
    log "No repositories found or failed to fetch repositories."
    exit 1
fi
echo "$REPOS"

# Clone repos in parallel
log "Cloning repositories"
echo "$REPOS" | xargs -P 4 -I {} git clone --quiet {} "$REPOS_DIR/$(basename {} .git)"

# Upload to S3
log "Starting upload to S3"
aws s3 sync "$REPOS_DIR" "s3://$S3_BUCKET/github-repos" --delete

log "Upload completed successfully"