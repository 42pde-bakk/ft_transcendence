AppClasses.Views.ChatIndexView = class extends Backbone.View {
	constructor(options) {
		// options.events = {
		// 	"click .clickToMessage": "Message"
		// };
		super(options);
		this.tagName = "div";
		this.template = App.templates["chat/index"];
	}

	updateRender() {
		App.models.user.fetch();
		App.collections.users_no_self.myFetch();
		console.log(`all users: ${App.collections.users_no_self}`);
		this.$el.html(this.template({
			user: App.models.user.toJSON(),
			token: $('meta[name="csrf-token"]').attr('content'),
			allUsers: App.collections.users_no_self.toJSON()
		}));
		return (this);
	}

	render() {
		return this.updateRender();
	}
}