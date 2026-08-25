{ buildNpmPackage, fetchFromGitHub, nodejs_24 }:
buildNpmPackage rec {
  pname = "wigolo";
  version = "0.2.1";
  src = fetchFromGitHub {
    owner = "KnockOutEZ";
    repo = "wigolo";
    rev = "v${version}";
    hash = "sha256-vDKh4ExcjH4dbfX0pq2Ds73AtnYyjQsVZ9DZcVKgXOQ=";
  };
  npmDepsHash = "sha256-/Dntq76jW+TZm7k2aDsUSfea1elWO6PBLuYfuECqVAE=";
  nodejs = nodejs_24;
  env.ONNXRUNTIME_NODE_INSTALL_CUDA = "skip";
  meta = {
    homepage = "https://github.com/KnockOutEZ/wigolo";
    mainProgram = "wigolo";
  };
}
