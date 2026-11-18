# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.umbriel.nixosModules.default
      inputs.noctalia.nixosModules.default
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Ativa Flakes e cache binário do Noctalia para evitar compilação lenta
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://noctalia.cachix.org" ];
    trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
  };

  networking.hostName = "nixos"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

   # Permite que o Nautilus detecte volumes, rede e lixeira
  services.gvfs.enable = true;

  # Gerencia a montagem de discos e pendrives sem precisar de senha root
  services.udisks2.enable = true;
  
  
  # Ativa a virtualização necessária para o Boxes funcionar
  virtualisation.libvirtd.enable = true;

  # Dá permissão ao seu usuário para criar e rodar máquinas virtuais
  users.groups.libvirtd.members = [ "vibewill" ];
  users.groups.kvm.members = [ "vibewill" ];

  # Set your time zone.
  time.timeZone = "America/Sao_Paulo";

  # Select internationalisation properties.
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

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Display Manager e sessão padrão configurados para o Umbriel
  services.xserver.displayManager.lightdm.enable = true;
  services.displayManager.defaultSession = "umbriel";
  # services.desktopManager.pantheon.enable = true;

  # Enable Umbriel and Noctalia Shell
  programs.umbriel.enable = true;
  programs.noctalia = {
    enable = true;
    recommendedServices.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "br-abnt2";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."vibewill" = {
    isNormalUser = true;
    description = "vibewill";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Pacotes instalados no sistema (incluindo Kitty para o Umbriel)
  environment.systemPackages = with pkgs; [
    kitty
    gnome-boxes
  ];

  system.stateVersion = "26.05"; # Did you read the comment?
}
