import consumer from "./consumer"

consumer.subscriptions.create("NotificationChannel", {
  connected() {
  	console.log("I subbed to the NotificationChannel");
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
  	console.log("I unsubbed from the NotificationChannel");
    // Called when the subscription has been terminated by the server
  },

  received(data) {
  	console.log(`I received ${JSON.stringify(data)} from the NotificationChannel`);
		document.getElementById("NotificationsButton").backgroundColor = "red";
    // Called when there's incoming data on the websocket for this channel
  }
});
