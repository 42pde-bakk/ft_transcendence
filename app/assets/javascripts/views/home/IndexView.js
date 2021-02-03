AppClasses.Views.Index = class extends Backbone.View {
	constructor(opts) {
		super(opts);
		// this.tagName = "div";
		this.template = App.templates["home/index"];
	}
	render() {
		this.$el.html(this.template());
		return (this);
	}
}