AppClasses.Views.ShowUser = class extends Backbone.View {
	constructor(opts) {
		super(opts);
		this.user_id = opts.user_id;
		this.tagName = "div";
		this.template = App.templates["profile/show_user"];
		this.updateRender(); // render the template only one time, unless model changed
		this.listenTo(App.collections.users_no_self, "sync change reset add remove", this.updateRender);
		this.listenTo(App.collections.games, "sync change reset add remove", this.updateRender);
		this.listenTo(App.models.user, "sync change reset add remove", this.updateRender);
	}

	find_user() {
		let ret;
		App.collections.users_no_self.forEach( user => {
			if (this.user_id === user.attributes.id)
				ret = user;
		})
		return (ret);
	}

	find_guild_name(guild_id) {
		let ret = "";
		App.collections.guilds.forEach( guild => {
			if (guild_id === guild.attributes.id)
				ret = guild.attributes.name;
		})
		return (ret);
	}

	updateRender() {
		let showing_userJSON,
				guild_name = "",
				showing_user = this.find_user();
		if (showing_user) {
			showing_userJSON = showing_user.toJSON();
			guild_name = this.find_guild_name(showing_userJSON.guild_id);
		}
		this.$el.html(this.template({
			current_user: App.models.user.toJSON(),
			showing_user: showing_userJSON,
			guild_name: guild_name,
			allGames: App.collections.games.toJSON()
		}));
		return (this);
	}

	render(user_id) {
		this.delegateEvents();
		if (this.user_id !== user_id) {
			this.user_id = user_id;
			this.updateRender();
		}
		App.collections.users_no_self.myFetch();
		return (this);
	}
}
