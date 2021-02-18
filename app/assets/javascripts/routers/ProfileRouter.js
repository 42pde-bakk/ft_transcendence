AppClasses.Routers.Profile = class extends Backbone.Router {
    constructor(options) {
        super(options);
        this.views = App.views;
        this.models = App.models;
        // routes
        this.route("profile", "profile");
        this.route("profile/edit", "edit");
	this.route("profile/tfa", "tfa")
        this.mainDiv = $("#app");
    };

    profile() {
        if (!this.views.profile) {
            this.views.profile = new AppClasses.Views.Profile({});
        }
        this.mainDiv.html(this.views.profile.render().el);
    }

    edit() {
        this.views.profileEdit = new AppClasses.Views.ProfileEdit({});
        this.mainDiv.html(this.views.profileEdit.render().el);
    }
	tfa()
	{
        this.views.profileTfa = new AppClasses.Views.ProfileTfa({});
        this.mainDiv.html(this.views.profileTfa.render().el);
	}
}
