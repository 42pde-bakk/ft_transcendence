AppClasses.Routers.TournamentsRouter = class extends Backbone.Router {
	constructor(options) {
		super(options);
		// routes
		this.route("tournaments", "index");
		this.route("tournaments/new", "new");
		this.route("tournaments/page", "page");
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
	page() {
        if (!this.views.page) {
            this.views.page = new AppClasses.Views.TournamentPage({});
        }
        this.mainDiv.html(this.views.page.render().el);
        this.views.page.delegateEvents();
    }

    
	new() {
        if (!this.views.new) {
            this.views.new = new AppClasses.Views.NewTournament({});
        }
        this.mainDiv.html(this.views.new.render().el);
        this.views.new.delegateEvents();
    }


}
