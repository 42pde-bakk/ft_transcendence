import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {

	const element = document.getElementById('room-id');
	const room_id = element.getAttribute('data-room-id');

	console.log("room_id = " + room_id);

	consumer.subscriptions.create({channel: "RoomChannel", room_id: room_id}, {
		connected() {
			console.log("Connected to room channel " + room_id);
			// Called when the subscription is ready for use on the server
		},

		disconnected() {
			console.log("Disconnected from room channel " + room_id);
			// Called when the subscription has been terminated by the server
		},

		received(data) {
			// Called when there's incoming data on the websocket for this channel
			console.log("Receiving data in room channel " + room_id);
			console.log(data);
		}
	});

})

