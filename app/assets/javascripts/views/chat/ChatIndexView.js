AppClasses.Views.ChatIndexView = class extends Backbone.View {
	constructor(options) {
		options.events = {
			"submit #groupchat-form": "create_groupchat"
		};
		super(options);
		this.tagName = "div";
		this.template = App.templates["chat/index"];
		this.listenTo(App.models.user, "change", this.updateRender);
		this.listenTo(App.collections.users_no_self, "change reset add remove", this.updateRender);
	}

	create_groupchat(e) {
		e.preventDefault();
		let gc = new AppClasses.Models.Groupchat();
		let attr = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			chatroom_name: $('#chatroom_name').val(),
			chatroom_password: $('#chatroom_password').val()
		};
		$('#chatroom_name').val('');
		$('#chatroom_password').val('');
		gc.save(attr, {
			patch: true,
			error: function(gc, response) {
				alert("Could not create gc");
			},
			success: function() {
				App.models.user.fetch();
				App.routers.profile.navigate("/chat", {trigger: true})
			}
		});
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
