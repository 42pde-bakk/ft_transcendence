AppClasses.Models.User = Backbone.Model.extend({
    urlRoot: "api/profile",

	defaults: {
		name: "",
		level: 0
	}
});