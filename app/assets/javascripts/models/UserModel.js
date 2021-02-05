AppClasses.Models.User = Backbone.Model.extend({
    urlRoot: "api/profile",

	defaults: {
		name: "",
        img_path: "",
        token: "",
        guild_id: 0,
        tfa: false,
        reg_done: false,
	image: ""
	}
});
