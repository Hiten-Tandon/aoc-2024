{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs-channels/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {nixpkgs, flake-utils, ...}: flake-utils.lib.eachDefaultSystem (system: 
    with import nixpkgs {inherit system;}; {
      devShells.default = mkShell {
        nativeBuildInputs = [gleam erlang_27];
      };
      formatter = nixfmt-classic;
    }
  );
}
