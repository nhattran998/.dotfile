{ stdenv, fetchurl }:
let
  version = "1.5.0";
  srcs = {
    aarch64-darwin = {
      url = "https://github.com/colbymchenry/codegraph/releases/download/v${version}/codegraph-darwin-arm64.tar.gz";
      hash = "sha256-z17kNabkTQl7L5jyt7i5QiuxCUhEQE7+2CUZxdoa8s8=";
    };
    x86_64-darwin = {
      url = "https://github.com/colbymchenry/codegraph/releases/download/v${version}/codegraph-darwin-x64.tar.gz";
      hash = "sha256-CgzMKb99qdEL4UWNidfhXFWSeuJM2V6fo95L3+oFnd4=";
    };
    aarch64-linux = {
      url = "https://github.com/colbymchenry/codegraph/releases/download/v${version}/codegraph-linux-arm64.tar.gz";
      hash = "sha256-nxd1Cu30XVH2jKrjntIdbipykLIyblxT+VoWWRjr0dg=";
    };
    x86_64-linux = {
      url = "https://github.com/colbymchenry/codegraph/releases/download/v${version}/codegraph-linux-x64.tar.gz";
      hash = "sha256-K6Zeh6EhC3BrseZ9Xki1/EoZNeQ9uz+18xxVl4QNLlg=";
    };
  };
  srcSpec =
    srcs.${stdenv.hostPlatform.system}
      or (throw "codegraph ${version}: no binary for ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  pname = "codegraph";
  inherit version;
  src = fetchurl {
    inherit (srcSpec) url hash;
  };
  dontConfigure = true;
  dontBuild = true;
  dontStrip = true;
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -a . $out/
    chmod +x $out/bin/codegraph $out/node
    runHook postInstall
  '';
  meta = {
    homepage = "https://github.com/colbymchenry/codegraph";
    mainProgram = "codegraph";
  };
}
