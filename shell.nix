{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
    nativeBuildInputs = [ pkgs.nasm pkgs.gcc pkgs.gnumake ];
}
