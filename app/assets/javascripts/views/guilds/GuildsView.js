AppClasses.Views.Guilds = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
            "click .clickToQuitGuild": "quit",
            "click .clickToAcceptMember": "accept",
            "click .clickToRejectMember": "reject"
        };
        super(opts);
        this.tagName = "div";
        this.template = App.templates["guilds/index"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(App.models.user, "sync change reset add remove", this.updateRender);
    }

    guildAction(event, url, msgSuccess) {
        const userID = event.target.getElementsByClassName("nodisplay")[0].innerText;
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), id: userID};
        jQuery.post(url, data)
            .done(usersData => {
                console.log(msgSuccess);
                App.models.user.fetch();
            })
            .fail(e => {
                console.log("Error in guild");
                alert("Error in processing request on server...");
            })
    }

    quit(e) {
        this.guildAction(e, "/api/guilds/quit.json", "Quit guild");
    }

    accept(e) {
        this.guildAction(e, "/api/guilds/accept_request.json", "Accepted request");
    }

    reject(e) {
        this.guildAction(e, "/api/guilds/reject_request.json", "Rejected request");
    }


    updateRender() {
        this.$el.html(this.template());
        if (App.models.user.toJSON().guild_validated === false) {
            this.$("#Guild").append(App.templates["guilds/NoGuild"]());
        } else {
            this.$("#Guild").append(App.templates["guilds/HasGuild"]({
                current_user: App.models.user.toJSON(),
                guild: App.models.user.toJSON().guild,
                token: $('meta[name="csrf-token"]').attr('content')}));
        }
        return (this);
    }

    render() {
        this.delegateEvents();
        return (this);
    }
}