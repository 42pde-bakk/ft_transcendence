AppClasses.Views.GameIndexView = class extends Backbone.View {
	constructor(options) {
		options.events = {
			"click .setup_practice_game": "setup_practice_game",
			"click .queue_ladder": "start_ladder_queue",
			"click .cancel_queue_ladder": "cancel_queue_ladder",
		};
		super(options);
		this.tagName = "div";
		this.template = App.templates["game/index"];
		this.listenTo(App.models.user, "sync change reset add remove", this.updateRender);
		this.listenTo(App.collections.games, "change reset add remove", this.updateRender);
	}

	setup_practice_game(e) {
		App.collections.games.play_against_ai();
	}

	start_ladder_queue(e) {
		App.collections.games.ladder_queue('/api/game/queue_ladder.json');
	}

	cancel_queue_ladder(e) {
		App.collections.games.ladder_queue('/api/game/cancel_queue_ladder.json');
	}

	updateRender() {
		this.$el.html(this.template({
			current_user: App.models.user.toJSON(),
			token: $('meta[name="csrf-token"]').attr('content'),
			allGames: App.collections.games.toJSON()
			}
		));
		this.delegateEvents();
		return (this);
	}

	render() {
		this.updateRender();
		return (this);
	}
}