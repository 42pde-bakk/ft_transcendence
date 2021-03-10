import consumer from "./consumer"
let ChatSub = null;
let last_message = null;

function receive_data(data, chat_div) {
	if (!chat_div)
		return;
	let chat_target_id = chat_div.getAttribute("data-chat-target-id");
	if (data !== null && chat_target_id !== "0") {
		// I still have a weird bug where message are being received twice, I believe it has to do with us having a SPA, not sure
		// My fix is checking whether the new message is the same as the previous one and if thats true, dont render it...
		// Fuck ft_transcendence, all my homies hate ft_transcendence
		if (last_message && JSON.stringify(data) === JSON.stringify(last_message))
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
					console.log(`ChatChannel cleanup: disconnecting ${sub.identifier}`);
					sub.disconnected();
					consumer.subscriptions.remove(sub);
				}
			})
		}
}

window.addEventListener("hashchange", e => {
	setTimeout(manageChatChannels, 250);
})

window.addEventListener('load', (event) => {
	setTimeout(manageChatChannels, 250);
})
