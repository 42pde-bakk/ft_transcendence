AppClasses.Models.Guild = Backbone.Model.extend({
    urlRoot: "/api/guilds",
    defaults: {
        authenticity_token: "",
        name: "",
        anagram: ""
    }
});

AppClasses.Collections.Guilds = class extends Backbone.Collection {
    constructor(opts) {
        super(opts);
        this.model = AppClasses.Models.Guild;
        this.url = '/api/guilds';
    }

	updateOfficerStatus(guild_id, user_name, update_actiontype) {
		let data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			guild_id: guild_id,
			targetuser_name: user_name,
			update_action: update_actiontype
		};
		$.ajax({
			url: `/api/guilds/update_officer_status.json`,
			type: 'POST',
			data: data,
			success: function (response) {
				if (response["alert"])
					alert(response["alert"]);
			},
			error: function (e) {
				if (e["responseJSON"]["error"])
					alert(e["responseJSON"]["error"]);
			}
		})
	}
}

AppClasses.Models.War = Backbone.Model.extend({
    urlRoot: "/api/wars"
});
