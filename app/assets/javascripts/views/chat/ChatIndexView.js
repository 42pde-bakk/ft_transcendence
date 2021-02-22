AppClasses.Views.ChatIndexView = class extends Backbone.View {
	constructor(options) {
		options.events = {
			"click .send_message": "send_message",
			"click .close_msgbox": "close_msgbox",
			"click .test" : "test"
		};
		super(options);
		this.tagName = "div";
		this.template = App.templates["chat/index"];
		this.targetUserID = 0;
		this.targetUserName = "Noone";
	}

	updateRender(target_id, target_name, chatbox_display_style) {
		App.models.user.fetch();
		App.collections.users_no_self.myFetch();
		this.$el.html(this.template({
			user: App.models.user.toJSON(),
			token: $('meta[name="csrf-token"]').attr('content'),
			allUsers: App.collections.users_no_self.toJSON(),
			target_user_id: target_id,
			target_user_name: target_name,
			chatbox_display_style: chatbox_display_style
		}));
		console.log("updating render, target_user id = " + target_id + ", and name is " + target_name);
		return (this);
	}

	render(target_id = 0, target_name = "Someone", chatbox_display_style = "none") {
		return this.updateRender(target_id, target_name, chatbox_display_style);
	}

	clearInput() {
		$("textarea").val('');
	}

	test(event) {
		console.log("FUCKS SAKE");
	}

	open_msgbox(target_id) {
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: target_id
		};
		jQuery.post("/api/chat/get_old_messages.json", data)
			.done(usersData => {
				// location.hash = `#chat/${this.targetUserID}`;
				console.log("Message history got!");
			})
			.fail(e => {
				alert("Could not load message history...");
			})
	}

	close_msgbox(event) {
		console.log("in ChatIndexView.close_msgbox");
		// document.getElementById("ChatBox").style.display = "none";
		// this.targetUserID = 0;
		// this.targetUserName = "Noone";
		this.clearInput();
		location.hash = "#chat";
		console.log("hash changed");
		// this.updateRender("none");
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
