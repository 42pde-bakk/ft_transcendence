AppClasses.Routers.Profile = class extends Backbone.Router {
    constructor(options) {
        super(options);
        this.views = App.views;
        this.models = App.models;
        // routes
        this.route("profile", "profile");
        this.mainDiv = $("#app");

        if (!this.models.user) {
            this.models.user = new AppClasses.Models.User(App.data.user);
        }
        this.models.user.fetch()
    };

    profile() {
        if (!this.views.profile) {
            this.views.profile = new AppClasses.Views.Profile({
                model: this.models.user
            });
        }
        this.mainDiv.html(this.views.profile.render().el);
    }
}