AppClasses.Routers.ChatRouter = class extends AppClasses.Routers.AbstractRouter {
	constructor(options) {
		super(options);
		// routes
		this.route('chat/:chat_id', 'chat_shit');
		this.route('chat', 'index');
	};

	renderViewWithParamsBitch(viewname, target_id, target_name, viewoptions = {}) { // should overwrite the base method
		this.createView(viewname, viewoptions);
		this.mainDiv.html(this.views[viewname].render(target_id, target_name).el);
	}

	index() {
		const user = this.models.user;
		const users = this.collections.users_no_self;
		this.renderView("ChatIndexView");
	}

	chat_shit(chat_id) {
		this.renderViewWithParamsBitch("ConversationView", chat_id, "Someone"); // "Someone" should be the name of the person you're messaging
		// this.views["ConversationView"].open_msgbox(chat_id);
	}
}
