import consumer from "./consumer"
import Render from "../rendering/render"
let mykeydown, mykeyup;
let KEY_SPACE = 32,
	ARROW_UP = 38,
	ARROW_DOWN = 40,
	KEY_S = 83,
	KEY_W = 87;
let input = "none";

function removeStaleGameConnections() {
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
		return removeStaleGameConnections();
	let game_id = game_div_elem.getAttribute("data-game-id");
  let render = new Render(document.getElementById("PongCanvas"));
  let GameSub;
  let data = {
	  authenticity_token: $('meta[name="csrf-token"]').attr('content') ,
	  type: "commandstring"
  };

	mykeydown = function(e) {
  	e.preventDefault();
  	if (e.keyCode === KEY_SPACE) {
  		data["type"] = "toggleReady"
  		GameSub.perform('input', data);
	  } else if (e.keyCode === ARROW_UP || e.keyCode === KEY_W) {
		  input = "paddle_up";
	  } else if (e.keyCode === ARROW_DOWN || e.keyCode === KEY_S) {
			input = "paddle_down";
	  }
	}

	mykeyup = function(e) {
  	e.preventDefault();
  	input = "none";
	}

  GameSub = consumer.subscriptions.create({ channel: "GameChannel", game_id: game_id}, {
		connected() {
		  console.log("Connected to " + GameSub.identifier);
		  document.addEventListener('keydown', mykeydown);
		  document.addEventListener('keyup', mykeyup);
		  // Called when the subscription is ready for use on the server
		},

		disconnected() {
		  console.log("Disconnected from " + GameSub.identifier);
		  document.removeEventListener('keydown', mykeydown);
		  document.removeEventListener('keydown', mykeyup);
		  // Called when the subscription has been terminated by the server
		},

		received(data) {
		  // Called when there's incoming data on the websocket for this channel
		  if (data.config) {
				render.config(data.config);
		  }
		  if (input !== "none") {
		  	data["type"] = input;
		  	GameSub.perform('input', data);
		  }
		}
  });
}

window.addEventListener("hashchange", e => {
	setTimeout(manageGameChannel, 250);
})

window.addEventListener('load', (event) => { // for refresh (f5)
	setTimeout(manageGameChannel, 250);
})