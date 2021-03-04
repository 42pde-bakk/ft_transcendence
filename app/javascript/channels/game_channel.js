import consumer from "./consumer"
let logKey;
import Render from "../rendering/render"
let KEY_SPACE = 32,
	ARROW_UP = 38,
	ARROW_DOWN = 40,
	KEY_S = 83,
	KEY_W = 87;

function removeStaleConnections() {
	consumer.subscriptions.subscriptions.forEach(sub => {
		if (sub.identifier && sub.identifier.includes("GameChannel")) {
			sub.disconnected();
			consumer.subscriptions.remove(sub);
		}
	})
}

function manageGameChannel() {
	let game_div_elem = document.getElementById("game-id");
	if (game_div_elem === null)
		return removeStaleConnections();
	let game_id = game_div_elem.getAttribute("data-game-id");
  let render = new Render(document.getElementById("PongCanvas"));
  let GameSub;

  logKey = function(e) {
		e.preventDefault();
		let keyType = "paddle_up";
		if (e.keyCode === ARROW_UP || e.keyCode === ARROW_DOWN || e.keyCode === KEY_S || e.keyCode === KEY_W) {
			if (e.keyCode === ARROW_DOWN || e.keyCode === KEY_S)
				keyType = "paddle_down";
			let data = {
				authenticity_token: $('meta[name="csrf-token"]').attr('content') ,
				type: keyType
			};
			let ret = GameSub.perform('input', data);
			console.log(`adding move returned ${ret}`);
		} else if (e.keyCode === KEY_SPACE) {
			let data = {
				authenticity_token: $('meta[name="csrf-token"]').attr('content'),
				type: "toggleReady"
			};
			let ret = GameSub.perform('input', data);
			console.log("togglingReady returned " + ret);
		}
}

  GameSub = consumer.subscriptions.create({ channel: "GameChannel", game_id: game_id}, {
		connected() {
		  console.log("Connected to " + GameSub.identifier);
		  document.addEventListener('keydown', logKey);
		  // Called when the subscription is ready for use on the server
		},

		disconnected() {
		  console.log("Disconnected from " + GameSub.identifier);
		  document.removeEventListener('keydown', logKey);
		  // Called when the subscription has been terminated by the server
		},

		received(data) {
		  // Called when there's incoming data on the websocket for this channel
		  if (data.config) {
				render.config(data.config);
		  }
		}
  });
}

window.addEventListener("hashchange", e => {
	setTimeout(manageGameChannel, 250);
})
