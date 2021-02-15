AppClasses.Views.ChatIndexView = class extends Backbone.View {
	constructor(options) {
		options.events = {
			"click .clickToMessage": "Message"
		};
		super(options);
		this.tagName = "div";
		this.template = App.templates["chat/index"];
	}

	Message(e) {
		e.preventDefault();
		console.log("msg, e is ", e);
		setup_chat_connection(1); // the arg is the room_id as in #chat/:room_id
		// I don't quite know yet how I wanna do it, an integer and a list of what int refers to what pair of users chatting,
		// Or maybe a concatenation of the two users name's?
		// Don't know yet how I can link setup_chat_connection from this file...

	}

	updateRender() {
		App.models.user.fetch();
		App.collections.users_no_self.myFetch();
		console.log(`all users: ${App.collections.users_no_self}`);
		this.$el.html(this.template({
			user: App.models.user.toJSON(),
			token: $('meta[name="csrf-token"]').attr('content'),
			allUsers: App.collections.users_no_self.toJSON()
		}));
		return (this);
	}

	render() {
		return this.updateRender();
	}
}