#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
config_dir="$HOME/.config/opencode"
skills_dir="$config_dir/skills"

link_path() {
  local source_path="$1"
  local dest_path="$2"
  local label="$3"

  if [[ -L "$dest_path" ]]; then
    local current_target
    current_target="$(readlink "$dest_path")"

    if [[ "$current_target" == "$source_path" ]]; then
      printf '%s already exists: %s -> %s\n' "$label" "$dest_path" "$source_path"
      return 0
    fi

    ln -sfn "$source_path" "$dest_path"
    printf 'Updated %s: %s -> %s\n' "$label" "$dest_path" "$source_path"
    return 0
  fi

  if [[ -e "$dest_path" ]]; then
    printf 'Skipping %s; destination already exists: %s\n' "$label" "$dest_path"
    return 0
  fi

  ln -s "$source_path" "$dest_path"
  printf 'Created %s: %s -> %s\n' "$label" "$dest_path" "$source_path"
}

if [[ ! -d "$config_dir" ]]; then
  printf 'Config directory does not exist: %s\n' "$config_dir" >&2
  exit 1
fi

mkdir -p "$skills_dir"

link_path "$repo_dir/AGENTS.md" "$config_dir/AGENTS.md" "AGENTS.md"

for skill_path in "$repo_dir"/skills/*/*; do
  [[ -d "$skill_path" ]] || continue
  [[ -f "$skill_path/SKILL.md" ]] || continue

  skill_name="$(basename "$skill_path")"
  link_path "$skill_path" "$skills_dir/$skill_name" "skill $skill_name"
done
