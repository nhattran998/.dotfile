# Omarchy (Arch) host overlay. Import only on Omarchy flake attrs.
# Ports Omarchy's Bash environment into Nix-managed Zsh.
{
  pkgs,
  lib,
  ...
}:
{
  assertions = [
    {
      assertion = pkgs.stdenv.isLinux;
      message = "modules/home/omarchy.nix is for Omarchy Linux hosts only";
    }
  ];

  programs.bash = {
    bashrcExtra = ''
      [[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] &&
        source /usr/share/omarchy/default/bash/env-bootstrap
    '';
    initExtra = lib.mkBefore ''
      if [[ -r "$OMARCHY_PATH/default/bash/rc" ]]; then
        source "$OMARCHY_PATH/default/bash/rc"
      fi
    '';
  };

  programs.zsh = {
    envExtra = ''
      [[ -r /usr/share/omarchy/default/bash/env-bootstrap ]] &&
        source /usr/share/omarchy/default/bash/env-bootstrap
    '';

    initContent = lib.mkOrder 900 ''
      # Port the current Omarchy Bash environment, aliases, and functions.
      # Bash-only history, completion, prompt, and Readline setup are replaced
      # by native Zsh equivalents in common.nix.
      if [[ -r "$OMARCHY_PATH/default/bash/envs" ]]; then
        source "$OMARCHY_PATH/default/bash/envs"
      fi

      if [[ -r "$OMARCHY_PATH/default/bash/aliases" ]]; then
        source "$OMARCHY_PATH/default/bash/aliases"
      fi

      # Zsh cannot parse ga/gd function definitions while the Oh My Zsh
      # aliases are active, so remove them while loading Omarchy's helpers.
      unalias ga gd 2>/dev/null
      for omarchy_fn in "$OMARCHY_PATH"/default/bash/fns/*(N); do
        source "$omarchy_fn"
      done
      unset omarchy_fn

      # Keep Omarchy's worktree helpers under non-conflicting names. The
      # standard Oh My Zsh Git commands remain ga=git-add and gd=git-diff.
      if (( $+functions[ga] )); then
        functions -c ga gwtn
        unfunction ga
      fi
      if (( $+functions[gd] )); then
        functions -c gd gwtd
        unfunction gd
      fi
      alias ga='git add'
      alias gd='git diff'

      # Two Omarchy layout helpers use Bash's zero-based array indexes.
      # Preserve normal Zsh array behavior everywhere else.
      if (( $+functions[hsl] )); then
        functions -c hsl _omarchy_bash_hsl
        hsl() {
          setopt localoptions ksharrays
          _omarchy_bash_hsl "$@"
        }
      fi
      if (( $+functions[tsl] )); then
        functions -c tsl _omarchy_bash_tsl
        tsl() {
          setopt localoptions ksharrays
          _omarchy_bash_tsl "$@"
        }
      fi

      unsetopt HASH_CMDS

      if command -v mise >/dev/null 2>&1; then
        eval "$(mise activate zsh)"
      fi

      if command -v try >/dev/null 2>&1; then
        try() {
          unfunction try
          eval "$(SHELL=${lib.getExe pkgs.zsh} command try init ~/Work/tries)"
          try "$@"
        }
      fi

      if command -v fzf >/dev/null 2>&1; then
        [[ -r /usr/share/fzf/completion.zsh ]] &&
          source /usr/share/fzf/completion.zsh
        [[ -r /usr/share/fzf/key-bindings.zsh ]] &&
          source /usr/share/fzf/key-bindings.zsh
      fi
    '';
  };
}
