AppClasses.Views.EditGuild = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
            "submit #editGuildForm": "submit"
        }
        super(opts);
        this.tagName = "div";
        this.template = App.templates["guilds/EditGuild"];
        this.updateRender(); // render the template only one time, unless model changed
    }

    submit(e) {
        e.preventDefault();
        let attr = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), id: App.models.user.toJSON().guild.id, name: $('#guild_name').val(), anagram: $('#anagram').val()};
        var guild = new AppClasses.Models.Guild();
        guild.urlRoot = "/api/guilds";
        guild.save(attr, {patch: true,
            error: function(guild, response){
                if (response)
                    alert(response.responseJSON.alert);
                else
                    alert("Unknown error while saving guild");
            },
            success: function(){
                App.models.user.fetch();
                App.routers.profile.navigate("/guilds", {trigger: true})
            }
        });
    }

    updateRender() {
        this.$el.html(this.template({
            current_user: App.models.user.toJSON(),
            guild: App.models.user.toJSON().guild,
            token: $('meta[name="csrf-token"]').attr('content')}));
        return (this);
    }
    render() {
        return (this);
    }
}