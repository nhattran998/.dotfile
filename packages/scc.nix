{ stdenv, fetchurl }:
let
  version = "4.0.0";
  srcs = {
    aarch64-darwin = {
      url = "https://github.com/boyter/scc/releases/download/v${version}/scc_Darwin_arm64.tar.gz";
      hash = "sha256-As/fyvW69/ZZV0bv38xjAfzonPxqW/i1LteAZJN/2TM=";
    };
    x86_64-darwin = {
      url = "https://github.com/boyter/scc/releases/download/v${version}/scc_Darwin_x86_64.tar.gz";
      hash = "sha256-jubU7UKonZ5fcf4+BqSNV1BQ0mTUjL8zurvKwKMtesU=";
    };
    aarch64-linux = {
      url = "https://github.com/boyter/scc/releases/download/v${version}/scc_Linux_arm64.tar.gz";
      hash = "sha256-pz1TeAF6ux2G2owZpz7eKHjD9zaenqaYeCfNcQqhRlc=";
    };
    x86_64-linux = {
      url = "https://github.com/boyter/scc/releases/download/v${version}/scc_Linux_x86_64.tar.gz";
      hash = "sha256-uFNfsHFN0zxUNMJN4YHk0aYy5qH4aeGYW70QrYuDhUU=";
    };
  };
  srcSpec =
    srcs.${stdenv.hostPlatform.system}
      or (throw "scc ${version}: no binary for ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "scc";
  inherit version;
  src = fetchurl {
    inherit (srcSpec) url hash;
  };
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  sourceRoot = ".";
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 scc $out/bin/scc
    runHook postInstall
  '';
  meta = {
    homepage = "https://github.com/boyter/scc";
    mainProgram = "scc";
  };
}
