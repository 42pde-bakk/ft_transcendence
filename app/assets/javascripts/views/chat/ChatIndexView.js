AppClasses.Views.ChatIndexView = class extends Backbone.View {
	constructor(options) {
		options.events = {
			"submit #groupchat-form": "create_groupchat",
			"click .join_groupchat": "join_groupchat",
			"click .leave_groupchat": "leave_groupchat"
		};
		super(options);
		this.tagName = "div";
		this.template = App.templates["chat/index"];
		this.listenTo(App.models.user, "change", this.updateRender);
		this.listenTo(App.collections.users_no_self, "change reset add remove", this.updateRender);
		this.listenTo(App.collections.groupchats, "change reset add remove", this.updateRender);
	}

	leave_groupchat(e) {
		let targetId = $(e.currentTarget).data('targetid');
		App.collections.groupchats.leave_groupchat(parseInt(targetId));
		App.collections.groupchats.myFetch();
	}

	join_groupchat(e) {
		let targetId = $(e.currentTarget).data('targetid');
		App.collections.groupchats.join_groupchat(parseInt(targetId));
		App.collections.groupchats.myFetch();
	}

	create_groupchat(e) {
		e.preventDefault();
		App.collections.groupchats.create_groupchat();
		App.collections.groupchats.myFetch();
	}

	updateRender() {
		console.log("rendering chatindexview");
		App.models.user.fetch();
		App.collections.users_no_self.myFetch();
		App.collections.groupchats.myFetch();
		this.$el.html(this.template({
			user: App.models.user.toJSON(),
			token: $('meta[name="csrf-token"]').attr('content'),
			allUsers: App.collections.users_no_self.toJSON(),
			groupChats: App.collections.groupchats.toJSON()
		}));
		this.delegateEvents();
		return (this);
	}

	render() {
		this.updateRender();
		return (this);
	}
}
