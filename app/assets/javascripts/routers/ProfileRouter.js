AppClasses.Routers.Profile = class extends Backbone.Router {
    constructor(options) {
        super(options);
        this.views = App.views;
        this.models = App.models;
        // routes
        this.route("profile", "profile");
        this.route("profile/:id", "show_user")
        this.route("profile/edit", "edit");
        this.route("profile/tfa", "tfa")
        this.mainDiv = $("#app");
    };

    profile() {
        if (!this.views.profile) {
            this.views.profile = new AppClasses.Views.Profile({});
        }
        this.mainDiv.html(this.views.profile.render().el);
        this.views.profile.delegateEvents();
    }

    show_user(id) {
    	let id_int = parseInt(id);
	    if (!this.views.show_user) {
		    this.views.show_user = new AppClasses.Views.ShowUser({user_id: id_int});
	    }
	    this.mainDiv.html(this.views.show_user.render(id_int).el);
    }

    edit() {
        this.views.profileEdit = new AppClasses.Views.ProfileEdit({});
        this.mainDiv.html(this.views.profileEdit.render().el);
        this.views.profileEdit.delegateEvents();
    }
	tfa()
	{
        this.views.profileTfa = new AppClasses.Views.ProfileTfa({});
        this.mainDiv.html(this.views.profileTfa.render().el);
	}
}
