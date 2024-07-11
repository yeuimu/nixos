{ config, pkgs, ... }:

let
  # dotfiles仓库
  dotfiles = pkgs.fetchgit {
    url = "https://gitee.com/yeuimu/dotfiles.git";
    rev = "refs/heads/main";
    sha256 = "14hwpsm8wds5v184mpgksfvqpsj8vpjxhz8xvs69bw9m141f3bs2";
  };
in
{
  home.username = "yoyoki";
  home.homeDirectory = "/home/yoyoki";

  # User software
  home.packages = with pkgs; [
    
    v2ray
    v2raya

    zsh
    neovim
    kitty
    firefox
    nnn
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
    file
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
    source = "${dotfiles}/kitty";
    recursive = true;
    executable = true;
  };

  # neovim
  home.file.".config/nvim" = {
    source = "${dotfiles}/nvim";
    recursive = true;
    executable = true;
  };

  # zsh
  # home.file.".zshrc" = {
  #   source = "${dotfiles}/zsh/.zshrc";
  # };

  # itself
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
