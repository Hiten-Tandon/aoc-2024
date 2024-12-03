{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      with import nixpkgs {
        inherit system;
        overlays = [ (import rust-overlay) ];
      }; {
        devShells.default = mkShell {
          nativeBuildInputs = [ rust-bin.nightly.latest.default cargo oniguruma pkg-config rust-analyzer openssl_3_3];
        };
        formatter = nixfmt-classic;
      });
}
