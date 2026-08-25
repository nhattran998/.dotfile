{ mkFetchurlBin }:
let
  version = "1.1.3";
in
mkFetchurlBin {
  pname = "caveman";
  inherit version;
  srcs = {
    aarch64-darwin = {
      url = "https://github.com/JuliusBrussee/caveman/releases/download/bin-v${version}/caveman-engine_darwin_arm64";
      hash = "sha256-Amg3DU6K0mc3ylRD9AHID/yjxCA/kiEAPJymYQNX5R8=";
    };
    x86_64-darwin = {
      url = "https://github.com/JuliusBrussee/caveman/releases/download/bin-v${version}/caveman-engine_darwin_amd64";
      hash = "sha256-Kkm8bIdYB+9rNcY/J9B0oRYn99M1FEqeJVWQIcQZgqs=";
    };
    x86_64-linux = {
      url = "https://github.com/JuliusBrussee/caveman/releases/download/bin-v${version}/caveman-engine_linux_amd64";
      hash = "sha256-tRE8pUo5s9Y4RYWXtKuTEhleUch1I8XSbMe69fiA5BE=";
    };
    aarch64-linux = {
      url = "https://github.com/JuliusBrussee/caveman/releases/download/bin-v${version}/caveman-engine_linux_arm64";
      hash = "sha256-9VQgQ4UbRiyvvvM4N9W3C7TQsiI6y6nshq15QrrG9ZY=";
    };
  };
  meta.homepage = "https://github.com/JuliusBrussee/caveman";
}
