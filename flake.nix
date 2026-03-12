{
  description = "Homelab infrastructure: Docker Compose + Ansible + OpenTofu";

  inputs = {
    nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1";
    flake-parts.url = "github:hercules-ci/flake-parts";
    mcp-servers-nix = {
      url = "github:natsukium/mcp-servers-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agent-skills-nix = {
      url = "github:Kyure-A/agent-skills-nix";
    };
    cloudflare-skills = {
      url = "github:cloudflare/skills";
      flake = false;
    };
    hashicorp-agent-skills = {
      url = "github:hashicorp/agent-skills";
      flake = false;
    };
  };

  outputs =
    { flake-parts, mcp-servers-nix, agent-skills-nix, cloudflare-skills, hashicorp-agent-skills, ... }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [ mcp-servers-nix.flakeModule ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        { config, pkgs, ... }:
        let
          agentLib = agent-skills-nix.lib.agent-skills;

          sources = {
            cloudflare = {
              path = cloudflare-skills;
            };
            hashicorp = {
              path = hashicorp-agent-skills;
            };
          };

          catalog = agentLib.discoverCatalog sources;
          allowlist = agentLib.allowlistFor {
            inherit catalog sources;
            enableAll = true;
          };
          selection = agentLib.selectSkills {
            inherit catalog allowlist sources;
            skills = { };
          };
          bundle = agentLib.mkBundle { inherit pkgs selection; };
          localTargets = {
            claude = agentLib.defaultLocalTargets.claude // { enable = true; };
          };
        in
        {
          mcp-servers = {
            settings.servers = {
              terraform = {
                command = "docker";
                args = [
                  "run"
                  "-i"
                  "--rm"
                  "hashicorp/terraform-mcp-server"
                ];
              };
              cloudflare-docs = {
                type = "http";
                url = "https://docs.mcp.cloudflare.com/mcp";
              };
            };

            flavors.claude-code.enable = true;
          };

          devShells.default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              opentofu
              ansible
              docker-compose
              tflint
            ];
            buildInputs = config.mcp-servers.packages;
            shellHook =
              config.mcp-servers.shellHook
              + agentLib.mkShellHook {
                inherit pkgs bundle;
                targets = localTargets;
              };
          };
        };
    };
}
