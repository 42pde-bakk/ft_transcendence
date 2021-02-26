AppClasses.Models.Tournament = Backbone.Model.extend({
    url: "api/tournaments/1",

	defaults: {
		name: "",
	started: false,
	}
});

AppClasses.Collections.UpcomingTournaments = class extends Backbone.Collection {
    constructor(opts) {
        super(opts);
        this.myFetch();
    }
    myFetch() {
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content')};
        jQuery.post("/api/tournaments/index_upcoming_tournaments.json", data)
            .done(usersData => {
                this.set(usersData);
            })
            .fail(e => {
                console.error(e);
            })
    }
};

AppClasses.Collections.OngoingTournaments = class extends Backbone.Collection {
    constructor(opts) {
        super(opts);
        this.myFetch();
    }
    myFetch() {
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content')};
        jQuery.post("/api/tournaments/index_ongoing_tournaments.json", data)
            .done(usersData => {
                this.set(usersData);
            })
            .fail(e => {
                console.error(e);
            })
    }
};

