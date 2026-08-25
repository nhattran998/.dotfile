{
  pkgs,
}:
let
  inherit (pkgs.callPackage ./fetch-bin.nix { }) mkFetchurlBin;
  moon = pkgs.callPackage ./moon.nix { };
  bun = pkgs.callPackage ./bun.nix { };
  pnpm = pkgs.callPackage ./pnpm.nix { };
  dcg = pkgs.callPackage ./dcg.nix { };
  caveman = pkgs.callPackage ./caveman.nix { inherit mkFetchurlBin; };
  wigolo = pkgs.callPackage ./wigolo.nix { };
  codegraph = pkgs.callPackage ./codegraph.nix { };
  hunk = pkgs.callPackage ./hunk.nix { };
  officecli = pkgs.callPackage ./officecli.nix { inherit mkFetchurlBin; };
  herdr = pkgs.callPackage ./herdr.nix { inherit mkFetchurlBin; };
  fx = pkgs.callPackage ./fx.nix { };
  scc = pkgs.callPackage ./scc.nix { };

  rustToolchain = pkgs.symlinkJoin {
    name = "rust-toolchain";
    paths = [
      pkgs.rustc
      pkgs.cargo
      pkgs.rustfmt
      pkgs.clippy
    ];
    meta.mainProgram = "rustc";
  };

  python314WithPip = pkgs.python314.withPackages (ps: [ ps.pip ]);
  pins = import ./pins.nix;
  node = pkgs.nodejs_24;
  glow = pkgs.glow;
in
assert node.version == pins.node;
{
  inherit
    moon
    bun
    pnpm
    node
    glow
    dcg
    caveman
    wigolo
    codegraph
    hunk
    officecli
    herdr
    fx
    scc
    rustToolchain
    ;
  list = [
    moon
    pkgs.git
    pkgs.git-lfs
    pkgs.gnumake
    pkgs.curl
    pkgs.gnutar
    pkgs.gh
    pkgs.ripgrep
    pkgs.fd
    pkgs.fzf
    pkgs.eza
    pkgs.bat
    pkgs.tree
    pkgs.starship
    pkgs.zoxide
    pkgs.jq
    pkgs.yq-go
    pkgs.lazygit
    pkgs.delta
    pkgs.htop
    pkgs.bottom
    pkgs.vim
    fx
    glow
    pkgs.gitleaks
    pkgs.trivy
    pkgs.shellcheck
    pkgs.shfmt
    pkgs.kubectl
    pkgs.uv
    python314WithPip
    node
    pnpm
    bun
    pkgs.zig
    pkgs.semgrep
    pkgs.ast-grep
    pkgs.nixfmt
    rustToolchain
    pkgs.cargo-nextest
    pkgs.rtk
    pkgs.liteparse
    officecli
    pkgs.temurin-jre-bin-25
    herdr
    wigolo
    caveman
    dcg
    codegraph
    hunk
    scc
  ];
}
