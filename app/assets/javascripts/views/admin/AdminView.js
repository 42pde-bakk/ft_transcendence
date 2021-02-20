AppClasses.Views.Admin = class extends Backbone.View {
	constructor(opts) {
		opts.events = {
			"click .clickToBan": "banUser"
		};
		super(opts);
		this.tagName = "div";
		this.template = App.templates["admin/index"];
        this.updateRender(); // render the template only one time, unless model changed
		this.listenTo(App.models.user, "change", this.updateRender);
		this.listenTo(App.collections.users_no_self, "change reset add remove", this.updateRender);
	}
	banUser(event) {
		const userID = event.target.getElementsByClassName("nodisplay")[0].innerText;
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), id: userID};
        jQuery.post("/api/admin/ban", data)
            .done(usersData => {
                App.models.user.fetch();
                App.collections.users_no_self.myFetch();
            })
            .fail(e => {
                console.log("Error in ban");
            })
	}
	updateRender() {
		this.$el.html(this.template({
			user: App.models.user.toJSON(),
			token: $('meta[name="csrf-token"]').attr('content'),
			allUsers: App.collections.users_no_self.toJSON()
		}));
		return (this);
	}
	render() {
		this.delegateEvents();
		return (this);
	}
}
