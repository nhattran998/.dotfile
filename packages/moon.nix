{ stdenv, fetchurl }:
let
  pins = import ./pins.nix;
  version = pins.moon;
  srcs = {
    aarch64-darwin = {
      url = "https://github.com/moonrepo/moon/releases/download/v${version}/moon_cli-aarch64-apple-darwin.tar.xz";
      hash = "sha256-j9ZjZnv3WmbmmQ2dElHdYo3KP7diGoaWJ3pZP2dwP48=";
    };
    x86_64-darwin = {
      url = "https://github.com/moonrepo/moon/releases/download/v${version}/moon_cli-x86_64-apple-darwin.tar.xz";
      hash = "sha256-HMM53BjeWw+n55hAgMvbLoh3LUUGKiD0WitGcsM9tIo=";
    };
    x86_64-linux = {
      url = "https://github.com/moonrepo/moon/releases/download/v${version}/moon_cli-x86_64-unknown-linux-gnu.tar.xz";
      hash = "sha256-oDW8jbYwSkAFBjKmIFbR0bAkGR6vdbvekxnZ8O4WBLY=";
    };
    aarch64-linux = {
      url = "https://github.com/moonrepo/moon/releases/download/v${version}/moon_cli-aarch64-unknown-linux-gnu.tar.xz";
      hash = "sha256-jz3fwoKX2qIvIOlC3SRg+txPjt3RQby33dfhyUwAkUs=";
    };
  };
  srcSpec =
    srcs.${stdenv.hostPlatform.system}
      or (throw "moon ${version}: no binary for ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "moon";
  inherit version;
  src = fetchurl {
    inherit (srcSpec) url hash;
  };
  dontConfigure = true;
  dontBuild = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 moon $out/bin/moon
    runHook postInstall
  '';
  meta = {
    homepage = "https://github.com/moonrepo/moon";
    mainProgram = "moon";
  };
}
