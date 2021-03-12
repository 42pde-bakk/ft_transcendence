import consumer from "./consumer"

console.log("Running notification_channel.js");

let NotificationSub = consumer.subscriptions.create("NotificationChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
  	console.log("I subbed to the NotificationChannel");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  	console.log("I unsubbed from the NotificationChannel");
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
  	if (data["redirection"]) {
		  App.routers.chats.navigate(`${data["redirection"]}`, { trigger: true } );
	  }
  	else
	  	App.collections.notifications.myFetch();
  }
});
