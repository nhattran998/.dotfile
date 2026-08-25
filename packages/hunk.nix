{ stdenv, fetchurl }:
let
  version = "0.19.0";
  srcs = {
    aarch64-darwin = {
      url = "https://github.com/modem-dev/hunk/releases/download/v${version}/hunkdiff-darwin-arm64.tar.gz";
      hash = "sha256-fuzmmCyxRhwMIvnXCkGw+4CU2WXvAtwi+DirwN5xpCk=";
    };
    x86_64-darwin = {
      url = "https://github.com/modem-dev/hunk/releases/download/v${version}/hunkdiff-darwin-x64.tar.gz";
      hash = "sha256-43lGDNDszL0PEJuYve3KEpBVz/+gALxo3YJVUxYW2zE=";
    };
    aarch64-linux = {
      url = "https://github.com/modem-dev/hunk/releases/download/v${version}/hunkdiff-linux-arm64.tar.gz";
      hash = "sha256-L13CVfv0fVlO0xr97AiPAoMeRCKB1VQFkwFjyOIKXt8=";
    };
    x86_64-linux = {
      url = "https://github.com/modem-dev/hunk/releases/download/v${version}/hunkdiff-linux-x64.tar.gz";
      hash = "sha256-1NlC/twFuLtRc+KRPlRUBqXZQSug3biPjn9NzXf9BgI=";
    };
  };
  srcSpec =
    srcs.${stdenv.hostPlatform.system}
      or (throw "hunk ${version}: no binary for ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "hunk";
  inherit version;
  src = fetchurl {
    inherit (srcSpec) url hash;
  };
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 hunk $out/bin/hunk
    cp -a skills $out/skills
    runHook postInstall
  '';
  meta = {
    homepage = "https://github.com/modem-dev/hunk";
    mainProgram = "hunk";
  };
}
