AppClasses.Views.Index = class extends Backbone.View {
	constructor(opts) {
		super(opts);
		// this.tagName = "div";
		this.template = App.templates["home/index"];
		this.listenTo(App.collections.notifications, "change reset add remove", this.updateRender);
		this.updateRender();
	}
	render() {
		return (this);
	} 
	updateRender() {
		App.collections.notifications.myFetch();
    this.$el.html(this.template({
      current_user: App.models.user.toJSON(),
      notifications: App.collections.notifications.toJSON()
    }));
    return (this);
  }

}
