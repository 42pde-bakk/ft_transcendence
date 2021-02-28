AppClasses.Models.ChatRoom = Backbone.Model.extend( {
	defaults: {
		user1_id: null,
		user2_id: null
	}
});

AppClasses.Collections.ChatRoom = class extends Backbone.Collection {
	constructor(options) {
		super(options);
		this.model = AppClasses.Models.ChatRoom;
		this.url = '/api.direct_chats.json';
	}
}
