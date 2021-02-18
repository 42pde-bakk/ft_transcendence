AppClasses.Views.ChatIndexView = class extends Backbone.View {
	constructor(options) {
		options.events = {
			"click .open_msgbox": "open_msgbox",
			"click .send_message": "send_message"
		};
		super(options);
		this.tagName = "div";
		this.template = App.templates["chat/index"];
		this.targetUserID = 0;
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

	ChatAction(event, url, msgSuccess) {
		let data = { authenticity_token: App.models.user.toJSON().log_token,
			other_user_id: this.targetUserID };
		jQuery.post(url, data)
			.done(usersData => {
				console.log(msgSuccess);
				this.updateRender();
			})
			.fail(e => {
				console.log("Error ChatAction");
				alert("Could not send message to chat...");
			})
	}

	open_msgbox(event) {
		this.targetUserID = $(event.currentTarget).data('user-id');
	}

	send_message(event) {
		console.log("send_message, event is" + event);
		this.ChatAction(event,  '/api/chat/new.json', 'Chatmessage sent!');
	}
}