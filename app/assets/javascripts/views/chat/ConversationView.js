AppClasses.Views.ConversationView = class extends Backbone.View {
	constructor(options) {
		console.log("in conversationview.constructor");
		options.events = {
			"click .send_dm": "send_dm",
			"click .cancel": "cancel",
			"click .block_user": "block_user",
			"click .unblock_user": "unblock_user"
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
		this.delegateEvents();
		return (this);
	}

	render(target_id, target_name) {
		this.targetUserID = target_id;
		this.targetUserName = target_name;
		this.$el.remove();
		this.updateRender();
		this.delegateEvents();
		return (this);
	}

	clearInput() {
		$("textarea").val('');
	}

	cancel() {
		this.clearInput();
		location.hash = "#chat";
	}

	send_dm(event) {
		const msg = $("textarea").val();
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: this.targetUserID,
			chat_message: msg
		};
		jQuery.post("/api/chat/send_dm", data)
			.done(usersData => {
				this.clearInput();
			})
			.fail(e => {
				alert("Could not send message to chat...");
			})
	}

	block_user(event) {
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: this.targetUserID
		};
		jQuery.post("/api/chat/block_user", data)
			.done(usersData => {
				alert(`Succesfully blocked ${this.targetUserName}`);
			})
			.fail(e => {
				alert(`Wtf dude, you can't just block ${this.targetUserName} more than once.`);
			})
	}

	unblock_user(event) {
		console.log("in ChatIndexView.unblock_user");
		const data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			other_user_id: this.targetUserID
		};
		jQuery.post("/api/chat/unblock_user", data)
			.done(usersData => {
				alert(`Succesfully unblocked ${this.targetUserName}`);
			})
			.fail(e => {
				alert(`What are you doing? You can't unblock someone you haven't blocked.`);
			})
	}
}
