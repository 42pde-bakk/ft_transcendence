import consumer from "./consumer"
import Render from "../rendering/render"
let logKey = null;
let KEY_SPACE = 32,
	ARROW_UP = 38,
	ARROW_DOWN = 40,
	KEY_S = 83,
	KEY_W = 87;

function removeStaleConnections() {
	consumer.subscriptions.subscriptions.forEach(sub => {
		console.log(`sub.identifier = ${sub.identifier}`);
	})
}

function manageGameChannel() {

	let game_div_elem = document.getElementById("game-id");
	if (game_div_elem === null)
		return
	let game_id = game_div_elem.getAttribute("data-game-id");

  console.log("GameChannel: game_id = " + game_id);
  let render = new Render(document.getElementById("PongCanvas"));
  let sub;

  let inputs_id = 0;

  logKey = function(e) {
		e.preventDefault();
		let input = null, keyType = "paddle_up";
		if (e.keyCode === ARROW_UP || e.keyCode === ARROW_DOWN || e.keyCode === KEY_S || e.keyCode === KEY_W) {
		  if (e.keyCode === ARROW_DOWN || e.keyCode === KEY_S)
			keyType = "paddle_down";
		  input = {type: keyType, id: inputs_id};
		  let ret = sub.perform('input', input);
		} else if (e.keyCode === KEY_SPACE) {
				input = { type: "toggleReady", id: inputs_id};
				let ret = sub.perform('input', input);
		}
  }

  sub = consumer.subscriptions.create({ channel: "GameChannel", game_id: game_id}, {
		connected() {
		  console.log("Connected to game channel " + game_id);
		  document.addEventListener('keydown', logKey);
		  // Called when the subscription is ready for use on the server
		},

		disconnected() {
		  console.log("Disconnected from game channel " + game_id);
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
