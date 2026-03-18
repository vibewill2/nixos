{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";

  # 🔑 ESSENCIAL para pendrive
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  security.polkit.enable = true;

  networking.networkmanager.enable = true;

  # Virtualização
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  virtualisation.libvirtd.enable = true;

  # Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  time.timeZone = "America/Sao_Paulo";

  programs.hyprland.enable = true;
  programs.fish.enable = true;

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

  users.users.vibewill = {
    isNormalUser = true;
    description = "vibewill";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" "kvm" "storage" ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    kitty
    rofi
    distrobox
    ncmpcpp
    lxqt.lxqt-policykit
    mpd
    appimage-run
    gnome-boxes
    polkit_gnome

    # 🔥 ESSENCIAL PRA AUTOMOUNT
    udiskie

    (python3.withPackages (ps: with ps; [
      tkinter
      pillow
    ]))
  ];

  # agente polkit
  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
  '';

  system.stateVersion = "25.11";
}
