AppClasses.Models.Game = Backbone.Model.extend({
	urlRoot: "/api/game",
	defaults: {
		id: 0,
		name_player1: "Nerd",
		name_player2: "Even bigger nerd",
		gametype: "casual"
	}
});

AppClasses.Collections.Games = class extends Backbone.Collection {
	constructor(opts) {
		super(opts);
		this.model = AppClasses.Models.Game;
		this.url = "/api/game";
		this.myFetch();
	}

	myFetch() {
		let this_copy = this;
		let data = { authenticity_token: $('meta[name="csrf-token"]').attr('content') };

		$.ajax({
			url: '/api/game.json',
			type: 'GET',
			data: data,
			success: function (response) {
				if (response["alert"])
					alert(response["alert"]);
				else {
					// console.log(`GameModel.myFetch returned: ${JSON.stringify(response)}`);
					this_copy.set(response);
				}
			},
			error: function (error) {
				alert(error["responseJSON"]["error"]);
			}
		})
	}

	play_against_ai() {
		let data = { authenticity_token: $('meta[name="csrf-token"]').attr('content') };

		$.ajax({
			url: '/api/game.json',
			type: 'POST',
			data: data,
			success: function (response) {
				if (response["alert"])
					console.log(JSON.stringify(response["alert"]));
			},
			error: function (e) {
				alert(e["responseJSON"]["error"]);
			}
		})
	}
}
