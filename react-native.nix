{
  inputs = {
    android-nixpkgs.url = "github:tadfisher/android-nixpkgs";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, android-nixpkgs, nixpkgs, ... } @ inputs:

  let
    android-pkgs = with pkgs; callPackage android-nixpkgs {};
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; config.allowUnfree = true; } ;
    android-sdk = android-pkgs.sdk (p: with p; [
      cmdline-tools-latest
      build-tools-30-0-0
      platform-tools
      platforms-android-30
      emulator
    ]);
  in

  {
    shell = pkgs.mkShell {
      packages = [
        pkgs.firebase-tools
        pkgs.jdk21
        pkgs.nodejs_22
        
        android-sdk

        (pkgs.python313.withPackages (p: with p; [
        ]))
        # use 3.13 python verison
        pkgs.python313
      ];
    };
  };
}
