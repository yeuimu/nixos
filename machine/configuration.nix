{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # System Config
  networking.networkmanager.enable = true;
  networking.hostName = "nixos";
  time.timeZone = "Asia/Shanghai";

  # System software
  environment.systemPackages = with pkgs; [
    vim
    git
    bash
    zsh
    sxhkd
  ];
  environment.variables.EDITOR = "vim";

  # Desktop
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.windowManager.bspwm = {
    enable = true;
  };
  services.libinput.enable = true;
  i18n.defaultLocale = "zh_CN.UTF-8";

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

  nix.settings = {
    trusted-users = ["yoyoki"];
    substituters = [ 
      "https://mirror.sjtu.edu.cn/nix-channels/store"
      "https://mirrors.ustc.edu.cn/nix-channels/store"
      
      "https://cache.nixos.org"
    ];
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;
  system.stateVersion = "24.05";
}

