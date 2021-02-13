AppClasses.Routers.Main = class extends Backbone.Router {
	constructor(options) {
		super(options);
		this.views = App.views;
		this.models = App.models;
		// routes
		this.route("", "index");

		this.mainDiv = $("#app");
	}
	index() {
		if (!this.views.index) {
			this.views.index = new AppClasses.Views.Index();
		}
		this.mainDiv.html(this.views.index.render().el);
	}
}