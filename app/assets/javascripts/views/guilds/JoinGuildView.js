AppClasses.Views.JoinGuild = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
            "click .clickToAddJoin": "join"
        }
        super(opts);
        this.tagName = "div";
        this.template = App.templates["guilds/JoinGuild"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(App.models.user, "sync change reset add remove", this.updateRender);
        this.listenTo(App.collections.guilds, "sync change reset add remove", this.updateRender);
    }

    join(event) {
        const guildID = event.target.getElementsByClassName("gId")[0].innerText;
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), id: guildID};
        let url = "/api/guilds/join.json";

        jQuery.post(url, data)
            .done(usersData => {
                console.log("Requested to join guild");
                this.updateRender();
            })
            .fail(e => {
                console.log("Error in guild join");
                alert("Could not join guild...");
            })
    }

    updateRender() {
        this.$el.html(this.template({
            guilds: App.collections.guilds.toJSON(),
            token: $('meta[name="csrf-token"]').attr('content')}));
        return (this);
    }
    render() {
        App.collections.guilds.fetch();
        return (this);
    }
}