AppClasses.Models.Groupchat = Backbone.Model.extend({
	urlRoot: "/api/chat",
	defaults: {
		id: 0,
		name: "GroupChat",
		setting: "private"
	}
});

AppClasses.Collections.Groupchats = class extends Backbone.Collection {
	constructor(opts) {
		super(opts);
		this.model = AppClasses.Models.Groupchat;
		this.url = '/api/chat';
	}
}
