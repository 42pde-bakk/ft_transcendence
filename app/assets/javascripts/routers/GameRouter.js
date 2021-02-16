AppClasses.Routers.GameRouter = class extends AppClasses.Routers.AbstractRouter {
	constructor(options) {
		super(options);
		// routes
		this.route('game/:room_id', 'play');
		this.route('game', 'index');
	};

	index() {
		this.renderView("GameIndexView");
		console.log("yes queen\n");
	}

	play(room_id) {
		room_id = Number(room_id);
		if (!Number.isInteger(room_id) || isNaN(room_id)) {
			console.log(`room_id '${room_id}' is not an integer apparently`);
			return (this.index());
		}
		console.log(`room_id = ${room_id}`);
		jQuery.post("/api/game/join", room_id)
			.done(usersData => {
				console.log("it worked!");
				this.renderViewWithParam('GamePlayView', room_id, {room_id});
				// window.location.reload();
			})
		// this.renderViewWithParam('GamePlayView', room_id, {room_id});
	}
}