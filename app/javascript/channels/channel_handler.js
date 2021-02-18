import {GameChannel} from "./game_channel"
import consumer from "./consumer"


function unregister(game_id, room_nb) {
	consumer.subscriptions.subscriptions.forEach(sub => {
		console.log(`sub identifier is ${sub.identifier}`);
		if (!room_nb || room_nb !== sub.identifier["game_id"]) {
			sub.disconnected();
			consumer.subscriptions.remove(sub);
		}
	});
	consumer.subscriptions.subscriptions.forEach(sub => {
		console.log(`After removing stale subs, sub identifier is ${sub.identifier}`);
	});
}

function selectchannel() {
	// GameChannel
	const element = document.getElementById("game-id");
	let game_id = null;
	if (element != null)
		game_id = element.getAttribute("data-game-id");
	unregister(element, game_id);
	if (element) {
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
