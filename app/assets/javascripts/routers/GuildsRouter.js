AppClasses.Routers.GuildsRouter = class extends Backbone.Router {
    constructor(options) {
        super(options);
        this.views = App.views;
        this.models = App.models;
        this.collections = App.collections;
        // routes
        this.route("guilds", "index");
        this.route("guilds/new", "new");
        this.route("guilds/edit", "edit");
        this.mainDiv = $("#app");
    };

    index() {
        if (!this.views.guilds) {
            this.views.guilds = new AppClasses.Views.Guilds({});
        }
        this.mainDiv.html(this.views.guilds.render().el);
        this.views.guilds.delegateEvents();
    }

    new() {
        if (!this.views.new) {
            this.views.new = new AppClasses.Views.NewGuild({});
        }
        this.mainDiv.html(this.views.new.render().el);
        this.views.new.delegateEvents();
    }

    edit() {
        if (!this.views.edit) {
            this.views.edit = new AppClasses.Views.EditGuild({});
        }
        this.mainDiv.html(this.views.edit.render().el);
        this.views.edit.delegateEvents();
    }
}
