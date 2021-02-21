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
		console.log("updating render, target_user id = " + this.targetUserID + ", and name is " + this.targetUserName);
		return (this);
	}

	render() {
		return this.updateRender();
	}

	clearInput() {
		$("textarea").val('');
	}

	ChatAction(event, data, url, msgSuccess) {
		jQuery.get(url, data)
			.done(usersData => {
				console.log(msgSuccess);
			})
			.fail(e => {
				alert("Could not send message to chat...");
			})
	}

	open_msgbox(event) {
		this.targetUserID = $(event.currentTarget).data('user-id');
		this.targetUserName = $(event.currentTarget).data('user-name');
		console.log(`in open_msgbox, targetID is ${this.targetUserID}, name is ${this.targetUserName}`);

		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: this.targetUserID
		};
		this.updateRender();
		location.hash = `#chat/${this.targetUserID}`;
		jQuery.post("/api/chat/get_old_messages.json'", data)
			.done(usersData => {
				console.log("Message history got!");
			})
			.fail(e => {
				alert("Could not load message history...");
			})
	}

	close_msgbox(event) {
		console.log("in ChatIndexView.close_msgbox");
		// document.getElementById("ChatBox").style.display = "none";
		this.targetUserID = 0;
		this.targetUserName = "";
		this.updateRender();
		location.hash = "#chat"
	}

	send_message(event) {
		console.log("in ChatIndexView.send_message");
		const msg = $("textarea").val();
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: this.targetUserID,
			chat_message: msg
		};
		jQuery.post("/api/chat/send_a_msg", data)
			.done(usersData => {
				this.clearInput();
			})
			.fail(e => {
				alert("Could not send message to chat...");
			})
	}
}
