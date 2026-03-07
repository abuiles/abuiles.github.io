# abuiles.github.io

This repository is a Jekyll-based blog and is meant to be run inside the provided Nix dev shell so that the correct Ruby/Jekyll versions (and Bundler 2.5.9) are used.

## Running the blog locally

1. Ensure you have Nix installed and allow the `nix-command` and `flakes` experimental features (they are required by `flake.nix`).
2. Use the `just` target below or run the command manually from the repo root.

### Recommended (with `just`)

```bash
just serve
```

### Manual command

```bash
nix --extra-experimental-features 'nix-command flakes' develop --command bash -lc 'NIX_RUBY_BIN=$(for p in $(printf "%s" "$PATH" | tr ":" " "); do [ -x "$p/ruby" ] && echo "$p"; done | rg "ruby-3\\.2" | head -n 1); export BUNDLE_PATH="$PWD/vendor/bundle" GEM_HOME="$PWD/.gem" GEM_PATH="$PWD/.gem"; export PATH="$NIX_RUBY_BIN:$GEM_HOME/bin:$PATH"; "$NIX_RUBY_BIN/ruby" -S bundle _2.5.9_ check || "$NIX_RUBY_BIN/ruby" -S bundle _2.5.9_ install; SELECTED_PORT=""; for PORT in 4000 4001 4002; do if ! lsof -nP -iTCP:$PORT -sTCP:LISTEN >/dev/null 2>&1; then SELECTED_PORT=$PORT; break; fi; done; if [ -z "$SELECTED_PORT" ]; then echo "No free site port found (checked 4000 4001 4002)"; exit 1; fi; LR_PORT=""; for CANDIDATE_LR_PORT in 35729 35730 35731; do if ! lsof -nP -iTCP:$CANDIDATE_LR_PORT -sTCP:LISTEN >/dev/null 2>&1; then LR_PORT=$CANDIDATE_LR_PORT; break; fi; done; if [ -z "$LR_PORT" ]; then echo "No free LiveReload port found (checked 35729-35731)"; exit 1; fi; "$NIX_RUBY_BIN/ruby" -S bundle _2.5.9_ exec jekyll serve --livereload --livereload-port $LR_PORT --host 0.0.0.0 --port $SELECTED_PORT'
```

The shell hook in `flake.nix` bootstraps Bundler 2.5.9, installs the site gems into `vendor/bundle`, and then the command above launches Jekyll on the first available site port in `4000, 4001, 4002` and LiveReload port in `35729, 35730, 35731`.
