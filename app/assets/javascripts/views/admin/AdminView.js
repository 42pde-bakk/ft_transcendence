AppClasses.Views.Admin = class extends Backbone.View {
	constructor(opts) {
		opts.events = {
			"submit #createTournamentForm": "submit",
			"click .clickToBan": "banUser",
			"click .clickToAddAdmin": "addAdmin",
			"click .clickToRemoveAdmin": "removeAdmin"
		};
		super(opts);
		this.tagName = "div";
		this.template = App.templates["admin/index"];
        this.updateRender(); // render the template only one time, unless model changed
		this.listenTo(App.models.user, "change", this.updateRender);
		this.listenTo(App.collections.users_not_banned, "change reset add remove", this.updateRender);
		this.listenTo(App.collections.users_not_admin, "change reset add remove", this.updateRender);
		this.listenTo(App.collections.users_admin_only, "change reset add remove", this.updateRender);
	}
	submit(e) {
        e.preventDefault();
        let tournament = new AppClasses.Models.Tournament();
        let attr = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), name: $('#tournament_name').val(),
		started: false,
	long_paddle: document.querySelector('.long_paddle_checkbox').checked,
	extra_speed: document.querySelector('.extra_speed_checkbox').checked};
        tournament.save(attr, {patch: true,
            error: function(tournament, response){
                alert("Could not create tournament");
            },
            success: function(){
                App.models.user.fetch();
                App.collections.upcoming_tournaments.myFetch();
                App.routers.profile.navigate("/tournaments", {trigger: true})
            }
        });
    }
	banUser(event) {
		const userID = event.target.getElementsByClassName("nodisplay")[0].innerText;
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), id: userID};
        jQuery.post("/api/admin/ban", data)
            .done(usersData => {
                App.models.user.fetch();
                App.collections.users_not_banned.myFetch();
            })
            .fail(e => {
                console.log("Error in ban");
            })
	}
	addAdmin(event)
	{
		const userID = event.target.getElementsByClassName("nodisplay")[0].innerText;
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), id: userID};
        jQuery.post("/api/admin/getAdmin", data)
            .done(usersData => {
                App.models.user.fetch();
                App.collections.users_not_admin.myFetch();
                App.collections.users_admin_only.myFetch();
            })
            .fail(e => {
                console.log("Error in addAdmin");
            })

	}
	removeAdmin(event)
	{
		const userID = event.target.getElementsByClassName("nodisplay")[0].innerText;
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), id: userID};
        jQuery.post("/api/admin/removeAdmin", data)
            .done(usersData => {
                App.models.user.fetch();
                App.collections.users_not_admin.myFetch();
                App.collections.users_admin_only.myFetch();
            })
            .fail(e => {
                console.log("Error in removeAdmin");
            })

	}

	updateRender() {
		this.$el.html(this.template({
			user: App.models.user.toJSON(),
			token: $('meta[name="csrf-token"]').attr('content'),
			allUsers: App.collections.users_not_banned.toJSON(),
			allAdmins: App.collections.users_admin_only.toJSON(),
			allNotAdmins: App.collections.users_not_admin.toJSON()
		}));
		return (this);
	}
	render() {
		this.delegateEvents();
		return (this);
	}
}
