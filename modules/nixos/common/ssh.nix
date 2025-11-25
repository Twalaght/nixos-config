{...}: {
  # Enable SSH agent to avoid repeated password prompts for key.
  programs.ssh.startAgent = true;
}
