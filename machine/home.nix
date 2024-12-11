{ config, pkgs, ... }:

{
  home.username = "yoyoki";
  home.homeDirectory = "/home/yoyoki";

  # User software
  home.packages = with pkgs; [
    vscode-fhs
    neovim
    emacs
    unzip
    lazygit
    # neovim
    lua-language-server # lua lsp
    stylua # lua fmt
    rust-analyzer # rust lsp
    rustfmt # rust fmt
    pyright # python lsp
    python312Packages.autopep8 # python fmt
    nil # nix lsp
    nixfmt-rfc-style # nix fmt
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
      plugins = [ "git" ];
    };
    initExtra = ''
      set -o vi
    '';
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

  # Bspwm Windows Manager
  # home.file.".config/bspwm/bspwmrc".source = ../dotfiles/bspwm/bspwmrc;
  # home.file.".config/sxhkd/sxhkdrc".source = ../dotfiles/sxhkd/sxhkdrc; # sxhkd 
  # home.file.".config/picom/picom.conf".source = ../dotfiles/picom/picom.conf; # picom
  # home.file.".asoundrc".source = ../dotfiles/.asoundrc; # sound
  # home.file.".config/feh" = {
  #   source = ../dotfiles/feh;
  #   recursive = true;
  #   executable = true;
  # }; # feh
  # home.file.".config/rofi" = {
  #   source = ../dotfiles/rofi;
  #   recursive = true;
  #   executable = true;
  # }; # rofi
  # home.file.".config/polybar" = {
  #   source = ../dotfiles/polybar;
  #   recursive = true;
  #   executable = true;
  # }; # polybar
  home.file.".config/kitty" = {
    source = ../dotfiles/kitty;
    recursive = true;
    executable = true;
  }; # kitty

  # itself
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
