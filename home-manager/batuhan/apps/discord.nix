# Configuring Nixcord
{
  inputs,
  pkgs,
  ...
}: {
  # Enable themeing
  # nixcord & vencord in stylix unstable
  stylix.targets = {
    nixcord.enable = true;
    vencord.enable = true;
    vesktop.enable = true;
  };

  # Enable vencord
  programs.nixcord = {
    enable = true;

    # Get vesktop without discord
    discord = {
      enable = false;
      vencord = {
        enable = true;
        package = pkgs.unstable.vencord;
        #unstable = true;
      };
      openASAR.enable = true;
    };

    vesktop = {
      enable = true;
      # package = pkgs.unstable.vesktop;
    };

    # Configuration for vencord
    config = {
      frameless = true;
      transparent = true;
      disableMinSize = true;
      plugins = {
        alwaysAnimate.enable = true;
        alwaysExpandRoles.enable = true;
        alwaysTrust.enable = true;
        anonymiseFileNames.enable = true;
        betterFolders.enable = true;
        betterGifAltText.enable = true;
        betterRoleContext.enable = true;
        betterRoleDot.enable = true;
        betterSettings.enable = true;
        betterUploadButton.enable = true;
        biggerStreamPreview.enable = true;
        blurNsfw.enable = true;
        clearUrLs.enable = true;
        consoleJanitor.enable = true;
        copyFileContents.enable = true;
        copyUserUrLs.enable = true;
        fakeNitro.enable = true;
        fixImagesQuality.enable = true;
        noTypingAnimation.enable = true;
        noUnblockToJump.enable = true;
        onePingPerDm.enable = true;
        petpet.enable = true;
        pictureInPicture.enable = true;
        readAllNotificationsButton.enable = true;
        reverseImageSearch.enable = true;
        serverInfo.enable = true;
        showHiddenChannels.enable = true;
        silentTyping.enable = true;
        usrbg.enable = true;
        vencordToolbox.enable = true;
        voiceDownload.enable = true;
        voiceMessages.enable = true;
        youtubeAdblock.enable = true;
      };
    };
  };
}
