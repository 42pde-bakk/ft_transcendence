AppClasses.Views.ChatIndexView = class extends Backbone.View {
	constructor(options) {
		options.events = {
			"click .open_msgbox": "open_msgbox",
			"click .close_msgbox": "close_msgbox",
			"click .send_message": "send_message"
		};
		super(options);
		this.tagName = "div";
		this.template = App.templates["chat/index"];
		this.targetUserID = 0;
		this.targetUserName = "";
	}

	updateRender() {
		App.models.user.fetch();
		App.collections.users_no_self.myFetch();
		this.$el.html(this.template({
			user: App.models.user.toJSON(),
			token: $('meta[name="csrf-token"]').attr('content'),
			allUsers: App.collections.users_no_self.toJSON(),
			target_user_id: this.targetUserID,
			target_user_name: this.targetUserName
		}));
		return (this);
	}

	render() {
		return this.updateRender();
	}

	ChatAction(event, url, msgSuccess) {
		let data = { authenticity_token: App.models.user.toJSON().log_token,
			other_user_id: this.targetUserID,
			chat_message: $("textarea").val()};

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
		this.targetUserName = $(event.currentTarget).data('user-name');
		this.updateRender();
	}

	close_msgbox(event) {
		document.getElementById("ChatBox").style.display = "none";
		this.targetUserID = 0;
		this.targetUserName = "";
		this.updateRender();
	}

	send_message(event) {
		// console.log("send_message, event is" + event);
		this.ChatAction(event,  '/api/chat/send.json', 'Chatmessage sent!');
	}
}