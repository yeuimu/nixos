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

  # 启用并配置 zsh 作为默认 shell
  programs.zsh = {
    enable = true;
    oh-my-zsh.enable = true;  # 可选：启用 oh-my-zsh
    # 配置其他 zsh 选项
  };

  # 设置 zsh 作为默认 shell
  home.sessionVariables.SHELL = "${pkgs.zsh}/bin/zsh";

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

  # git
  programs.git = {
    enable = true;
    userName = "yoyoki";
    userEmail = "yeuimuyeuimu@gmail.com";
  };

  # itself
  home.stateVersion = "24.05";
  programs.home-manager.enable = true;
}
