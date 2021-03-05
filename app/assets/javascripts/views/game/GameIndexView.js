AppClasses.Views.GameIndexView = class extends Backbone.View {
	constructor(options) {
		options.events = {
			"click .setup_practice_game": "setup_practice_game"
		};
		super(options);
		this.tagName = "div";
		this.template = App.templates["game/index"];
		this.listenTo(App.collections.games, "change reset add remove", this.updateRender);
	}

	setup_practice_game(e) {
		console.log("In setup_practice_game(e)");
		App.collections.games.play_against_ai();
		// App.routers.games.navigate(`/chat`, { trigger: true } );
	}

	updateRender() {
		console.log("In GameIndexView.updateRender");
		App.collections.games.myFetch();
		this.$el.html(this.template({
			token: $('meta[name="csrf-token"]').attr('content'),
			allGames: App.collections.games
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