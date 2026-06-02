# Edit this configuration file to define what should be installed on your system. Help is available in the 
# configuration.nix(5) man page, on https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{ imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
  };
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/efi";
  };

  networking.hostName = "nixie"; # Define your hostname.

  networking.networkmanager.enable = true;

  time.timeZone = "US/Eastern";

  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    xwayland.enable = true;
    withUWSM = true;
  };

  programs.firefox.enable = true;

  # services.qemuGuest.enable = true;
  # services.spice-vdagentd.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  services.kmscon = {
    enable = true;
    config = {
      hwaccel = true;
      font-engine = "pango";
      font-size = 14;
      font-name = "FiraCode Nerd Font Mono";
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  security.sudo.wheelNeedsPassword = false;

  users.users.brian = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" ];
    packages = with pkgs; [
      tree
      claude-code
      neovim
      gcc
      unzip
      git
      stow
      tmux
      afetch
      fastfetch
    ];
    shell = pkgs.zsh;
    linger = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
    foot
    kitty
    waybar
    git
    hyprpaper
    pango
  ];

  programs.zsh.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

  system.stateVersion = "25.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

