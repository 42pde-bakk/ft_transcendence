import consumer from "./consumer"
let ChatSub = null;
let last_message = null;

function manageChatChannels() {
	let chat_div = document.getElementById("chat-target");
	if (chat_div !== null) {
		ChatSub = consumer.subscriptions.create({channel: "ChatChannel"}, {
			connected: () => {
				console.log("Connected to " + ChatSub.identifier);
			},
			disconnected: () => {
				console.log("Disconnected from " + ChatSub.identifier);
			},
			received: (data) => {
				// Called when there's incoming data on the websocket for this channel
				chat_div = document.getElementById("chat-target");
				let chat_target_id = chat_div.getAttribute("data-chat-target-id");
				if (data !== null && chat_target_id !== "0" && last_message !== data) { // Why is it fucking receiving the message twice?!?!?
					if (parseInt(data["title"]) === parseInt(chat_target_id)) {
						$('chat_log').append("<br>" + data["body"]);
						last_message = data;
					}
					console.log(`I have received "${data["body"]}" from ChatChannel_${data["title"]}`);
				}
			}
		});
	} else {
			// clean up stale connections
			consumer.subscriptions.subscriptions.forEach(sub => {
				if (sub.identifier && sub.identifier.includes("ChatChannel")) {
					sub.disconnected();
					consumer.subscriptions.remove(sub);
				}
			})
		}
}

window.addEventListener("hashchange", e => {
	setTimeout(manageChatChannels, 250);
})
