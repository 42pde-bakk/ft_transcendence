AppClasses.Views.ConversationView = class extends Backbone.View {
	constructor(options) {
		options.events = {
			"click .send_dm": "send_dm",
			"click .send_groupmessage": "send_groupmessage",
			"click .cancel": "cancel",
			"click .block_user": "block_user",
			"click .unblock_user": "unblock_user",
			"click .join_groupchat": "join_groupchat",
			"click .leave_groupchat": "leave_groupchat"
		};
		super(options);
		this.tagName = "div";
		this.template = App.templates["chat/conversation"];
		this.targetUserID = 0;
		this.targetUserName = "Noone";
		this.chat_type = 'chat_type';
		this.listenTo(App.models.user, "change", this.updateRender);
		this.listenTo(App.collections.users_no_self, "change reset add remove", this.updateRender);
		this.listenTo(App.collections.groupchats, "change reset add remove", this.updateRender);
	}

	updateRender() {
		console.log(`rendering conversationView with targetid = ${this.targetUserID}`);
		App.models.user.fetch();
		App.collections.users_no_self.myFetch();
		App.collections.groupchats.myFetch();
		const is_groupchat = (this.chat_type === 'groupchat');
		this.$el.html(this.template({
			user: App.models.user.toJSON(),
			token: $('meta[name="csrf-token"]').attr('content'),
			allUsers: App.collections.users_no_self.toJSON(),
			groupChats: App.collections.groupchats.toJSON(),
			target_id: this.targetUserID,
			target_name: this.targetUserName,
			chat_type: this.chat_type,
			chattarget_type: `${this.chat_type}_${this.targetUserID}`,
			is_groupchat: is_groupchat
		}));
		this.delegateEvents();
		return (this);
	}

	render(data) {
		this.targetUserID = data["target_id"];
		this.targetUserName = data["target_name"];
		this.chat_type = data["chat_type"];
		this.$el.remove();
		this.updateRender();
		this.delegateEvents();
		return (this);
	}

	leave_groupchat(e) {
		let targetId = $(e.currentTarget).data('targetid');
		App.collections.groupchats.leave_groupchat(parseInt(targetId));
		App.collections.groupchats.myFetch();
	}

	join_groupchat(e) {
		let targetId = $(e.currentTarget).data('targetid');
		App.collections.groupchats.join_groupchat(parseInt(targetId));
		App.collections.groupchats.myFetch();
	}

	clearInput() {
		$("textarea").val('');
	}

	cancel() {
		this.clearInput();
		App.routers.chats.navigate("/chat", { trigger: true } );
	}

	send_dm(event) {
		let this_copy = this;
		const msg = $("textarea").val();
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: this.targetUserID,
			chat_message: msg
		};
		$.ajax({
			url: '/api/chat/send_dm',
			type: 'POST',
			data: data,
			success: function(response) {
				this_copy.clearInput();
			},
			error: function(error) {
				alert(error["responseJSON"]["error"]);
			}
		})
	}

	send_groupmessage(event) {
		let this_copy = this;
		const msg = $("textarea").val();
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			chatroom_id: this.targetUserID,
			chat_message: msg
		};

		$.ajax({
			url: '/api/chat/send_groupmessage',
			type: 'POST',
			data: data,
			success: function(response) {
				this_copy.clearInput();
			},
			error: function(error) {
				alert(error["responseJSON"]["error"]);
			}
		})
	}

	block_user(event) {
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: this.targetUserID
		};
		$.ajax({
			url: '/api/chat/block_user',
			type: 'POST',
			data: data,
			success: function(response) {
				alert(response["status"]);
			},
			error: function(error) {
				alert(error["responseJSON"]["error"]);
			}
		})
	}

	unblock_user(event) {
		console.log("in ChatIndexView.unblock_user");
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: this.targetUserID
		};
		$.ajax({
			url: '/api/chat/unblock_user',
			type: 'POST',
			data: data,
			success: function(response) {
				alert(response["status"]);
			},
			error: function(error) {
				alert(error["responseJSON"]["error"]);
			}
		})

	}
}
