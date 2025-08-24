{ config, pkgs, ... }:

{
  home.username = "mousam"; # replace with your username
  home.homeDirectory = "/home/mousam"; # replace with your home path

  home.stateVersion = "24.11";
  programs.home-manager.enable = true;

  # Example: enable Neovim
  programs.neovim.enable = true;

  # Packages you always want installed
  home.packages = with pkgs; [
    neovim
    git
    nil # Nix LSP
    alejandra # Nix formatter
  ];

  # Link your Neovim config
  # home.file.".config/nvim".source = ./config/nvim;
}
