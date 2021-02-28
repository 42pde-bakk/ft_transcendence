import consumer from "./consumer"
let ChatSub = null;
let last_message = null;

function receive_data(data, chat_div) {
	if (!chat_div)
		return;
	let chat_target_id = chat_div.getAttribute("data-chat-target-id");
	if (data !== null && chat_target_id !== "0" && last_message !== data) {
		console.log(`I have received "${data["body"]}" from ChatChannel_${data["title"]}`);
		last_message = data;
		if (data["title"].includes("dm")) {
			let res = data["title"].replace(/\D/g, '');
			if (parseInt(res) === parseInt(chat_target_id)) {
				$('chat_log').append("<br>" + data["body"]);
			}
			// console.log("after replacing non-digits, title is " + res + " and its of type " + typeof(res));
		} else if (data["title"].includes("group")) {

		}
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
