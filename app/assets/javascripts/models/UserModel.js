AppClasses.Models.User = Backbone.Model.extend({
    url: "api/profile/0",

	defaults: {
		name: "",
        img_path: "",
        token: "",
        guild_id: 0,
        tfa: false,
        reg_done: false,
	}
});

AppClasses.Collections.Users = Backbone.Collection.extend({
    url: "api/profile"
})