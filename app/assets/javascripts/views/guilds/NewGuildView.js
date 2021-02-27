AppClasses.Views.NewGuild = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
            "submit #createGuildForm": "submit"
        }
        super(opts);
        this.tagName = "div";
        this.template = App.templates["guilds/NewGuild"];
        this.updateRender(); // render the template only one time, unless model changed
    }

    submit(e) {
        e.preventDefault();
        let guild = new AppClasses.Models.Guild();
        let attr = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), name: $('#guild_name').val(), anagram: $('#anagram').val()};
        guild.save(attr, {patch: true,
            error: function(guild, response){
                alert("Could not create guild");
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
            guilds: App.collections.guilds.toJSON(),
            token: $('meta[name="csrf-token"]').attr('content')}));
        return (this);
    }
    render() {
        return (this);
    }
}
