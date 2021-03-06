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
}

AppClasses.Models.War = Backbone.Model.extend({
    urlRoot: "/api/wars"
});
