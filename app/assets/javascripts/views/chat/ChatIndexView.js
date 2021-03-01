AppClasses.Views.ChatIndexView = class extends Backbone.View {
	constructor(options) {
		options.events = {
			"submit #groupchat-form": "create_groupchat",
			"click .lets_chat": "lets_chat"
		};
		super(options);
		this.tagName = "div";
		this.template = App.templates["chat/index"];
		this.listenTo(App.models.user, "change", this.updateRender);
		this.listenTo(App.collections.users_no_self, "change reset add remove", this.updateRender);
	}

	lets_chat(e) {
		let targetId = $(e.currentTarget).data('targetid');
		if (App.collections.groupchats.join_groupchat(parseInt(targetId)) === true) {
			App.routers.chats.navigate(`/chat/groupchat/${targetId}`, { trigger: true } );
			console.log("changed hash! with trigger (chatindexview)");
		}
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
				App.routers.chats.navigate("/chat", {trigger: true});
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
