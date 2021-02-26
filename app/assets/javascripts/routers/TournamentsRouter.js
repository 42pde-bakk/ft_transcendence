AppClasses.Routers.TournamentsRouter = class extends Backbone.Router {
	constructor(options) {
		super(options);
		// routes
		this.route("tournaments", "index");
        this.mainDiv = $("#app");
        this.models = App.models;
        this.views = App.views;
	}
	index() {
        if (!this.views.tournaments) {
            this.views.tournaments = new AppClasses.Views.Tournaments({});
        }
        this.mainDiv.html(this.views.tournaments.render().el);
	}
}
