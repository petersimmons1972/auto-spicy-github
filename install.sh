#!/usr/bin/env sh
# install.sh — installs auto-spicy-github skills into ~/.claude/skills/
#
# Copies the art-direction skill and the VISUAL-IDENTITY.md template into the user's Claude skills directory
# so they are available in any Claude Code session.
#
# Usage: ./install.sh
# No external dependencies required beyond standard POSIX shell utilities.

set -e

SKILLS_SRC="$(cd "$(dirname "$0")/skills" && pwd)"
TEMPLATE_SRC="$(cd "$(dirname "$0")/templates" && pwd)"
SKILLS_DEST="$HOME/.claude/skills"
TEMPLATE_DEST="$HOME/.claude/skills/auto-spicy-github-template"

# clearwatch-visual-standards is deliberately not installed: the founder invokes it manually.
SKILLS="art-direction"

# ── helpers ──────────────────────────────────────────────────────────────────

ask_overwrite() {
  skill_name="$1"
  printf "  [!] '%s' already exists in %s.\n" "$skill_name" "$SKILLS_DEST"
  printf "      Overwrite? [y/N] "
  read -r answer
  case "$answer" in
    [Yy]*) return 0 ;;
    *)     return 1 ;;
  esac
}

# ── preflight ─────────────────────────────────────────────────────────────────

if [ ! -d "$SKILLS_SRC" ]; then
  printf "Error: skills/ directory not found at %s\n" "$SKILLS_SRC"
  printf "Run this script from the auto-spicy-github repo root.\n"
  exit 1
fi

if [ ! -d "$TEMPLATE_SRC" ]; then
  printf "Error: templates/ directory not found at %s\n" "$TEMPLATE_SRC"
  exit 1
fi

# ── create destination ────────────────────────────────────────────────────────

if [ ! -d "$SKILLS_DEST" ]; then
  mkdir -p "$SKILLS_DEST"
  printf "Created %s\n" "$SKILLS_DEST"
fi

# ── install skills ────────────────────────────────────────────────────────────

installed=""
skipped=""

for skill in $SKILLS; do
  src="$SKILLS_SRC/$skill"
  dest="$SKILLS_DEST/$skill"

  if [ ! -d "$src" ]; then
    printf "  [!] Source skill '%s' not found — skipping.\n" "$skill"
    continue
  fi

  if [ -d "$dest" ]; then
    if ask_overwrite "$skill"; then
      rm -rf "$dest"
    else
      skipped="$skipped $skill"
      continue
    fi
  fi

  cp -r "$src" "$dest"
  installed="$installed $skill"
done

# ── install template ──────────────────────────────────────────────────────────

if [ ! -d "$TEMPLATE_DEST" ]; then
  mkdir -p "$TEMPLATE_DEST"
fi

template_src="$TEMPLATE_SRC/VISUAL-IDENTITY.md"
template_dest="$TEMPLATE_DEST/VISUAL-IDENTITY.md"

if [ -f "$template_dest" ]; then
  printf "  [!] VISUAL-IDENTITY.md template already exists.\n"
  printf "      Overwrite? [y/N] "
  read -r answer
  case "$answer" in
    [Yy]*) cp "$template_src" "$template_dest" && installed="$installed auto-spicy-github-template/VISUAL-IDENTITY.md" ;;
    *)     skipped="$skipped auto-spicy-github-template/VISUAL-IDENTITY.md" ;;
  esac
else
  cp "$template_src" "$template_dest"
  installed="$installed auto-spicy-github-template/VISUAL-IDENTITY.md"
fi

# ── report ────────────────────────────────────────────────────────────────────

printf "\n"
printf "=== auto-spicy-github install complete ===\n"
printf "\n"

if [ -n "$installed" ]; then
  printf "Installed into %s:\n" "$SKILLS_DEST"
  for item in $installed; do
    printf "  + %s\n" "$item"
  done
fi

if [ -n "$skipped" ]; then
  printf "\nSkipped (already exists):\n"
  for item in $skipped; do
    printf "  - %s\n" "$item"
  done
fi

printf "\n"
printf "To use in any Claude Code session, invoke:\n"
printf "  /art-direction          — establish visual identity for a repo\n"
printf "\n"
printf "VISUAL-IDENTITY.md template is at:\n"
printf "  %s\n" "$template_dest"
printf "Copy it to docs/assets/VISUAL-IDENTITY.md in your repo to fill in manually.\n"
