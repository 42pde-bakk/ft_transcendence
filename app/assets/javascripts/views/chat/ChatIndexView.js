AppClasses.Views.ChatIndexView = class extends Backbone.View {
	constructor(options) {
		super(options);
		this.tagName = "div";
		this.template = App.templates["chat/index"];
		this.listenTo(App.models.user, "change", this.updateRender);
		this.listenTo(App.collections.users_no_self, "change reset add remove", this.updateRender);
	}

	updateRender() {
		App.models.user.fetch();
		App.collections.users_no_self.myFetch();
		this.$el.html(this.template({
			user: App.models.user.toJSON(),
			token: $('meta[name="csrf-token"]').attr('content'),
			allUsers: App.collections.users_no_self.toJSON()
		}));
		return (this);
	}

	render() {
		this.updateRender();
		return (this);
	}
}
