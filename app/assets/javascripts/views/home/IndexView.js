AppClasses.Views.Index = class extends Backbone.View {
	constructor(opts) {
		super(opts);
		// this.tagName = "div";
		this.template = App.templates["home/index"];
		this.listenTo(App.collections.notifications, "change reset remove", this.updateRender);
		this.listenTo(App.collections.notifications, "add", this.newNotification);
		this.updateRender();
	}

	render() {
		return (this);
	}

	newNotification() {
		console.log("in newNotification");
		this.$el.html(this.template({
			current_user: App.models.user.toJSON(),
			notifications: App.collections.notifications.toJSON(),
			newNotification: true
		}));
		return (this);
	}

	updateRender() {
		console.log("in home#indexview.updateRender");
		App.collections.notifications.myFetch();
    this.$el.html(this.template({
      current_user: App.models.user.toJSON(),
      notifications: App.collections.notifications.toJSON(),
	    newNotification: false
    }));
    return (this);
  }

}
