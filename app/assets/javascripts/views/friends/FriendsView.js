AppClasses.Views.Friends = class extends Backbone.View {
	constructor(opts) {
		opts.events = {
			"click .clickToAddFriend": "addFriend",
			"click .clickToAcceptFriend": "acceptFriend",
			"click .clickToRejectFriend": "rejectFriend",
			"click .clickToDeleteFriend": "deleteFriend"
		};
		super(opts);
		this.tagName = "div";
		this.template = App.templates["friends/index"];
		this.updateRender(); // render the template only one time, unless model changed
		this.listenTo(App.models.user, "change", this.updateRender);
		this.listenTo(App.collections.users_no_self, "change reset add remove", this.updateRender);
        const seconds = 10; // update every N seconds
        setInterval(() => {
            $.ajax({
                url:  '/api/friendships/active',
                data: { "authenticity_token": $('meta[name="csrf-token"]').attr('content') },
                type: 'POST'
            });
        }, 1000 * seconds);
	}
	friendAction(event, url, msgSuccess) {
		const userID = event.target.getElementsByClassName("nodisplay")[0].innerText;
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), id: userID};
        jQuery.post(url, data)
            .done(usersData => {
                console.log(msgSuccess);
                this.updateRender();
            })
            .fail(e => {
                console.log("Error in friendship");
                alert("Could not add friend...");
            })
	}
	deleteFriend(e) {
		this.friendAction(e, "/api/friendships/destroy.json", "Friend deleted");
	}
	rejectFriend(e) {
		this.friendAction(e, "/api/friendships/reject.json", "Friend request rejected");
	}
	acceptFriend(e) {
		this.friendAction(e, "/api/friendships/accept.json", "Friend request accepted");
	}
	addFriend(e) {
		this.friendAction(e, "/api/friendships/add.json", "Request sent");
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
		this.delegateEvents();
		return (this);
	}
}
