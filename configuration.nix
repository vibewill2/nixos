{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  programs.steam.enable = true;
  hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  virtualisation.lxd.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  services.xserver.enable = false;
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;
  security.polkit.enable = true;
  virtualisation.docker.enable = true;

  services.displayManager.ly.enable = true;
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.flatpak.enable = true;
  xdg.portal.enable = true;

  #####programs.fish.enable = true;

 # users.users.vibewill = {
 #   isNormalUser = true;
  #  shell = pkgs.fish;
 #   extraGroups = [ "networkmanager" "wheel" ];
 #   description = "vibewill";
 #   packages = with pkgs; [];
 # };

  programs.hyprland.enable = true;
  networking.networkmanager.enable = true;

  time.timeZone = "America/Sao_Paulo";

  i18n.defaultLocale = "pt_BR.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "pt_BR.UTF-8";
    LC_IDENTIFICATION = "pt_BR.UTF-8";
    LC_MEASUREMENT = "pt_BR.UTF-8";
    LC_MONETARY = "pt_BR.UTF-8";
    LC_NAME = "pt_BR.UTF-8";
    LC_NUMERIC = "pt_BR.UTF-8";
    LC_PAPER = "pt_BR.UTF-8";
    LC_TELEPHONE = "pt_BR.UTF-8";
    LC_TIME = "pt_BR.UTF-8";
  };

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  console.keyMap = "br-abnt2";

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    waybar
    kitty
    swww
    google-chrome
    git
    vim
    vscode
    xdg-user-dirs
    waypaper
    nwg-look
    tor-browser
    nodejs
    metasploit
    vulkan-tools
    vulkan-loader
    wineWowPackages.stable
    winetricks
    cava
    cmatrix
    htop
    fastfetch
    obs-studio
    gimp
    kdePackages.kdenlive
    ly
    ruby

    # ✅ Python completo com tkinter e Pillow funcionando
    (python3.withPackages (ps: with ps; [ tkinter pillow pip pelican markdown ghp-import ]))

    go
    lua
    zola
    hugo
    gnome-boxes
    superfile
    heroic
    warp-terminal
    fuzzel
    polkit_gnome
  ];

  system.stateVersion = "25.05";
}
