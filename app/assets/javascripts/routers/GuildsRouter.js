AppClasses.Routers.GuildsRouter = class extends Backbone.Router {
    constructor(options) {
        super(options);
        this.views = App.views;
        this.models = App.models;
        this.collections = App.collections;
        // routes
        this.route("guilds", "index");
        this.route("guilds/new", "new");
        this.route("guilds/join", "join");
        this.route("guilds/new_war", "new_war");
        this.mainDiv = $("#app");
    };

    index() {
        if (!this.views.guilds) {
            this.views.guilds = new AppClasses.Views.Guilds({});
        }
        this.mainDiv.html(this.views.guilds.render().el);
    }

    new() {
        if (!this.views.new) {
            this.views.new = new AppClasses.Views.NewGuild({});
        }
        this.mainDiv.html(this.views.new.render().el);
    }

    join() {
        if (!this.views.join) {
            this.views.join = new AppClasses.Views.JoinGuild({});
        }
        this.mainDiv.html(this.views.join.render().el);
    }

    new_war() {
        if (!this.views.newWar) {
            this.views.newWar = new AppClasses.Views.NewWar({});
        }
        this.mainDiv.html(this.views.newWar.render().el);
    }
}
