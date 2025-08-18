{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    ./base.nix
    "${modulesPath}/virtualisation/azure-image.nix"
  ];

  # Azure-specific configuration
  virtualisation.azureImage = {
    diskSize = 8192; # 8GB
  };

  # Azure CLI tools
  environment.systemPackages = with pkgs; [
    azure-cli
    azure-storage-azcopy
  ];

  # Note: The azure-image.nix module provides:
  # - Azure Linux Agent (waagent)
  # - Cloud-init (already enabled)
  # - Hyper-V kernel modules and guest services
  # - Serial console configuration
  # - Network configuration with systemd-networkd
  # - SSH key management
  # - Root filesystem configuration

  # Azure metadata service (for reference)
  networking.extraHosts = ''
    169.254.169.254 metadata.azure.com
  '';

  # Only add Azure-specific overrides if needed
  # The module handles most Azure requirements automatically
}