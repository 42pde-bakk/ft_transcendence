AppClasses.Views.Tournaments = class extends Backbone.View {
	constructor(opts) {
		opts.events = {
			"click .clickToCreateTournament": "createTournament",
			"click .clickToRegister": "register",
			"click .clickToStartTournament": "startTournament"
		};
		super(opts);
		this.tagName = "div";
		this.template = App.templates["tournaments/index"];
        this.updateRender(); // render the template only one time, unless model changed
		this.listenTo(App.models.user, "change", this.updateRender);
		this.listenTo(App.collections.upcoming_tournaments, "change reset add remove", this.updateRender);
		this.listenTo(App.collections.ongoing_tournaments, "change reset add remove", this.updateRender);
	}
	createTournament(event) {
	//because of additional features might wanna render a new form page
	let name = prompt("Enter tournament's name:", "A tournament");
	if ( name != null && name != "")
	{
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), tournament_name: name};
        jQuery.post("/api/tournaments/createTournament", data)
            .done(usersData => {
                App.models.user.fetch();
                App.collections.upcoming_tournaments.myFetch();
            })
            .fail(e => {
                alert("Could not create tournament...");
            })
	}
	}

	startTournament(event)
	{
		
		const userID = event.target.getElementsByClassName("nodisplay")[0].innerText;
        	let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), tournament_name: name, id: userID};
                jQuery.post("/api/tournaments/startTournament", data)
            .done(usersData => {
                App.models.user.fetch();
		App.collections.upcoming_tournaments.myFetch();
                App.collections.ongoing_tournaments.myFetch();
            	updateRender();
	    })
            .fail(e => {
                alert("Could not start tournament...");
            })

	}
	updateRender() {
		this.$el.html(this.template({
			user: App.models.user.toJSON(),
			token: $('meta[name="csrf-token"]').attr('content'),
			ongoingTournaments: App.collections.ongoing_tournaments.toJSON(),
			upcomingTournaments: App.collections.upcoming_tournaments.toJSON()
		}));
		return (this);
	}
	render() {
		this.delegateEvents();
		return (this);
	}
}
