{ stdenv, fetchzip, fetchurl }:
{
  mkFetchzipBin =
    {
      pname,
      version,
      srcs,
      binName ? pname,
      meta ? { },
    }:
    let
      src =
        srcs.${stdenv.hostPlatform.system}
          or (throw "${pname} ${version}: no binary for ${stdenv.hostPlatform.system}");
    in
    stdenv.mkDerivation {
      inherit pname version;
      src = fetchzip {
        inherit (src) url hash;
      };
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        install -m755 ${binName} $out/bin/${binName}
        runHook postInstall
      '';
      meta = {
        description = "${pname} ${version}";
        mainProgram = binName;
      }
      // meta;
    };

  mkFetchurlBin =
    {
      pname,
      version,
      srcs,
      binName ? pname,
      meta ? { },
    }:
    let
      src =
        srcs.${stdenv.hostPlatform.system}
          or (throw "${pname} ${version}: no binary for ${stdenv.hostPlatform.system}");
    in
    stdenv.mkDerivation {
      inherit pname version;
      src = fetchurl {
        inherit (src) url hash;
      };
      dontUnpack = true;
      dontConfigure = true;
      dontBuild = true;
      installPhase = ''
        runHook preInstall
        mkdir -p $out/bin
        install -m755 $src $out/bin/${binName}
        runHook postInstall
      '';
      meta = {
        description = "${pname} ${version}";
        mainProgram = binName;
      }
      // meta;
    };
}
