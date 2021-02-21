import consumer from "./consumer"

let ChatSub = null;

function manageChatChannels() {
	console.log("after setTimeout");
	let chat_div = document.getElementById("chat-target");

	if (chat_div !== null) {
		let chat_target_id = chat_div.getAttribute("data-chat-target-id");
		console.log("chat_target_id is " + chat_target_id);

		if (chat_target_id !== "0") {
			ChatSub = consumer.subscriptions.create({channel: `ChatChannel_${chat_target_id}`}, {
				connected: () => {
					console.log("Connected to " + ChatSub.identifier);
				},
				disconnected: () => {
					console.log("Disconnected from " + ChatSub.identifier);
				},
				received: (data) => {
					// Called when there's incoming data on the websocket for this channel
					console.log(`current chat_target is ${chat_target_id}`);
					if (data !== null && chat_target_id !== "0") { // Why is it fucking receiving the message twice?!?!?
						if (parseInt(data["title"]) === parseInt(chat_target_id)) {
							$('chat_log').append("<br>" + data["body"]);
						}
						console.log(`I have received "${data["body"]}" from ChatChannel_${data["title"]}`);
					}
				}
			});
		}
	}
	{
			// clean up stale connections
			consumer.subscriptions.subscriptions.forEach(sub => {
				console.log("sub.identifier is " + sub.identifier);
				if (sub.identifier && sub.identifier.includes("ChatChannel")) {
					console.log("removing sub");
					sub.disconnected();
					consumer.subscriptions.remove(sub);
				}
			})
		}
}

// $(document).ready( function() {
// 	setTimeout(manageChatChannels, 250);
// })

window.addEventListener("hashchange", e => {
	setTimeout(manageChatChannels, 500);
})
