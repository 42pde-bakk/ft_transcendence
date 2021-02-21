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
					// console.log(`current chat_target is ${chat_target_id}`);
					console.log(`I have received "${data}" from ChatChannel_${chat_target_id}`);
					if (data !== null) { // Why is it fucking receiving the message twice?!?!?
						$('chat_log').append("<br>" + data);
						console.log(`I have received "${data}" from ChatChannel_${chat_target_id}`);
					}
				}
			});
		}
	}
	{
		let chat_target_id = null;
		if (chat_div !== null)
			chat_target_id = chat_div.getAttribute("data-chat-target-id");
			// clean up stale connections
			consumer.subscriptions.subscriptions.forEach(sub => {
				if (sub.identifier) {
					if (chat_target_id !== null && sub.identifier.includes(`ChatChannel_${chat_target_id}`)) {
						// current chatbox connection, keep it pls
					} else if (sub.identifier.includes("ChatChannel")) {
						console.log("removing " + sub.identifier + ", chat_target_id is " + chat_target_id);
						sub.disconnected(); // afaik this is just for calling the disconnected() function above,not sure if it does something else behind the scenes
						consumer.subscriptions.remove(sub);
					}
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
