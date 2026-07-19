# Helper functions.
{lib, ...}: let
  fileOverridesOption = basePath:
    lib.mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          relativePath = lib.mkOption {
            type = lib.types.str;
            description = "File path relative to ${basePath}";
          };
          content = lib.mkOption {
            type = lib.types.str;
            description = "Override content for this file";
          };
          force = lib.mkOption {
            type = lib.types.bool;
            description = "Override existing files if True, throw an error otherwise";
            default = false;
          };
        };
      });
      default = [];
      description = "List of config file overrides to apply";
    };

  fileOverrideSource = basePath: fileOverrides:
    lib.cleanSourceWith {
      src = basePath;
      filter = path: type: let
        relativeOverrides = map (opt: opt.relativePath) fileOverrides;
        relativePath = lib.removePrefix "${basePath}/" (toString path);
      in
        ! builtins.elem relativePath relativeOverrides;
    };

  mkFilesWithOverrides = homeBasePath: basePath: fileOverrides:
    {
      "${homeBasePath}" = {
        source = fileOverrideSource basePath fileOverrides;
        recursive = true;
      };
    }
    // builtins.listToAttrs (map (override: {
        name = "${homeBasePath}/${override.relativePath}";
        value = {
          text = override.content;
          inherit (override) force;
        };
      })
      fileOverrides);
in {
  inherit fileOverridesOption;
  inherit fileOverrideSource;
  inherit mkFilesWithOverrides;
}
