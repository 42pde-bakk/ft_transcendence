AppClasses.Routers.GameRouter = class extends AppClasses.Routers.AbstractRouter {
	constructor(options) {
		super(options);
		// routes
		this.route('game/:room_id', 'play');
		this.route('game', 'index');
	};

	index() {
		console.log("In GameRouter.index");
		this.renderView("GameIndexView");
	}

	play(room_id) {
		console.log(`in GameRouter.play(${room_id}`);
		room_id = parseInt(room_id);
		if (!Number.isInteger(room_id) || isNaN(room_id)) {
			console.log(`room_id '${room_id}' is not an integer apparently`);
			return (this.index());
		}
		this.renderViewWithParam('GamePlayView', room_id, {room_id});
	}
}