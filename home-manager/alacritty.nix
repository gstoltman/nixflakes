{pkgs, ... }:
{
programs.alacritty = {
  enable = true;
  settings = {
    env.TERM = "alacritty";
    window = {
      dynamic_padding = true;
      dynamic_title = true;
      padding = {
        x=5;
        y=5;
      };
      decorations = "none";
      opacity = 0.9;
    };
    scrolling = {
      history = 10000;
      multiplier = 3;
    };
    cursor.style = {
      blinking = "On";
      shape = "Beam";
    };
    font = {
      normal = {
        family = "Iosevka Nerd Font";
	style = "Regular";
      };
    };
    colors = {
    	bright = {
	  black = "#475258";
	  blue = "#7fbbb3";
	  cyan = "#83c092";
	  green = "#a7c080";
	  magenta = "#d699b6";
	  red = "#e67e80";
	  white = "#d3c6aa";
	  yellow = "#dbbc7f";
	};
	normal = {
	  black = "#d3c6aa";
	  blue = "#7fbbb3";
	  cyan = "#83c092";
	  green = "#a7c080";
	  magenta = "#d699b6";
	  red = "#e67e80";
	  white = "#d3c6aa";
	  yellow = "#dbbc7f";
	};
	primary = {
	  background = "#272e33";
	  foreground = "#d3c6aa";
      };
    };
  };
};
}
