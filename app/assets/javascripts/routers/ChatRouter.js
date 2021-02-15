AppClasses.Routers.ChatRouter = class extends AppClasses.Routers.AbstractRouter {
	constructor(options) {
		super(options);
		// routes
		this.route('chat/:chat_id', 'dm');
		this.route('chat', 'index');
	};

	index() {
		const user = this.models.user;
		const users = this.collections.users_no_self
		this.renderView("ChatIndexView");
		console.log("Chat index view\n");
	}

	dm(chat_id) {
		chat_id = Number(chat_id);
		if (!Number.isInteger(chat_id) || isNaN(chat_id)) {
			console.log(`chat_id '${chat_id}' is not an integer apparently`);
			return (this.index());
		}
		console.log(`chat_id = ${chat_id}`);
		document.getElementById("ChatBox").style.display = "block";
		// this.renderViewWithParam('ChatIndexView', chat_id, {
		// 	chatID: chat_id });
	}
}
