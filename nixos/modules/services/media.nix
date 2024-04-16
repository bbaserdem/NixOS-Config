# Do sound outputs

{
  pkgs,
  lib,
  config,
  ...
}: {
  sound.enable = true;
  # Using PipeWire as the sound server conflicts with PulseAudio.
  # This option requires `hardware.pulseaudio.enable` to be set to false.
  hardware.pulseaudio.enable = false;
  # Recommended to have rtkit enabled
  security.rtkit.enable = true;
  # Main enabling script
  services.pipewire = {
    enable = true;
    audio.enable = true;
    pulse.enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    jack.enable = true;
  };
  # Enable better bluetooth, for 23.11
  environment.etc = {
	  "wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
		  bluez_monitor.properties = {
			  ["bluez5.enable-sbc-xq"] = true,
			  ["bluez5.enable-msbc"] = true,
			  ["bluez5.enable-hw-volume"] = true,
			  ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
		  }
	  '';
  };
  # For unstable; the above block is
  #services.pipewire.wireplumber.extraLuaConfig.bluetooth."51-bluez-config" = ''
	#    bluez_monitor.properties = {
	#	    ["bluez5.enable-sbc-xq"] = true,
	#	    ["bluez5.enable-msbc"] = true,
	#	    ["bluez5.enable-hw-volume"] = true,
	#	    ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
	#    }
  #  '';
}
