# AGENTS.md

## Running the blog

- Preferred: `just serve`
- First-time dependency setup: `just nix-setup`
- Fallback if `nix develop` is unavailable but local gems already exist: `just local-serve`

`just serve` starts Jekyll inside the Nix dev shell, installs gems if needed, and picks the first free site port from `4000`, `4001`, `4002` plus the first free LiveReload port from `35729`, `35730`, `35731`.

## Creating a new post

- Create a post scaffold: `just new-post "My New Post Title"`

That command creates a file in `_posts/` named `YYYY-MM-DD-my-new-post-title.markdown` with:

- `layout: post`
- the provided title
- the current local timestamp in the `date` front matter

## Useful commands

- Build the site in the Nix environment:
  `nix --extra-experimental-features 'nix-command flakes' develop --command bash -lc 'NIX_RUBY_BIN=$(for p in $(printf "%s" "$PATH" | tr ":" " "); do [ -x "$p/ruby" ] && echo "$p"; done | rg "ruby-3\\.2" | head -n 1); export BUNDLE_PATH="$PWD/vendor/bundle" GEM_HOME="$PWD/.gem" GEM_PATH="$PWD/.gem"; export PATH="$NIX_RUBY_BIN:$GEM_HOME/bin:$PATH"; "$NIX_RUBY_BIN/ruby" -S bundle _2.5.9_ exec jekyll build'`
- Check available `just` recipes: `just --list`
- Preview the built `_site` directory statically: `python3 -m http.server 4010 --directory _site`

## Editing guidance

- Prefer `just` recipes over retyping long Nix commands.
- Use `apply_patch` for tracked file edits.
- Do not commit or push unless the user explicitly asks for it.
