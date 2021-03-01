import consumer from "./consumer"
let ChatSub = null;
let last_message = null;

function receive_data(data, chat_div) {
	if (!chat_div)
		return;
	let chat_target_id = chat_div.getAttribute("data-chat-target-id");
	if (data !== null && chat_target_id !== "0") {
		if (last_message !== null && data["title"] === last_message["title"] && data["body"] === last_message["body"])
			return;
		last_message = data;
		// console.log(`I have received "${data["body"]}" from ChatChannel_${data["title"]} (${typeof data["title"]}) AND chat_target_id is ${chat_target_id} (${typeof chat_target_id})`);
		if (data["title"] === chat_target_id)
			$('chat_log').append("<br>" + data["body"]);
	}
}

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
			received: (data) => { // Called when there's incoming data on the websocket for this channel
				receive_data(data, document.getElementById("chat-target"));
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
