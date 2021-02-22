AppClasses.Routers.ChatRouter = class extends AppClasses.Routers.AbstractRouter {
	constructor(options) {
		super(options);
		// routes
		this.route('chat/:chat_id', 'chat_shit');
		this.route('chat', 'index');
	};

	renderView(viewname, viewoptions = {} ) { // should overwrite the base method
		this.createView(viewname, viewoptions);
		this.mainDiv.html(this.views[viewname].render(0, "Noone", "none").el);
	}

	renderViewWithParams(viewname, viewparams, viewoptions = {}) { // should overwrite the base method
		this.createView(viewname, viewoptions);
		this.mainDiv.html(this.views[viewname].render(viewparams["target_id"], viewparams["target_name"], viewparams["chatbox_display_style"]).el);
	}

	index() {
		const user = this.models.user;
		const users = this.collections.users_no_self;
		console.log("in ChatRouter::index()");
		this.renderView("ChatIndexView");
	}

	chat_shit(chat_id) {
		console.log("in chat_shit");
		this.renderViewWithParams("ChatIndexView", { target_id: chat_id, target_name: "Someone", chatbox_display_style: "block"} );
		this.views["ChatIndexView"].open_msgbox(chat_id);
	}
}
