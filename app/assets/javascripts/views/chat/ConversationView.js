AppClasses.Views.ConversationView = class extends Backbone.View {
	constructor(options) {
		options.events = {
			"click .send_dm": "send_dm",
			"click .send_groupmessage": "send_groupmessage",
			"click .cancel": "cancel",
			"click .block_user": "block_user",
			"click .unblock_user": "unblock_user",
			"click .join_groupchat": "join_groupchat",
			"click .leave_groupchat": "leave_groupchat",
			"click .send_casual_duel_invite": "send_casual_duel_invite",
			"click .send_ranked_duel_invite": "send_ranked_duel_invite"
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

	get_chatchannel_name(groupchat_id) {
		let ret = "GenericChannelName";
		App.collections.groupchats.forEach ( gc => {
			if (groupchat_id === gc.attributes.id) {
				ret = gc.attributes.name;
			}
		})
		return (ret);
	}

	updateRender() {
		App.models.user.fetch();
		App.collections.users_no_self.myFetch();
		App.collections.groupchats.myFetch();
		const is_groupchat = (this.chat_type === 'groupchat');
		if (is_groupchat) {
			this.targetUserName = this.get_chatchannel_name(parseInt(this.targetUserID));
		}
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

	send_casual_duel_invite(e) {
		App.collections.notifications.create_notification(parseInt($(e.currentTarget).data('target-id')), "casual");
	}

	send_ranked_duel_invite(e) {
		App.collections.notifications.create_notification(parseInt($(e.currentTarget).data('target-id')), "duel");
	}

	cancel() {
		$("textarea").val('');
		App.routers.chats.navigate("/chat", { trigger: true } );
	}

	send_dm(event) {
		App.collections.groupchats.send_dm(this.targetUserID);
	}

	send_groupmessage(event) {
		App.collections.groupchats.send_groupmessage(this.targetUserID);
	}

	block_user(event) {
		App.collections.groupchats.block_user(this.targetUserID);
	}

	unblock_user(event) {
		App.collections.groupchats.unblock_user(this.targetUserID);
	}
}
