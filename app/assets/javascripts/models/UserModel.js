AppClasses.Models.User = Backbone.Model.extend({
    url: "api/profile",
	defaults: {
		name: "",
		level: 0
	}
});