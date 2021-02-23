AppClasses.Views.ConversationView = class extends Backbone.View {
	constructor(options) {
		options.events = {
			"click .send_message": "send_message"
		};
		super(options);
		this.tagName = "div";
		this.template = App.templates["chat/conversation"];
		this.targetUserID = 0;
		this.targetUserName = "Noone";
		this.listenTo(App.models.user, "change", this.updateRender);
		this.listenTo(App.collections.users_no_self, "change reset add remove", this.updateRender);
	}

	updateRender() {
		App.models.user.fetch();
		App.collections.users_no_self.myFetch();
		this.$el.html(this.template({
			user: App.models.user.toJSON(),
			token: $('meta[name="csrf-token"]').attr('content'),
			allUsers: App.collections.users_no_self.toJSON(),
			target_user_id: this.targetUserID,
			target_user_name: this.targetUserName,
		}));
		this.open_msgbox();
		return (this);
	}

	render(target_id, target_name) {
		this.targetUserID = target_id;
		this.targetUserName = target_name;
		this.updateRender();
		return (this);
	}

	clearInput() {
		$("textarea").val('');
	}

	open_msgbox() {
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: this.targetUserID
		};
		let elem = document.getElementById("chat-target");
		let target_id = elem.getAttribute("data-chat-target-id");
		console.log("when doing fuckiing query bs, target_id is " + target_id);

		jQuery.post("/api/chat/get_old_messages.json", data)
			.done(usersData => {
				// location.hash = `#chat/${this.targetUserID}`;
				console.log("Message history got!");
			})
			.fail(e => {
				alert("Could not load message history...");
			})
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
