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
		App.collections.games.play_against_ai();
	}

	updateRender() {
		App.collections.games.myFetch();
		this.$el.html(this.template({
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
