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

  # ✅ Virtualização (FIXADO)
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = false;
      swtpm.enable = true;
    };
  };

  # 🔥 módulos KVM
  boot.kernelModules = [ "kvm-intel" "kvm-amd" ];

  # Podman
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

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

  programs.niri.enable = true;
  
  programs.fish.enable = true;

  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "modesetting" ];
  services.xserver.displayManager.lightdm.enable = true;

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
  };

  console.keyMap = "br-abnt2";

  users.users.vibewill = {
    isNormalUser = true;
    description = "vibewill";
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "libvirtd" 
      "kvm" 
      "storage" 
    ];
    shell = pkgs.fish;
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    alacritty
    fuzzel
    google-chrome
    firefox
    distrobox
    ncmpcpp
    lxqt.lxqt-policykit
    mpd
    appimage-run
    gnome-boxes
    virt-manager
    qemu_kvm
    spice
    spice-gtk

    polkit_gnome
    xdg-desktop-portal-wlr
    grim

    udiskie

    (python3.withPackages (ps: with ps; [
      tkinter
      pillow
    ]))
  ];

  # agente polkit
  systemd.user.services.polkit-gnome = {
    description = "Polkit GNOME Authentication Agent";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
  };

  system.stateVersion = "25.11";
}
