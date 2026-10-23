#!/bin/bash
input=$(cat)

eval "$(echo "$input" | jq -r '
  @sh "model=\(.model.display_name // "Claude")",
  @sh "effort=\(.effort.level // "")",
  @sh "dir=\(.workspace.current_dir // .cwd // "")",
  @sh "pct=\((.context_window.used_percentage // 0) | floor)",
  @sh "cost=\(.cost.total_cost_usd // 0)",
  @sh "ms=\(.cost.total_duration_ms // 0 | floor)"
')"

[ "$pct" -gt 100 ] && pct=100
[ "$pct" -lt 0 ] && pct=0

[ -n "$effort" ] && model="$model · $effort"

# Git branch of the current directory
branch=""
if [ -n "$dir" ] && git -C "$dir" rev-parse --git-dir >/dev/null 2>&1; then
  branch=$(git -C "$dir" --no-optional-locks branch --show-current 2>/dev/null)
  [ -z "$branch" ] && branch=$(git -C "$dir" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# Context bar with 1/8-cell resolution
fill_rgb='92;184;92'
empty_rgb='38;77;42'
partials=(' ' '▏' '▎' '▍' '▌' '▋' '▊' '▉')
units=$(( (pct * 80 + 50) / 100 ))
full=$((units / 8))
part=$((units % 8))
empty=$((10 - full))
bar=""
if [ "$full" -gt 0 ]; then
  bar+=$(printf '\033[48;2;%sm%*s' "$fill_rgb" "$full" "")
fi
if [ "$empty" -gt 0 ]; then
  bar+=$(printf '\033[48;2;%sm' "$empty_rgb")
  if [ "$part" -gt 0 ]; then
    bar+=$(printf '\033[38;2;%sm%s' "$fill_rgb" "${partials[$part]}")
    empty=$((empty - 1))
  fi
  bar+=$(printf '%*s' "$empty" "")
fi
bar+=$'\033[0m'

# Single line: model, context, cost, duration, folder, git branch
secs=$((ms / 1000))
line=$(printf '\033[36m[%s]\033[0m %s %s%% | \033[33m$%.2f\033[0m | ⏱️ %dm %ds | 📁 %s' \
  "$model" "$bar" "$pct" "$cost" $((secs / 60)) $((secs % 60)) "${dir##*/}")
[ -n "$branch" ] && line="$line | 🌿 $branch"
printf '%s\n' "$line"
