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

  # Desktop
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.libinput.enable = true;
  i18n.defaultLocale = "zh_CN.UTF-8";

  # ssh
  services.openssh.enable = true;

  # fonts
  fonts = {
      fontDir.enable = true;
      packages = with pkgs; [
          noto-fonts
          source-code-pro
          source-han-sans
          source-han-serif
          sarasa-gothic
          (terminus-nerdfont.override { fonts = [ "NerdFontsSymbolsOnly" ]; })
      ];
      fontconfig = {
          defaultFonts = {
              emoji = [
                  "Noto Color Emoji"
              ];
              monospace = [
                  "Noto Sans Mono CJK SC"
                  "Sarasa Mono SC"
                  "DejaVu Sans Mono"
                  "Symbols Nerd Font"
              ];
              sansSerif = [
                  "Noto Sans CJK SC"
                  "Source Han Sans SC"
                  "DejaVu Sans"
                  "Symbols Nerd Font"
              ];
              serif = [
                  "Noto Serif CJK SC"
                  "Source Han Serif SC"
                  "DejaVu Serif"
                  "Symbols Nerd Font"
              ];
          };
      };
  };

  # System software
  environment.systemPackages = with pkgs; [
    vim
    git
    bash
    zsh
  ];
  environment.variables.EDITOR = "vim";
  
  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

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
  users.defaultUserShell = pkgs.bash;

  nix.settings.substituters = [ 
    "https://mirror.sjtu.edu.cn/nix-channels/store"
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://mirrors.cernet.edu.cn/nix-channels/store"
  ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
}

