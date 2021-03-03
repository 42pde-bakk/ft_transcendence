AppClasses.Routers.ChatRouter = class extends AppClasses.Routers.AbstractRouter {
	constructor(options) {
		super(options);
		// routes
		this.route('chat/:chat_id', 'chat_shit');
		this.route('chat', 'index');
	};

	renderViewWithParamsBitch(viewname, target_id, target_name, viewoptions = {}) { // should overwrite the base method
		console.log("target_name is " + target_name);
		this.createView(viewname, viewoptions);
		this.mainDiv.html(this.views[viewname].render(target_id, target_name).el);
	}

	index() {
		const user = this.models.user;
		const users = this.collections.users_no_self;
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

	chat_shit(chat_id) {
		this.renderViewWithParamsBitch("ConversationView", chat_id, this.get_target_name(parseInt(chat_id)));
	}
}
