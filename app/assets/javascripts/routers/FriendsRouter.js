AppClasses.Routers.FriendsRouter = class extends Backbone.Router {
	constructor(options) {
		super(options);
		// routes
		this.route("friends", "index");
        this.mainDiv = $("#app");
        this.models = App.models;
        this.views = App.views;
        if (!this.models.user) {
            this.models.user = new AppClasses.Models.User(App.data.user);
        }
        this.models.user.fetch(); // To reset the model to the db state
        if (!this.users) {
            this.users = new AppClasses.Collections.AllUsers();
        }
	}
	index() {
        if (!this.views.friends) {
            this.views.friends = new AppClasses.Views.Friends({
                model: this.models.user,
                collection: this.users
            });
        }
        this.mainDiv.html(this.views.friends.render().el);
	}
}
