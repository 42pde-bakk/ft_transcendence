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

	clearInput() {
		$("textarea").val('');
	}

	ChatAction(event, url, msgSuccess) {
		let msg = $("textarea").val();
		let data = { authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: this.targetUserID,
			chat_message: msg};
		console.log("message is " + msg);

		jQuery.post("/api/chat/send_a_msg", data)
			.done(usersData => {
				console.log(msgSuccess);
				// $('chat_log').append('<div class="row msg_container base_sent"><div class="col-md-10 col-xs-10"><div class="messages msg_receive"><p>' + data + '</p></div></div></div><div class="row msg_container base_receive"><div class="col-md-10 col-xs-10"><div class="messages msg_receive"><p>'+data+'</p></div></div></div>');
				$('chat_log').append("<br>" + msg);
				this.clearInput();
				// this.updateRender();
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
