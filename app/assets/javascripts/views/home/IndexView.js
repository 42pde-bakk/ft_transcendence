AppClasses.Views.Index = class extends Backbone.View {
	constructor(opts) {
		super(opts);
		// this.tagName = "div";
		this.template = App.templates["home/index"];
		this.updateRender();
	}
	render() {
		return (this);
	} 
	updateRender() {
        this.$el.html(this.template({current_user: App.models.user.toJSON()}));
        return (this);
    }

}
