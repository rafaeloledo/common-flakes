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
      build-tools-33-0-0
      platform-tools
      platforms-android-33
    ]);
    pinnedJDK = pkgs.jdk23;
  in

  {
    shell = pkgs.mkShell {
      packages = [
        pkgs.flutter
        pkgs.dart
        
        pinnedJDK
        
        android-sdk

        pkgs.python313
      ];

      JAVA_HOME = pinnedJDK;

      ANDROID_HOME = "${android-sdk}/share/android-sdk";
      ANDROID_SDK_ROOT = "${android-sdk}/share/android-sdk";

      NIX_SHELL = "1";
    };
  };
}
