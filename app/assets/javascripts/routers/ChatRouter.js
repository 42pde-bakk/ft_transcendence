AppClasses.Routers.ChatRouter = class extends AppClasses.Routers.AbstractRouter {
	constructor(options) {
		super(options);
		// routes
		this.route('chat/dm/:id', 'direct_message');
		this.route('chat/groupchat/:id', 'group_chat');
		this.route('chat', 'index');
	};

	renderViewWithParamsBitch(viewname, data, viewoptions = {}) {
		this.createView(viewname, viewoptions);
		this.mainDiv.html(this.views[viewname].render(data).el);
	}

	index() {
		this.renderView("ChatIndexView");
	}

	get_target_name(user_id) {
		let ret = "SomeUserName";
		this.collections.users_no_self.forEach( user => {
			if (user_id === user.attributes.id)
				ret = user.attributes.name;
		})
		return (ret);
	}

	get_chatchannel_name(groupchat_id) {
		let ret = "GenericChannelName";
		this.collections.groupchats.forEach ( gc => {
			if (groupchat_id === gc.attributes.id) {
				ret = gc.attributes.name;
			}
		})
		return (ret);
	}

	direct_message(user_id) {
		const data = {
			chat_type: 'dm',
			target_id: user_id,
			target_name: this.get_target_name(parseInt(user_id))
		}
		this.renderViewWithParamsBitch("ConversationView", data);
	}

	group_chat(groupchat_id) {
		const data = {
			chat_type: 'groupchat',
			target_id: groupchat_id,
			target_name: this.get_chatchannel_name(parseInt(groupchat_id))
		}
		this.renderViewWithParamsBitch("ConversationView", data);
	}

}
