import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {

  const element = document.getElementById('game-id');
  const game_id = element.getAttribute('data-game-id');

  console.log("game_id = " + game_id);

  consumer.subscriptions.create({channel: "GameChannel", game_id: game_id}, {
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
      // Called when there's incoming data on the websocket for this channel
    }
  });

})