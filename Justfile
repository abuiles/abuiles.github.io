nix-setup:
  nix --extra-experimental-features 'nix-command flakes' develop --command bash -lc 'NIX_RUBY_BIN=$(for p in $(printf "%s" "$PATH" | tr ":" " "); do [ -x "$p/ruby" ] && echo "$p"; done | rg "ruby-3\\.2" | head -n 1); export BUNDLE_PATH="$PWD/vendor/bundle" GEM_HOME="$PWD/.gem" GEM_PATH="$PWD/.gem"; export PATH="$NIX_RUBY_BIN:$GEM_HOME/bin:$PATH"; "$NIX_RUBY_BIN/ruby" -S bundle _2.5.9_ check || "$NIX_RUBY_BIN/ruby" -S bundle _2.5.9_ install'

serve:
  just nix-serve

nix-serve:
  @if ! nix --extra-experimental-features 'nix-command flakes' develop --command true >/dev/null 2>&1; then \
    echo "Nix cannot start in this environment (daemon socket unavailable)."; \
    echo "Run this on your local machine where nix develop works, or use local-setup or local-serve."; \
    exit 1; \
  fi
  nix --extra-experimental-features 'nix-command flakes' develop --command bash -lc 'NIX_RUBY_BIN=$(for p in $(printf "%s" "$PATH" | tr ":" " "); do [ -x "$p/ruby" ] && echo "$p"; done | rg "ruby-3\\.2" | head -n 1); export BUNDLE_PATH="$PWD/vendor/bundle" GEM_HOME="$PWD/.gem" GEM_PATH="$PWD/.gem"; export PATH="$NIX_RUBY_BIN:$GEM_HOME/bin:$PATH"; "$NIX_RUBY_BIN/ruby" -S bundle _2.5.9_ check || "$NIX_RUBY_BIN/ruby" -S bundle _2.5.9_ install; SELECTED_PORT=""; for PORT in 4000 4001 4002; do if ! lsof -nP -iTCP:$PORT -sTCP:LISTEN >/dev/null 2>&1; then SELECTED_PORT=$PORT; break; fi; done; if [ -z "$SELECTED_PORT" ]; then echo "No free site port found (checked 4000 4001 4002)"; exit 1; fi; LR_PORT=""; for CANDIDATE_LR_PORT in 35729 35730 35731; do if ! lsof -nP -iTCP:$CANDIDATE_LR_PORT -sTCP:LISTEN >/dev/null 2>&1; then LR_PORT=$CANDIDATE_LR_PORT; break; fi; done; if [ -z "$LR_PORT" ]; then echo "No free LiveReload port found (checked 35729-35731)"; exit 1; fi; "$NIX_RUBY_BIN/ruby" -S bundle _2.5.9_ exec jekyll serve --livereload --livereload-port $LR_PORT --host 0.0.0.0 --port $SELECTED_PORT'

local-serve:
  @if [ ! -x "$PWD/.gem/bin/bundle" ]; then \
    echo "Missing local bundle executable at ./.gem/bin/bundle"; \
    echo "Run: just local-setup"; \
    exit 1; \
  fi
  GEM_HOME="$PWD/.gem" GEM_PATH="$PWD/.gem" BUNDLE_PATH="$PWD/vendor/bundle" PATH="$PWD/.gem/bin:$PATH" \
    $PWD/.gem/bin/bundle _2.5.9_ exec jekyll serve --livereload --host 0.0.0.0 --port 4000

local-setup:
  just nix-setup
