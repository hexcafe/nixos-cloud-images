{
  description = "NixOS images for cloud providers";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ... }: {
    packages = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" ] (system: {
      aws = nixos-generators.nixosGenerate {
        inherit system;
        format = "amazon";
        modules = [ ./configurations/aws.nix ];
      };

      gcp = nixos-generators.nixosGenerate {
        inherit system;
        format = "gce";
        modules = [ ./configurations/gcp.nix ];
      };

      azure = nixos-generators.nixosGenerate {
        inherit system;
        format = "azure";
        modules = [ ./configurations/azure.nix ];
      };
    });

    # Helper for building all images
    hydraJobs = nixpkgs.lib.mapAttrs (_: pkgs: 
      nixpkgs.lib.mapAttrs (_: pkg: pkg) pkgs
    ) self.packages;
  };
}