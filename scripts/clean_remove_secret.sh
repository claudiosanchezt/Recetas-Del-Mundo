#!/usr/bin/env bash
set -euo pipefail

# Script para limpiar el historial del repo removiendo secretos detectados
# Requisitos: ejecutar desde la raíz del repo en Git Bash, tener git y git-filter-repo instalados.

echo "Starting cleanup script..."

if ! command -v git >/dev/null 2>&1; then
  echo "git not found in PATH. Install Git for Windows and re-run this script." >&2
  exit 2
fi

if ! command -v git-filter-repo >/dev/null 2>&1; then
  echo "git-filter-repo not found. Try: pip install --user git-filter-repo" >&2
  exit 3
fi

# Ensure we're in a git repo
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || { echo "Not a git repo" >&2; exit 4; }

BRANCH=Backend_Recetas
echo "Switching to branch $BRANCH"
git fetch origin
git checkout $BRANCH

# Create backup branch
TS=$(date +%Y%m%d%H%M)
BACKUP=backup/remove-secret-$TS
echo "Creating backup branch $BACKUP"
git branch "$BACKUP"
echo "Pushing backup branch to origin (optional)"
git push -u origin "$BACKUP"

if [ ! -f replacements.txt ]; then
  echo "WARNING: replacements.txt not found in repo root. Please create it with replacement rules and re-run." >&2
  exit 5
fi

echo "Running git-filter-repo --replace-text replacements.txt ..."
git filter-repo --replace-text replacements.txt

echo "git-filter-repo finished. Now cleaning working tree: remove replacements.txt and add replacements.example.txt"
cat > replacements.example.txt <<'EOF'
# replacements.example.txt
# This file is an example for git-filter-repo replacement rules.
# Do NOT include real secrets in the repo. Use environment variables or secret stores.
# Example rule format (literal replacement):
# literal:<STRIPE_TEST_KEY_REMOVED>==> <STRIPE_TEST_KEY_REMOVED>
EOF

git add replacements.example.txt
if git ls-files --error-unmatch replacements.txt >/dev/null 2>&1; then
  git rm -f replacements.txt
fi

git commit -m "chore(secrets): remove replacements.txt with secret and add replacements.example.txt" || true

echo "Expiring reflog and running gc"
git reflog expire --expire=now --all || true
git gc --prune=now --aggressive || true

echo "Pushing cleaned branch to origin with --force-with-lease"
git push --force-with-lease origin "$BRANCH"

echo "Done. If the push succeeded, inform collaborators to reset their local copies:" 
echo "  git fetch origin && git checkout $BRANCH && git reset --hard origin/$BRANCH"

echo "Also rotate any secrets that were exposed (Stripe keys, etc.)"
exit 0
