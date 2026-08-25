{
  stdenv,
  fetchurl,
  autoPatchelfHook,
  lib,
}:
let
  version = "0.0.5";
  srcs = {
    aarch64-darwin = {
      url = "https://github.com/vercel-labs/fx/releases/download/v${version}/fx-macos-aarch64.tar.gz";
      hash = "sha256-K5jMGoXBz16iE/Hfccynn3y/9leT0qhygsBMoBnL0cE=";
    };
    x86_64-darwin = {
      url = "https://github.com/vercel-labs/fx/releases/download/v${version}/fx-macos-x86_64.tar.gz";
      hash = "sha256-DaSpADTBr80lGhossjfqOgATyWWtjCpFt3E2lLUwrYo=";
    };
    aarch64-linux = {
      url = "https://github.com/vercel-labs/fx/releases/download/v${version}/fx-linux-aarch64.tar.gz";
      hash = "sha256-i7zeakElbE+sTgoCIpHPAnQEGeJ6+r3juPReek45Pts=";
    };
    x86_64-linux = {
      url = "https://github.com/vercel-labs/fx/releases/download/v${version}/fx-linux-x86_64.tar.gz";
      hash = "sha256-1WOdFzJnd0qoIopHS69hmnB2rEGpECORUAfIZRQ0KbE=";
    };
  };
  srcSpec =
    srcs.${stdenv.hostPlatform.system}
      or (throw "fx ${version}: no binary for ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "fx";
  inherit version;
  src = fetchurl {
    inherit (srcSpec) url hash;
  };
  nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];
  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ stdenv.cc.cc.lib ];
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  sourceRoot = ".";
  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -m755 fx $out/bin/fx
    runHook postInstall
  '';
  meta = {
    homepage = "https://github.com/vercel-labs/fx";
    mainProgram = "fx";
  };
}
