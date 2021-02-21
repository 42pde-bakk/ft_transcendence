import consumer from "./consumer"

let ChatSub = null;

function manageChatChannels() {
	console.log("after setTimeout");
	let chat_div = document.getElementById("chat-target");

	if (chat_div !== null) {
		console.log("chat_div is not null");
		let chat_target_id = chat_div.getAttribute("data-chat-target-id")

		if (chat_target_id !== "0") {
			ChatSub = consumer.subscriptions.create({channel: "ChatChannel"}, {
				connected: () => { console.log("Connected to ChatChannel") },
				disconnected: () => { console.log("Disconnected from ChatChannel") },
				received: (data) => {
					// Called when there's incoming data on the websocket for this channel
					console.log(`current chat_target is ${chat_target_id}`);
					if (data !== null && chat_target_id !== "0") { // Why is it fucking receiving the message twice?!?!?
						$('chat_log').append("<br>" + data);
						console.log(`I have received "${data}" from ChatChannel`);
					}
				}
			});
		}
	} else {
			// clean up stale connections
			consumer.subscriptions.subscriptions.forEach(sub => {
				console.log("sub.identifier is " + sub.identifier);
				if (sub.identifier && sub.identifier.includes("ChatChannel"))
					console.log("removing sub");
					sub.disconnected();
					consumer.subscriptions.remove(sub);
			})
		}

}

// $(document).ready( function() {
// 	setTimeout(manageChatChannels, 250);
// })

window.addEventListener("hashchange", e => {
	setTimeout(manageChatChannels, 250);
})
