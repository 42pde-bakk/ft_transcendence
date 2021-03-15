AppClasses.Models.Tournament = Backbone.Model.extend({
    url: "api/tournaments",

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
//	            console.log("error in UpcomingTournaments collection.myFetch(): " + JSON.stringify(e));
  //              console.error(e);
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
//	            console.log("error in OngoingTournaments collection.myFetch(): " + JSON.stringify(e));
//	            console.error(e);
            })
    }
};
AppClasses.Collections.TournamentUsers = class extends Backbone.Collection {
    constructor(opts) {
        super(opts);
        this.myFetch();
    }
    myFetch() {
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content')};
        jQuery.post("/api/tournaments/index_tournament_users.json", data)
            .done(usersData => {
                this.set(usersData);
            })
            .fail(e => {
//	            console.log("error in TournamentUsers collection.myFetch(): " + JSON.stringify(e));
 //	            console.error(e);
            })
    }
};

AppClasses.Collections.TournamentCurrentGame = class extends Backbone.Collection {
    constructor(opts) {
        super(opts);
        this.myFetch();
    }
    myFetch() {
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content')};
        jQuery.post("/api/tournaments/index_tournament_current_game.json", data)
            .done(usersData => {
                this.set(usersData);
            })
            .fail(e => {
//	            console.log("error in TournamentCurrentGame collection.myFetch(): " + JSON.stringify(e));
  //              console.error(e);
            })
    }
};



