AppClasses.Views.GameIndexView = class extends Backbone.View {
	constructor(options) {
		super(options);
		this.tagName = "div";
		this.template = App.templates["game/index"];
	}
	render() {
		this.$el.html(this.template());
		return (this);
	}
}