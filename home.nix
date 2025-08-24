{ pkgs, ... }:

{
  home.username = "mousam";
  home.homeDirectory = "/home/mousam";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [ git neofetch ];

  programs.zsh.enable = false;
  programs.neovim.enable = false;
  programs.git.enable = false;
}
