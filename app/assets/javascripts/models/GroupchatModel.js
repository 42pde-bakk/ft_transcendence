AppClasses.Models.Groupchat = Backbone.Model.extend({
	urlRoot: "/api/chatroom",
	defaults: {
		authenticity_token: "",
		id: 0,
		name: "GroupChat",
		is_private: false,
		password: "",
		amount_members: 0,
		is_subscribed: false
	}
});

AppClasses.Collections.Groupchats = class extends Backbone.Collection {
	constructor(opts) {
		super(opts);
		this.model = AppClasses.Models.Groupchat;
		this.url = '/api/chatroom';
		this.myFetch();
	}

	create_groupchat() {
		let this_copy = this;
		let data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			chatroom_name: $(`#chatroom_name`).val(),
			chatroom_password: $(`#chatroom_password`).val()
		};

		$.ajax({
			url: this.url,
			type: 'POST',
			data: data,

			success: function(response) {
				console.log(`creating chatroom ${data["chatroom_name"]} was a success, response: ${JSON.stringify(response)}`);
				this_copy.myFetch();
				App.routers.chats.navigate(`/chat/groupchat/${response["id"]}`, { trigger: true } );
			},
			error: function(error) {
				console.log(`error creating groupchat`);
				alert(error["responseJSON"]["error"]);
			}
		})
	}

	leave_groupchat(groupchat_id) {
		let data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
		};

		$.ajax( {
			url: `/api/chatroom/${groupchat_id}.json`,
			type: 'DELETE',
			data: data,
			success: function(response) {
				App.routers.chats.navigate(); // Doing this because the next line wont actually trigger a refresh if the hash hasnt changed (so in my case i go from "#chat" to "#chat" )
				App.routers.chats.navigate("/chat", { trigger: true } );
			},
			error: function(error) {
				console.log("delete request failed");
				alert(error["responseJSON"]["error"]);
			}
		})
	}

	join_groupchat(groupchat_id) {
		let data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			chatroom_password: $(`#chatroom_${groupchat_id}_password`).val()
		};

		$.ajax({
			url: `/api/chatroom/${groupchat_id}.json`,
			type: 'PATCH',
			data: data,
			success: function(response) {
				App.routers.chats.navigate(`/chat/groupchat/${groupchat_id}`, { trigger: true } );
			},
			error: function(error) {
				// alert(`Wrong password.\nThis incident will be reported.`);
				alert(error["responseJSON"]["error"]);
			}
		})
		$(`#chatroom_${groupchat_id}_password`).val('');
	}

	send_dm(targetUserId) {
		const msg = $("textarea").val();
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: targetUserId,
			chat_message: msg
		};
		$.ajax({
			url: '/api/chat/send_dm',
			type: 'POST',
			data: data,
			success: function(response) {
				console.log(`send_dm#success: response is ${JSON.stringify(response)}`);
			},
			error: function(error) {
				console.log(`error is ${JSON.stringify(error)}`);
				alert(error["responseJSON"]["error"]);
			}
		})
	}

	send_groupmessage(targetId) {
		const msg = $("textarea").val();
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			chatroom_id: targetId,
			chat_message: msg
		};
		$.ajax({
			url: '/api/chat/send_groupmessage',
			type: 'POST',
			data: data,
			success: function(response) {
				console.log(`send_groupmessage#success: response is ${JSON.stringify(response)}`);
			},
			error: function(error) {
				console.log(`error is ${JSON.stringify(error)}`);
				alert(error["responseJSON"]["error"]);
			}
		})
	}

	block_user(targetUserId) {
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: targetUserId
		};
		$.ajax({
			url: '/api/chat/block_user',
			type: 'POST',
			data: data,
			success: function(response) {
				alert(response["status"]);
			},
			error: function(error) {
				alert(error["responseJSON"]["error"]);
			}
		})
	}

	unblock_user(targetUserId) {
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: targetUserId
		};
		$.ajax({
			url: '/api/chat/unblock_user',
			type: 'POST',
			data: data,
			success: function(response) {
				alert(response["status"]);
			},
			error: function(error) {
				alert(error["responseJSON"]["error"]);
			}
		})
	}

	myFetch() {
		let this_copy = this;
		let data = { authenticity_token: $('meta[name="csrf-token"]').attr('content') };

		$.ajax({
			url: '/api/chatroom.json',
			type: 'GET',
			data: data,
			success: function(response) {
				this_copy.set(response);
			},
			error: function(e) {
				console.error(e);
			}
		})
	}
}
