{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # System Config
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = ["yoyoki"];
    substituters = [ 
      "https://mirrors.cernet.edu.cn/nixos-images/"
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      
      "https://cache.nixos.org"
    ];
  };
  nixpkgs = {
    config = {
      allowUnfree = true;
      pulseaudio = true;
    };
  };
  system.stateVersion = "24.05";
  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };
  networking = {
    networkmanager.enable = true;
    hostName = "nixos";
  };
  time.timeZone = "Asia/Shanghai";

  # System software
  environment.systemPackages = with pkgs; [
    vim
    git
    bash
    zsh
    # sxhkd
  ];
  environment.variables.EDITOR = "vim";

  # Desktop
  services = {
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      # windowManager.bspwm.enable = true;
    };
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    libinput.enable = true;
    flatpak.enable = true;
  };
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  xdg.portal.config.common.default = "gtk";
  i18n = {
    defaultLocale = "zh_CN.UTF-8";
    inputMethod = {
      enabled = "fcitx5";
      fcitx5.addons = with pkgs; [
        fcitx5-mozc
        fcitx5-gtk
	kdePackages.fcitx5-chinese-addons
      ];
    };
  };

  # ssh
  services.openssh.enable = true;

  # fonts
  fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
          noto-fonts
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
          jetbrains-mono
          (terminus-nerdfont.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      ];
      fontconfig = {
          defaultFonts = {
              emoji = [
                  "Noto Color Emoji"
              ];
              monospace = [
                  "JetBrains Mono"
                  "Noto Sans Mono CJK SC"
                  "Symbols Nerd Font"
              ];
              sansSerif = [
                  "Noto Sans"
                  "Noto Sans CJK SC"
                  "Symbols Nerd Font"
              ];
              serif = [
                  "Noto Serif"
                  "Noto Serif CJK SC"
                  "Symbols Nerd Font"
              ];
          };
      };
  };

  # Sound
  sound = {
    enable = true;
    extraConfig = ''
      defaults.pcm.card 0
      defaults.ctl.card 0
    '';
  };
  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
  };

  # User
  programs.zsh.enable = true;
  users.users.yoyoki = {
    isNormalUser = true;
    home = "/home/yoyoki";
    description = "I am what is me.";
    extraGroups = [ "wheel" "networkmanager" ];
    password = "yoyoki";
    shell = pkgs.zsh;
  };

}

