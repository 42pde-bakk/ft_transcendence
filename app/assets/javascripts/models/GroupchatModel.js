AppClasses.Models.Groupchat = Backbone.Model.extend({
	urlRoot: "/api/chat",
	defaults: {
		authenticity_token: "",
		id: 0,
		name: "GroupChat",
		isprivate: false,
		password: "",
		amount_members: 0
	}
});

AppClasses.Collections.Groupchats = class extends Backbone.Collection {
	constructor(opts) {
		super(opts);
		this.model = AppClasses.Models.Groupchat;
		this.url = '/api/chat';
	}

	is_private_channel(groupchat_id) {
		let ret = false;
		this.collections.groupchats.forEach ( gc => {
			if (groupchat_id === gc.attributes.id && gc.attributes.isprivate === true) {
				ret = true;
			}
		})
		return (ret);
	}

	join_groupchat(groupchat_id) {
		let ret = true;
		let data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			chatroom_password: $(`#chatroom_${groupchat_id}_password`).val()
		};
		// if (this.is_private_channel(groupchat_id))
		// 	data["password"] = prompt("Please submit the password for this private channel");
		$.ajax({
			url: `/api/chat/${groupchat_id}.json`,
			type: 'PATCH',
			data: data,
			success: function(response) {
				//
			},
			error: function(err) {
				console.log("something went wrong in joining the groupchat");
				ret = false;
			}
		})
		return (ret);
	}

	myFetch() {
		let data = { authenticity_token: $('meta[name="csrf-token"]').attr('content') };
		jQuery.get("/api/chat.json", data)
			.done(u => {
				this.set(u);
			})
			.fail(e => {
				console.error(e);
			})
	}
}
