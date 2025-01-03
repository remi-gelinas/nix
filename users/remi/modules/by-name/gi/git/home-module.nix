{
  programs = {
    git = {
      enable = true;

      userEmail = "mail@remigelin.as";
      userName = "Remi Gelinas";

      extraConfig = {
        commit.gpgSign = true;
        tag.gpgSign = true;
        user.signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAmy0+X2k/t2PzeMAN537Tz+JNDLI3ozJpQSc9hnjb4n";
        gpg.format = "ssh";
      };
    };
  };
}
