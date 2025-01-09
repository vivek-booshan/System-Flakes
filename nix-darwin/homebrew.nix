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
		];

		taps = [
			"nikitabobko/tap" # for aerospace
		];

		# brews = [
			
		# ];

	};
}
