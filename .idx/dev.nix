# To learn more about how to use Nix to configure your environment
# see: https://developers.google.com/idx/guides/customize-idx-env
{ pkgs, ... }: {
  # Which nixpkgs channel to use.
  channel = "unstable"; # or "unstable"

  # Use https://search.nixos.org/packages to find packages
  packages = [
    pkgs.nodejs_22
    pkgs.pnpm
    pkgs.wasmtime
    pkgs.btop
    pkgs.docker
  ];

  # Sets environment variables in the workspace
  env = { };
  idx = {
    extensions = [
      # "vscodevim.vim"
    ];

    # Enable previews
    previews = {
      enable = true;
      previews = {
        web = {
          # Example: run "npm run dev" with PORT set to IDX's defined port for previews,
          # and show it in IDX's web preview panel
          command = [ "pnpm" "dev" ];
          manager = "web";
          env = {
            PORT = "9000";
          };
        };
      };
    };

    # Workspace lifecycle hooks
    workspace = {
      # Runs when a workspace is first created
      onCreate = {
        # Example: install JS dependencies from NPM
        corepack = "corepack up";
        npm-install = "pnpm install";
      };
      # Runs when the workspace is (re)started
      onStart = {
        prebuild-c2w = "pnpm build";
      };
    };
  };
  services = {
     docker = {
       enable = true;
     };
  };
}
