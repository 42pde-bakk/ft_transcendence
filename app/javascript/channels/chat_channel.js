import consumer from "./consumer"

export function ChatChannel(room_id) {
	// console.log(`Entering setup_chat_connection`);

	let sub = consumer.subscriptions.create({ channel: "ChatChannel"}, {
	  connected() {
	  	// console.log(`I am connected to ChatChannel`);
	    // Called when the subscription is ready for use on the server
	  },

	  disconnected() {
		  // console.log(`I have disconnected from ChatChannel`);
	    // Called when the subscription has been terminated by the server
	  },

	  received(data) {
		  console.log(`I have received "${data}" from ChatChannel`);
	    // Called when there's incoming data on the websocket for this channel
	  }
	});

}

// $(document).ready(function() { setTimeout(setup_chat_connection, 250)});
