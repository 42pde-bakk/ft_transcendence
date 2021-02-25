AppClasses.Views.ConversationView = class extends Backbone.View {
	constructor(options) {
		console.log("in conversationview.constructor");
		options.events = {
			"click .send_dm": "send_dm",
			"click .test": "test"
		};
		super(options);
		this.tagName = "div";
		this.template = App.templates["chat/conversation"];
		this.targetUserID = 0;
		this.targetUserName = "Noone";
		this.listenTo(App.models.user, "change", this.userchange);
		this.listenTo(App.collections.users_no_self, "change reset add remove", this.noselfchange);
	}

	userchange() {
		console.log("Convo userchange");
		this.updateRender();
	}

	noselfchange() {
		console.log("Convo usernoselfchange");
		this.updateRender();
	}

	updateRender() {
		App.models.user.fetch();
		App.collections.users_no_self.myFetch();
		this.$el.remove();  // This makes function calls still work even after you try to message someone else
												// But this makes refreshing the page fail I guess...
												// Whats the fix? Don't refresh the page
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
		this.updateRender();
		return (this);
	}

	test() {
		console.log("in test");
	}

	clearInput() {
		$("textarea").val('');
	}

	send_dm(event) {
		console.log("in ChatIndexView.send_message");
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
}
