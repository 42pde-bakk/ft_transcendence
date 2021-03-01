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

	join_groupchat(groupchat_id) {
		let data = { authenticity_token: $('meta[name="csrf-token"]').attr('content') };
		console.log("before jquery patch");
		$.ajax({
			url: `/api/chat/${groupchat_id}.json`,
			type: 'PATCH',
			data: data,
			success: function(response) {
				//
			}
		})
		// jQuery.patch(`/api/chat/${groupchat_id}.json`, data)
		// jQuery.put(`/api/chat/${groupchat_id}.json`, data)
		// 	.done(u => {
		// 		this.set(u);
		// 	})
		// 	.fail(e => {
		// 		console.error(e);
		// 	})
	}

	myFetch() {
		let data = { authenticity_token: $('meta[name="csrf-token"]').attr('content') };
		console.log("before jquery get");
		jQuery.get("/api/chat.json", data)
			.done(u => {
				this.set(u);
			})
			.fail(e => {
				console.error(e);
			})
	}
}
