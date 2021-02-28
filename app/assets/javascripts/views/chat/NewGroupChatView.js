AppClasses.Views.NewGroupChatView = class extends Backbone.View {
	constructor(options) {
		super(options);
		options.events = {
			"submit groupchat-form": "create_groupchat"
		};
		this.tagName = "div";
		this.template = App.templates["chat/newgroupchat"];
		this.listenTo(App.models.user, "change", this.updateRender);
		this.listenTo(App.collections.users_no_self, "change reset add remove", this.updateRender);
	}

	create_groupchat(e) {
		// console.log("in create_groupchat(e)");
		alert("hey guys");
		// // e.preventDefault();
		// let groupchat = new AppClasses.Models.Groupchat();
		// let attr = {
		// 	token: $('meta[name="csrf-token"]').attr('content'),
		// 	name: $('#chatroom_name').val()
		// }
		// groupchat.save(attr, {
		// 	patch: true,
		//
		// 	error: function (groupchat, response) {
		// 		alert(`could not create groupchat, response is ${response}`);
		// 	},
		// 	success: function () {
		// 		alert("groupchat created, poggers");
		// 		App.models.user.fetch();
		// 		// App.routers.profile.navigate("/chat", { trigger: true });
		// 	}
		// })
	}

	updateRender() {
		App.models.user.fetch();
		App.collections.users_no_self.myFetch();
		this.$el.html(this.template({
			user: App.models.user.toJSON(),
			token: $('meta[name="csrf-token"]').attr('content')
		}));
		this.delegateEvents();
		return (this);
	}

	render() {
		this.updateRender();
		return (this);
	}
}
