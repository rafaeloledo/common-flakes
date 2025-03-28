{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    # nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-24.11";
  };

  outputs = { ... } @ inputs:
  let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
  in
  {
      python = pkgs.mkShell {
        packages = with pkgs; [
          # these are not meant to be in the system
          (pkgs.python313.withPackages (p: with p; [
            glfw
            pyopengl
            pyopengl-accelerate
          ]))
          python313 # override system default
          renderdoc # optional
        ];

        shellHook = ''
          echo "${pkgs.python313}"
          # qrenderdoc
        '';
      };

  };
}
