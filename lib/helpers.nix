# Helper functions.
{lib, ...}: {
  # Add a list of groups to a list of users, creating each group if required.
  generateUserGroups = users: groups: {
    users = lib.genAttrs users (username: {
      extraGroups = groups;
    });
    groups = lib.genAttrs groups (group: lib.mkDefault {});
  };
}
