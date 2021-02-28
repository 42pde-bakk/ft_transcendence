AppClasses.Models.Groupchat = Backbone.Model.extend({
	urlRoot: "/api/chat",
	defaults: {
		authenticity_token: "",
		id: 0,
		name: "GroupChat",
		privacy: "off"
	}
});

AppClasses.Collections.Groupchats = class extends Backbone.Collection {
	constructor(opts) {
		super(opts);
		this.model = AppClasses.Models.Groupchat;
		this.url = '/api/chat';
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
