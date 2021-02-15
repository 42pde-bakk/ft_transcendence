import {GameChannel} from "./game_channel"

function selectchannel() {
	console.log("in selectchannel");
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
		console.log("in hashchange eventlistener");
		// console.log(`hash is ${window.location.hash}, id is ${window.location.hashIds}, hashparams is ${window.location.hashIds}`);
		// console.log(`printing hash info done`);
		setTimeout(selectchannel, 1000);
	});
}

export default runshit();
