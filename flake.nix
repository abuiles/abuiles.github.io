{
  description = "Nix dev shell for abuiles.github.io";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          ruby_3_2
          jekyll
          cloudflared
          git
          coreutils
        ];

        shellHook = ''
          export BUNDLE_PATH="$PWD/vendor/bundle"
          export GEM_HOME="$PWD/.gem"
          export GEM_PATH="$PWD/.gem"
          export PATH="$GEM_HOME/bin:$PATH"

          if ! bundle _2.5.9_ --version >/dev/null 2>&1; then
            gem install bundler -v 2.5.9 --no-document --install-dir "$GEM_HOME" --bindir "$GEM_HOME/bin"
          fi

          bundle _2.5.9_ check >/dev/null 2>&1 || bundle _2.5.9_ install
        '';
      };
    });
}
