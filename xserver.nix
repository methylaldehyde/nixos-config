{ touchpad ? "tapPad",  kbLayout ? "lv,ru", kbOptions ? "grp:caps_toggle", ... }:
{ pkgs, ... }:

let 

  mkSynaptics = x:
    if x == "tapPad" then {
      enable = true;
      minSpeed = "1.0"; 
      maxSpeed = "2.0";
      tapButtons = true;
      twoFingerScroll = true;
      horizontalScroll = true;
      palmDetect = false;
      buttonsMap = [1 3 2];
      additionalOptions = ''
        Option "SoftButtonAreas" "60% 0 72% 0 40% 59% 72% 0"
        Option "AccelerationProfile" "2"
        Option "ConstantDeceleration" "4"
      '';
    } else {
      enable = true;
      tapButtons = false;
      twoFingerScroll = true;
      horizontalScroll = true;
      palmDetect = true;
    };

  utils = [ pkgs.firefox
            pkgs.skype

            pkgs.pulseaudioFull
            pkgs.pavucontrol

            pkgs.mplayer
            pkgs.ffmpeg
            pkgs.vlc

            pkgs.rxvt_unicode_with-plugins
            pkgs.urxvt_perls

            pkgs.blender
            pkgs.inkscape
            pkgs.gimp

            pkgs.autocutsel
            pkgs.clipit

            pkgs.zathura
            pkgs.mcomix
            pkgs.fbreader
            pkgs.calibre

            pkgs.xclip
            pkgs.xlibs.xbacklight

            pkgs.wireshark-gtk
          ];

in 
{
  # Allow non-opensource stuff
  nixpkgs.config = {
    allowUnfree = true;
    firefox = {
      enableGoogleTalkPlugin = true;
      enableAdobeFlash = false;
    };
  };
  # Use pulse
  hardware.pulseaudio.enable = true;
  services.xserver = {
    enable = true;
    layout = kbLayout;
    xkbOptions = kbOptions;
    synaptics = mkSynaptics touchpad;
    displayManager.kdm.enable = true;
  };
  environment.systemPackages = builtins.concatLists [ utils ];
}
