import consumer from "./consumer"

function setup_chat_connection(room_id) {
	console.log(`Entering setup_chat_connection(${room_id}}`);

	let sub = consumer.subscriptions.create({ channel: "ChatChannel", room_nb: room_id}, {
	  connected() {
	  	console.log(`I am connected to ChatChannel_${room_id}`);
	    // Called when the subscription is ready for use on the server
	  },

	  disconnected() {
		  console.log(`I have disconnected from ChatChannel_${room_id}`);
	    // Called when the subscription has been terminated by the server
	  },

	  received(data) {
		  console.log(`I have received "${data}" from ChatChannel_${room_id}`);
	    // Called when there's incoming data on the websocket for this channel
	  }
	});

}

$(document).ready(function() { setTimeout(setup_chat_connection, 250)});

export default setup_chat_connection;