{ config, pkgs, ... }:

{
  home.username = "yoyoki";
  home.homeDirectory = "/home/yoyoki";

  # User software
  home.packages = with pkgs; [
    firefox
    v2ray
    v2raya
    neovim
  ];

  # git
  programs.git = {
    enable = true;
    userEmail = "2197651308@qq.com";
    userName = "yoyoki";
  };

  # zsh
  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = ["git"];
    };
    initExtra = ''
    set -o vi
    '';
  };

  # kitty
  home.file.".config/kitty" = {
    source = ../dotfiles/kitty;
    recursive = true;
    executable = true;
  };

  # neovim
  home.file.".config/nvim" = {
    source = ../dotfiles/nvim;
    recursive = true;
    executable = true;
  };

  # emacs
  home.file.".emacs.d" = {
    source = ../dotfiles/.emacs.d;
    recursive = true;
    executable = true;
  };

  # feh
  home.file.".config/feh" = {
    source = ../dotfiles/feh;
    recursive = true;
    executable = true;
  };

  # bspwm
  home.file.".config/bspwm/bspwmrc".source = ../dotfiles/bspwm/bspwmrc;

  # sxhkd
  home.file.".config/sxhkd/sxhkdrc".source = ../dotfiles/sxhkd/sxhkdrc;

  # picom
  home.file.".config/picom/picom.conf".source = ../dotfiles/picom/picom.conf;

  # sound
  home.file.".asoundrc".source = ../dotfiles/.asoundrc;

  # rofi
  home.file.".config/rofi" = {
    source = ../dotfiles/rofi;
    recursive = true;
    executable = true;
  };

  # polybar
  home.file.".config/polybar" = {
    source = ../dotfiles/polybar;
    recursive = true;
    executable = true;
  };

  # itself
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

}
