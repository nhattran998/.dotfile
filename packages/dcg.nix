{ stdenv, fetchurl }:
let
  version = "0.12.5";
  srcs = {
    aarch64-darwin = {
      url = "https://github.com/Dicklesworthstone/destructive_command_guard/releases/download/v${version}/dcg-aarch64-apple-darwin.tar.xz";
      hash = "sha256-bf39emxIw23pYJFPtDubnilRU8J63BUeES8MUMpbhjw=";
    };
    x86_64-darwin = {
      url = "https://github.com/Dicklesworthstone/destructive_command_guard/releases/download/v${version}/dcg-x86_64-apple-darwin.tar.xz";
      hash = "sha256-s2+p0ll1YNjM7LTUbbVK8UDhY87H+v5eIY6hNqYjTIA=";
    };
    aarch64-linux = {
      url = "https://github.com/Dicklesworthstone/destructive_command_guard/releases/download/v${version}/dcg-aarch64-unknown-linux-gnu.tar.xz";
      hash = "sha256-HuF3QbP83r7XzLFes7PclqVTbret1Y+A0kC7ToQo2M8=";
    };
    x86_64-linux = {
      url = "https://github.com/Dicklesworthstone/destructive_command_guard/releases/download/v${version}/dcg-x86_64-unknown-linux-musl.tar.xz";
      hash = "sha256-0ghrsoAbN9XIeOADH6CR33SiSpC5P+nTMgHxWx6EuJE=";
    };
  };
  srcSpec =
    srcs.${stdenv.hostPlatform.system}
      or (throw "dcg ${version}: no binary for ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "dcg";
  inherit version;
  src = fetchurl {
    inherit (srcSpec) url hash;
  };
  dontConfigure = true;
  dontBuild = true;
  unpackPhase = ''
    tar -xJf $src
  '';
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 dcg $out/bin/dcg
    runHook postInstall
  '';
  meta = {
    homepage = "https://github.com/Dicklesworthstone/destructive_command_guard";
    mainProgram = "dcg";
  };
}
