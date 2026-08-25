{ mkFetchurlBin }:
let
  version = "1.0.144";
in
mkFetchurlBin {
  pname = "officecli";
  inherit version;
  srcs = {
    aarch64-darwin = {
      url = "https://github.com/iOfficeAI/OfficeCLI/releases/download/v${version}/officecli-mac-arm64";
      hash = "sha256-BHVxY0KMW96Nkej4OFF4GOdHIhV3IspfOHe2cWt3vUU=";
    };
    x86_64-darwin = {
      url = "https://github.com/iOfficeAI/OfficeCLI/releases/download/v${version}/officecli-mac-x64";
      hash = "sha256-NmEAZD11ew2iSClCKJfKdHaKiUtezRpHGhM2+OKgeH0=";
    };
    aarch64-linux = {
      url = "https://github.com/iOfficeAI/OfficeCLI/releases/download/v${version}/officecli-linux-arm64";
      hash = "sha256-VuwsMRS2b2SQiItneMu4QTplkRomysxyB/KeE0JJZto=";
    };
    x86_64-linux = {
      url = "https://github.com/iOfficeAI/OfficeCLI/releases/download/v${version}/officecli-linux-x64";
      hash = "sha256-Mu96IaVKTKbJgGv16fPTK/sSkQFzKcVQRMsqrHGCLrg=";
    };
  };
  meta.homepage = "https://github.com/iOfficeAI/OfficeCLI";
}
