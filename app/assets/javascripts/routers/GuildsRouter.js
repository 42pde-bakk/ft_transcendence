AppClasses.Routers.GuildsRouter = class extends Backbone.Router {
    constructor(options) {
        super(options);
        this.views = App.views;
        this.models = App.models;
        this.collections = App.collections;
        // routes
        this.route("guilds", "index");
        this.route("guilds/new", "new");
        // this.route("guilds/join", "join");
        this.mainDiv = $("#app");

        if (!this.models.user) {
            this.models.user = new AppClasses.Models.User(App.data.user);
        }
        this.models.user.fetch(); // To reset the model to the db state
        if (!this.collections.users) {
            this.collections.users = new AppClasses.Collections.AllUsers();
        }
        this.collections.users.myFetch(); // To reset the model to the db state
        if (!this.collections.guilds) {
            this.collections.guilds = new AppClasses.Collections.Guilds();
        }
        this.collections.guilds.fetch(); // To reset the model to the db state
    };

    index() {
        if (!this.views.guilds) {
            this.views.guilds = new AppClasses.Views.Guilds({
                model: this.models.user,
                collection: this.collections.users,
                guilds: this.collections.guilds
            });
        }
        this.mainDiv.html(this.views.guilds.render().el);
    }

    new() {
        if (!this.views.new) {
            this.views.new = new AppClasses.Views.NewGuild({
                model: this.models.user,
                collection: this.collections.users,
                guilds: this.collections.guilds
            });
        }
        this.mainDiv.html(this.views.new.render().el);
    }

    // join() {
    //     if (!this.views.guilds) {
    //         this.views.guilds = new AppClasses.Views.Guilds({
    //             model: this.models.user,
    //             collection: this.collections.users,
    //             guilds: this.collections.guilds
    //         });
    //     }
    //     this.mainDiv.html(this.views.guilds.render().el);
    // }
}
