# Minimal zsh environment loaded by every zsh invocation, including
# non-interactive SSH commands. Keep this file fast and side-effect free.

case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac
