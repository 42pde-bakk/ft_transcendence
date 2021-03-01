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
	}

	leave_groupchat(groupchat_id) {
		let data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content')
		}

		$.ajax( {
			url: `/api/chatroom/${groupchat_id}.json`,
			type: 'DELETE',
			data: data,
			success: function(response) {
				App.routers.chats.navigate("/chat", { trigger: true } );
			},
			error: function(err) {
				console.log("delete request failed");
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
			error: function(err) {
				console.log("something went wrong in joining the groupchat");
				alert(`Wrong password.\nThis incident will be reported.`);
			}
		})
		$(`#chatroom_${groupchat_id}_pasword`).val('');
	}

	myFetch() {
		let data = { authenticity_token: $('meta[name="csrf-token"]').attr('content') };
		jQuery.get("/api/chatroom.json", data)
			.done(u => {
				this.set(u);
			})
			.fail(e => {
				console.error(e);
			})
	}
}
