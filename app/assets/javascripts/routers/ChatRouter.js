AppClasses.Routers.ChatRouter = class extends AppClasses.Routers.AbstractRouter {
	constructor(options) {
		super(options);
		// routes
		this.route('chat/:chat_id', 'open_msgbox');
		this.route('chat', 'index');
	};

	index() {
		const user = this.models.user;
		const users = this.collections.users_no_self
		this.renderView("ChatIndexView");
		console.log("Chat index view\n");
	}

	open_msgbox(chat_id) {
		document.getElementById("ChatBox").style.display = "block";
	}
}
