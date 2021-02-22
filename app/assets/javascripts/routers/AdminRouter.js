AppClasses.Routers.AdminRouter = class extends Backbone.Router {
	constructor(options) {
		super(options);
		// routes
		this.route("admin", "index");
        this.mainDiv = $("#app");
        this.models = App.models;
        this.views = App.views;
	}
	index() {
        if (!this.views.admin) {
            this.views.admin = new AppClasses.Views.Admin({});
        }
        this.mainDiv.html(this.views.admin.render().el);
        this.views.admin.delegateEvents();
	}
}
