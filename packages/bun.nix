{ stdenv, fetchurl, unzip }:
let
  pins = import ./pins.nix;
  version = pins.bun;
  srcs = {
    aarch64-darwin = {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-aarch64.zip";
      hash = "sha256-xmnpf2Fk4cluBwF0jbmN+ndJKQjL2DlMdVcTSnNd44E=";
    };
    x86_64-darwin = {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-darwin-x64.zip";
      hash = "sha256-HQIRuPHcmRGCNEaHrRXnLuhvFUhFpff6R3mUzTQd2bA=";
    };
    x86_64-linux = {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-x64.zip";
      hash = "sha256-LQP7X7g6yLVnrKCigbLOGhoZ1Ij1bClo2Iw/Jekv5FI=";
    };
    aarch64-linux = {
      url = "https://github.com/oven-sh/bun/releases/download/bun-v${version}/bun-linux-aarch64.zip";
      hash = "sha256-SxozLuhhmD65O8/m93D/+U4+MbLDiL2uo8jtNeWO7Q4=";
    };
  };
  srcSpec =
    srcs.${stdenv.hostPlatform.system}
      or (throw "bun ${version}: no binary for ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "bun";
  inherit version;
  nativeBuildInputs = [ unzip ];
  src = fetchurl {
    inherit (srcSpec) url hash;
  };
  dontConfigure = true;
  dontBuild = true;
  sourceRoot = ".";
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 bun-*/bun $out/bin/bun
    runHook postInstall
  '';
  meta = {
    homepage = "https://bun.com";
    mainProgram = "bun";
  };
}
