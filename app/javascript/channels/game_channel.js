import consumer from "./consumer"
import Render from "../rendering/render"
let logKey = null;
let ARROW_UP = 38,
	ARROW_DOWN = 40,
	KEY_S = 83,
	KEY_W = 87;

export function GameChannel(game_id) {

  console.log("game_id = " + game_id);
  let render = new Render(document.getElementById("PongCanvas"));
  let sub;

  // let paddles = [null, null];
  // let ball;
  let inputs_id = 0;
  // let unverified_inputs = [];

  logKey = function(e) {
	e.preventDefault();
	let input = null,
		keyType = "paddle_up";
	if (e.keyCode === ARROW_UP || e.keyCode === ARROW_DOWN || e.keyCode === KEY_S || e.keyCode === KEY_W) {
	  if (e.keyCode === ARROW_DOWN || e.keyCode === KEY_S)
		keyType = "paddle_down";
	  console.log(`keyCode is ${e.keyCode}, keyType is ${keyType}`);
	  input = {type: keyType, id: inputs_id};
	  console.log(`input is ${input}`)
	  let ret = sub.perform('input', input);
	  // console.log('perform ret is ', ret);
	  // unverified_inputs.push(input);
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
	  console.log("Game channel " + game_id + " broadcasted: " + data);
	  if (data.config) {
		render.config(data.config);
		// render.canvas.width = data.config.canvas.width;
		// render.canvas.height = data.config.canvas.height;
		// render.resetCanvas();
	  }
	  // Called when there's incoming data on the websocket for this channel
	}
  });
  // sub.unsubscribe();
}
