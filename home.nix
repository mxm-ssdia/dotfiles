{ config, pkgs, ... }:

{
  home.username = "mousam"; # replace with your username
  home.homeDirectory = "/home/mousam"; # replace with your home path

  programs.home-manager.enable = true;

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
