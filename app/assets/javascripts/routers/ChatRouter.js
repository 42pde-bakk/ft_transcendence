AppClasses.Routers.ChatRouter = class extends AppClasses.Routers.AbstractRouter {
	constructor(options) {
		super(options);
		// routes
		this.route('chat/:room_id', 'dm');
		this.route('chat', 'index');
	};

	index() {
		const user = this.models.user;
		const users = this.collections.users_no_self
		this.renderView("ChatIndexView");
		console.log("Chat index view\n");
	}

	dm(room_id) {
		room_id = Number(room_id);
		if (!Number.isInteger(room_id) || isNaN(room_id)) {
			console.log(`room_id '${room_id}' is not an integer apparently`);
			return (this.index());
		}
		console.log(`room_id = ${room_id}`);
		this.renderViewWithParam('ChatDirectMessageView', room_id, {
			model: this.collections.ChatRoom, user: this.model.user, chatID: room_id });
	}
}
