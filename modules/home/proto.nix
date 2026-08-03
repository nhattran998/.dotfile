{ config, lib, ... }:
{
  # Investtal toolchain (9cc, atlassian, gh, gitleaks, node, bun, …) is installed
  # by proto from home/.prototools — not from nixpkgs. This module only wires PATH.
  #
  # After first switch / on a fresh machine:
  #   curl -fsSL https://moonrepo.dev/install/proto.sh | bash
  #   proto install   # installs tools listed in ~/.prototools

  home.sessionPath = [
    "${config.home.homeDirectory}/.proto/bin"
    "${config.home.homeDirectory}/.proto/shims"
    "${config.home.homeDirectory}/.local/bin"
  ];

  home.sessionVariables = {
    PROTO_HOME = "${config.home.homeDirectory}/.proto";
  };

  programs.zsh.initContent = lib.mkAfter ''
    # proto shims (node, bun, 9cc, …) — no-op if proto not installed yet
    if [ -d "$HOME/.proto/shims" ]; then
      export PATH="$HOME/.proto/shims:$HOME/.proto/bin:$PATH"
    fi
  '';
}
