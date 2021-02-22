AppClasses.Routers.AbstractRouter = class extends Backbone.Router {
	constructor (options) {
		super(options);
		this.collections = App.collections;
		this.models = App.models;
		this.views = App.views;
		this.mainDiv = $("#app");
	}

	createView(viewname, viewoptions) {
		if (this.views[viewname] == null)
			this.views[viewname] = new AppClasses.Views[viewname](viewoptions);
	}

	renderView(viewname, viewoptions = {} ) {
		this.createView(viewname, viewoptions);
		this.mainDiv.html(this.views[viewname].render().el);
	}

	// renderViewWithParam(viewname, viewparam, viewoptions = {}) {
	// 	this.createView(viewname, viewoptions);
	// 	this.mainDiv.html(this.views[viewname].render(viewparam).el);
	// }
}
