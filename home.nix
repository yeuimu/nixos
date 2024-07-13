{ config, pkgs, ... }:

{
  home.username = "yoyoki";
  home.homeDirectory = "/home/yoyoki";

  # User software
  home.packages = with pkgs; [
    # Destop
    feh
    rofi
    polybar
    picom

    # GUI Software
    kitty
    firefox
    wpsoffice-cn
    pavucontrol

    # Proxy
    v2ray
    v2raya

    zsh
    neovim
    git

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # grep
    jq # JSON processor
    eza # ls
    fzf # fuzzy finder

    # networking tools
    aria2 # download utility

    # misc
    which
    tree

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
    # alias
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

    # fcitx setting
    export XMODIFIERS=@im=fcitx
    export GTK_IM_MODULE=xim
    export QT_IM_MODULE=fcitx
    export DefaultIMModule=fcitx

    set -o vi
    '';
  };

  # kitty
  home.file.".config/kitty" = {
    source = ./dotfiles/kitty;
    recursive = true;
    executable = true;
  };

  # neovim
  home.file.".config/nvim" = {
    source = ./dotfiles/nvim;
    recursive = true;
    executable = true;
  };

  # emacs
  home.file.".emacs.d" = {
    source = dotfiles/.emacs.d;
    recursive = true;
    executable = true;
  };

  # feh
  home.file.".config/feh" = {
    source = dotfiles/feh;
    recursive = true;
    executable = true;
  };

  # bspwm
  home.file.".config/bspwm/bspwmrc".source = ./dotfiles/bspwm/bspwmrc;

  # sxhkd
  home.file.".config/sxhkd/sxhkdrc".source = ./dotfiles/sxhkd/sxhkdrc;

  # picom
  home.file.".config/picom/picom.conf".source = ./dotfiles/picom/picom.conf;

  # sound
  home.file.".asoundrc".source = ./dotfiles/.asoundrc;

  # rofi
  home.file.".config/rofi" = {
    source = ./dotfiles/rofi;
    recursive = true;
    executable = true;
  };

  # polybar
  home.file.".config/polybar" = {
    source = ./dotfiles/polybar;
    recursive = true;
    executable = true;
  };

  # itself
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

}
