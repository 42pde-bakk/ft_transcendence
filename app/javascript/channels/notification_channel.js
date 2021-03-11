import consumer from "./consumer"

let NotificationSub;

NotificationSub = consumer.subscriptions.create("NotificationChannel", {
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
  	console.log(`I received ${JSON.stringify(data)} from the NotificationChannel`);
  	if (data["redirection"]) {
  	  console.log(`data["redirection"] = ${data["redirection"]}`);
		  App.routers.chats.navigate(`${data["redirection"]}`, { trigger: true } );
	  }
  	else
	  	App.collections.notifications.myFetch();
  }
});
