{ config, pkgs, ... }:

{
  home = {
    username = "yoyoki";
    homeDirectory = "/home/yoyoki";
    packages = with pkgs; [
      # editor
      emacs
      neovim
      # utility
      unzip
      # dev
      gcc
      gnumake
      nodenv
      nodejs_20
      python3
    ];
    stateVersion = "24.05";
    file = {
      ".config/nvim" = {
        source = ../dotfiles/nvim;
        recursive = true;
        executable = true;
      };
      ".emacs.d" = {
        source = ../dotfiles/.emacs.d;
        recursive = true;
        executable = true;
      };
    };
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userEmail = "2197651308@qq.com";
      userName = "yoyoki";
    };
    zsh = {
      enable = true;
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = ["git"];
      };
      initExtra = ''
        alias v="nvim"
        alias vim="nvim"
        alias vi="nvim"
        alias c="cd"
        alias b="cd .."
        alias x="startx"
        alias cls="clear"
        alias e="emacs -nw"
        alias sd="sudo"
        alias soft="ssh soft"
        set -o vi
      '';
    };
  };
}
