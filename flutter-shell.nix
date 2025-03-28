# nix-channel --add https://tadfisher.github.io/android-nixpkgs android-nixpkgs
# nix-channel --update android-nixpkgs

{ pkgs ? import <nixpkgs> {} }:

let
  pinnedJDK = pkgs.jdk23;
  android-nixpkgs = pkgs.callPackage <android-nixpkgs> {
    channel = "stable";
  };
  android-sdk = android-nixpkgs.sdk (sdkPkgs: with sdkPkgs; [
    cmdline-tools-latest
    build-tools-33-0-0
    platform-tools
    platforms-android-33
  ]);
in

(pkgs.buildFHSEnv {
  name = "flutter-env";

  targetPkgs = pkgs: ([
    pinnedJDK
    android-sdk

    pkgs.flutter
    pkgs.dart
  ]); 

  runScript = "fish";

  profile = ''
    export ANDROID_HOME=${android-sdk}/share/android-sdk
    export JAVA_HOME=${pinnedJDK}
    export NIX_SHELL="1"
  '';
}).env
