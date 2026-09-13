export PATH="$HOME/.local/bin:$PATH"

# Claude Code: `claude` = work (default profile), `claude -personal` = personal profile,
# `claude auto`/`-a` skips permission prompts (combinable, e.g. `claude -personal auto`)
claude() {
  if [ "$1" = "-personal" ] || [ "$1" = "--personal" ]; then
    shift
    CLAUDE_CONFIG_DIR="$HOME/.claude-personal" claude "$@"
    return
  fi
  if [ "$1" = "auto" ] || [ "$1" = "-a" ]; then
    shift
    command claude --dangerously-skip-permissions "$@"
  else
    command claude "$@"
  fi
}

# Enable zsh completions, including Homebrew's
FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
autoload -Uz compinit
compinit

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"


# Added by Fulfil setup script
eval "$(direnv hook zsh)"

# Resume a previous Codex session
alias cr="codex resume"
