#!/bin/bash
# Auto-start continuous-learning-v2 observer in tmux
# Called by SessionStart hook

CONFIG_DIR="$HOME/.claude/homunculus"
PID_FILE="$CONFIG_DIR/.observer.pid"

# Check if observer tmux session exists and has a running process
if tmux has-session -t observer 2>/dev/null; then
  # Session exists, check if observer process is running
  if [ -f "$PID_FILE" ]; then
    pid=$(cat "$PID_FILE")
    if kill -0 "$pid" 2>/dev/null; then
      # Already running
      exit 0
    fi
  fi
  # Session exists but observer not running, kill and recreate
  tmux kill-session -t observer 2>/dev/null
fi

# Create tmux session with observer loop
tmux new-session -d -s observer 2>/dev/null || exit 0

# Send the observer loop script
tmux send-keys -t observer 'CONFIG_DIR="$HOME/.claude/homunculus"
OBSERVATIONS_FILE="$CONFIG_DIR/observations.jsonl"
LOG_FILE="$CONFIG_DIR/observer.log"
PID_FILE="$CONFIG_DIR/.observer.pid"

mkdir -p "$CONFIG_DIR/instincts/personal" "$CONFIG_DIR/observations.archive"
echo $$ > "$PID_FILE"
echo "[$(date)] Observer auto-started via SessionStart hook (PID: $$)" >> "$LOG_FILE"

while true; do
  sleep 300
  obs_count=$(wc -l < "$OBSERVATIONS_FILE" 2>/dev/null || echo 0)
  if [ "$obs_count" -ge 10 ]; then
    echo "[$(date)] Analyzing $obs_count observations..." >> "$LOG_FILE"
    if command -v claude &> /dev/null; then
      claude --model haiku --max-turns 3 --print \
        "Read $OBSERVATIONS_FILE and identify patterns. If you find 3+ occurrences of the same pattern, create an instinct file in $CONFIG_DIR/instincts/personal/ following the instinct format (YAML frontmatter with id, trigger, confidence, domain, source; then markdown with Action and Evidence sections). Be conservative - only create instincts for clear patterns." \
        >> "$LOG_FILE" 2>&1 || true
      # Archive after analysis
      if [ -f "$OBSERVATIONS_FILE" ] && [ "$obs_count" -ge 10 ]; then
        mv "$OBSERVATIONS_FILE" "$CONFIG_DIR/observations.archive/analyzed-$(date +%Y%m%d-%H%M%S).jsonl"
        touch "$OBSERVATIONS_FILE"
      fi
    fi
  fi
done' Enter

exit 0
