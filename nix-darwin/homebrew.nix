{pkgs, ...}: {
	homebrew = {
		enable = true;
		global.autoUpdate = false;

		onActivation.cleanup = "zap";
    onActivation.autoUpdate = false;
    onActivation.upgrade = false;

		casks = [
			"aerospace"
			"zen-browser"
			"spotify"
			"discord"
			"raspberry-pi-imager"
		];

		taps = [
			"nikitabobko/tap" # for aerospace
		];

		# brews = [
			
		# ];

	};
}
