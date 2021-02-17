import {GameChannel} from "./game_channel"

function selectchannel() {
	// GameChannel
	const element = document.getElementById("game-id");
	if (element) {
		const game_id = element.getAttribute("data-game-id");
		if (game_id)
			GameChannel(game_id);
	}
}

function runshit() {
	console.log("in runshit");
	window.addEventListener('hashchange', e => {
		setTimeout(selectchannel, 200);
	});
}

export default runshit();
