AppClasses.Routers.FriendsRouter = class extends Backbone.Router {
	constructor(options) {
		super(options);
		// routes
		this.route("friends", "index");
        this.mainDiv = $("#app");
        this.models = App.models;
        this.views = App.views;
	}
	index() {
        if (!this.views.friends) {
            this.views.friends = new AppClasses.Views.Friends({});
        }
        this.mainDiv.html(this.views.friends.render().el);
	}
}
