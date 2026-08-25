{
  stdenv,
  fetchurl,
  makeBinaryWrapper,
  nodejs_24,
}:
let
  pins = import ./pins.nix;
  version = pins.pnpm;
  srcs = {
    aarch64-darwin = {
      url = "https://github.com/pnpm/pnpm/releases/download/v${version}/pnpm-darwin-arm64.tar.gz";
      hash = "sha256-/VkYFjVfrwp3hktr2c7nwf2zlT0znqMt0ZfXzsy9xLE=";
    };
    x86_64-linux = {
      url = "https://github.com/pnpm/pnpm/releases/download/v${version}/pnpm-linux-x64.tar.gz";
      hash = "sha256-pLLbKrzhmTMP5Q1F/o1ghYLDYsXMgTn482zxFtnHIRc=";
    };
    aarch64-linux = {
      url = "https://github.com/pnpm/pnpm/releases/download/v${version}/pnpm-linux-arm64.tar.gz";
      hash = "sha256-6GasJr4YRiMCdRX4UIe3YKpkeZYOE8Z/ZMiVXy71pjM=";
    };
  };
  srcSpec =
    srcs.${stdenv.hostPlatform.system}
      or (throw "pnpm ${version}: no binary for ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "pnpm";
  inherit version;
  src = fetchurl {
    inherit (srcSpec) url hash;
  };
  nativeBuildInputs = [ makeBinaryWrapper ];
  dontConfigure = true;
  dontBuild = true;
  setSourceRoot = "sourceRoot=.";
  installPhase = ''
    runHook preInstall
    mkdir -p $out/libexec/pnpm $out/bin
    cp -a dist $out/libexec/pnpm/
    makeWrapper ${nodejs_24}/bin/node $out/bin/pnpm \
      --add-flags "$out/libexec/pnpm/dist/pnpm.mjs"
    runHook postInstall
  '';
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    test "$($out/bin/pnpm --version)" = "$version"
    runHook postInstallCheck
  '';
  meta = {
    homepage = "https://pnpm.io";
    mainProgram = "pnpm";
  };
}
