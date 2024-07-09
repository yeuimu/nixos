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
  i18n.defaultLocale = "en_US.UTF-8";

  # Desktop
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.libinput.enable = true;


  # System software
  environment.systemPackages = with pkgs; [
    neovim
    git
    wget
    curl
    bash
    zsh
  ];
  environment.variables.EDITOR = "nvim";
  
  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # User
  users.users.yoyoki = {
    isNormalUser = true;
    home = "/home/yoyoki";
    description = "I am what is me.";
    extraGroups = [ "wheel" "networkmanager" ];
    password = "yoyoki";
    shell = pkgs.zsh;
  };
  users.defaultUserShell = pkgs.bash;
  programs.zsh.enable = true;

  nix.settings.substituters = [ 
    "https://mirror.sjtu.edu.cn/nix-channels/store"
    "https://mirrors.ustc.edu.cn/nix-channels/store"
    "https://mirrors.cernet.edu.cn/nix-channels/store"
  ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "24.05";
}

