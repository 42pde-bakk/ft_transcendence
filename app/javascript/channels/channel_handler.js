import {GameChannel} from "./game_channel"
import {ChatChannel} from "./chat_channel"
import consumer from "./consumer"

function unregister_gamechannels(room_nb) {
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

function check_game_channels(element) {
	if (element !== null) {
		console.log("check_game_channels, element is " + element);
		let game_id = element.getAttribute("data-game-id");
		unregister_gamechannels(game_id);
		if (game_id)
			GameChannel(game_id);
	}
}

function check_chat_channels(element) {
	if (element !== null) {
		let chat_id = element.getAttribute("chat-target-id");
		console.log("check_chat_channels, element is " + element + ", chat_id is " + chat_id);
		// if (chat_id)
			ChatChannel(chat_id);
	}
}

function selectchannel() {
	// GameChannel
	check_game_channels(document.getElementById("game-id"));
	check_chat_channels(document.getElementById("chat-target"));
}

function runshit() {
	console.log("in runshit");
	window.addEventListener('hashchange', e => {
		setTimeout(selectchannel, 200);
	});
}

export default runshit();
