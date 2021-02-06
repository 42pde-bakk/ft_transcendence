import consumer from "./consumer"
import Render from "../rendering/render"

export function GameChannel(game_id) {

  console.log("game_id = " + game_id);
  let render = new Render(document.getElementById("PongCanvas"));
  let sub = null;
  sub = consumer.subscriptions.create({channel: "GameChannel", game_id: game_id}, {
    connected() {
      console.log("Connected to game channel " + game_id);
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
  sub.unsubscribe();
}
