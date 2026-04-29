#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
config_dir="$HOME/.config/opencode"
skills_dir="$config_dir/skills"

mkdir -p "$skills_dir"

ln -sfn "$repo_dir/AGENTS.md" "$config_dir/AGENTS.md"
printf 'linked AGENTS.md -> %s\n' "$repo_dir/AGENTS.md"

find "$repo_dir/skills" -name SKILL.md -not -path '*/node_modules/*' -print0 |
while IFS= read -r -d '' skill_md; do
  skill_path="$(dirname "$skill_md")"
  skill_name="$(basename "$skill_path")"
  target="$skills_dir/$skill_name"

  [[ -e "$target" && ! -L "$target" ]] && rm -rf "$target"
  ln -sfn "$skill_path" "$target"
  printf 'linked %s -> %s\n' "$skill_name" "$skill_path"
done
