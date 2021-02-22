AppClasses.Routers.ChatRouter = class extends AppClasses.Routers.AbstractRouter {
	constructor(options) {
		super(options);
		// routes
		// this.route('chat/:chat_id', 'open_msgbox');
		this.route('chat', 'index');
	};

	index() {
		const user = this.models.user;
		const users = this.collections.users_no_self;
		console.log("in ChatRouter::index()");
		this.renderView("ChatIndexView");
	}

	open_msgbox(chat_id) {
		if (document.getElementById("ChatBox").style.display === "none")
			document.getElementById("ChatBox").style.display = "block";
	}
}
