{
  description = "Rxyhn's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-wayland.url = "github:nix-community/nixpkgs-wayland";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixpkgs-f2k.url = "github:fortuneteller2k/nixpkgs-f2k";
    ragenix.url = "github:yaxitech/ragenix";
    hyprland.url = "github:hyprwm/Hyprland/";
    nur.url = "github:nix-community/NUR";
    webcord.url = "github:fufexan/webcord-flake";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Non flakes
    fzf-tab = {
      url = "github:Aloxaf/fzf-tab";
      flake = false;
    };

    zsh-completions = {
      url = "github:zsh-users/zsh-completions";
      flake = false;
    };

    zsh-syntax-highlighting = {
      url = "github:zsh-users/zsh-syntax-highlighting";
      flake = false;
    };
  };
  outputs = {nixpkgs, ...} @ inputs: let
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

    overlays = with inputs; [
      (
        final: _: let
          inherit (final) system;
        in (with nixpkgs-f2k.packages.${system}; {
          # Overlays with f2k's repo
          awesome = awesome-git;
          picom = picom-git;
          wezterm = wezterm-git;
        })
      )
      nur.overlay
      nixpkgs-wayland.overlay
      nixpkgs-f2k.overlays.default
      rust-overlay.overlays.default
    ];
  in {
    # standalone home-manager config
    inherit (import ./home/profiles inputs) homeConfigurations;

    # nixos-configs with home-manager
    nixosConfigurations = import ./hosts inputs;

    # dev shell (for direnv)
    devShells.x86_64-linux.default = pkgs.mkShell {
      packages = with pkgs; [
        rnix-lsp
        yaml-language-server
        alejandra
        git
      ];
      name = "dotfiles";
    };

    nixpkgs.overlays = overlays;
    overlays.default = import ./pkgs;
    packages.x86_64-linux = import ./pkgs null pkgs;
  };
}
