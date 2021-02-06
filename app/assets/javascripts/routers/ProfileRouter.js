AppClasses.Routers.Profile = class extends Backbone.Router {
    constructor(options) {
        super(options);
        this.views = App.views;
        this.models = App.models;
        // routes
        this.route("profile", "profile");
        this.route("profile/edit", "edit");
        this.route("profile/editFriends", "editFriends");
        this.mainDiv = $("#app");

        if (!this.models.user) {
            this.models.user = new AppClasses.Models.User(App.data.user);
        }
        this.models.user.fetch(); // To reset the model to the db state
        if (!this.users) {
            this.users = new AppClasses.Collections.Users();
        }
        this.users.fetch();
    };

    profile() {
        if (!this.views.profile) {
            this.views.profile = new AppClasses.Views.Profile({
                model: this.models.user,
                collection: this.users
            });
        }
        this.mainDiv.html(this.views.profile.render().el);
    }

    edit() {
        this.views.profileEdit = new AppClasses.Views.ProfileEdit({
            model: this.models.user
        });
        this.mainDiv.html(this.views.profileEdit.render().el);
    }

    editFriends() {

        this.users.each(function(model, index, list)
        {
            console.log(model.name);
        });

        this.views.profileEditFriends = new AppClasses.Views.ProfileEditFriends({
            collection: this.users
        });
        this.mainDiv.html(this.views.profileEditFriends.render().el);
    }
}