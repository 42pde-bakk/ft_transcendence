AppClasses.Views.Guilds = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
            "click .clickToInviteMember": "invite",
            "click .clickToRemoveMember": "remove",
            "click .clickToAcceptInvite": "accept_invite",
            "click .clickToRejectInvite": "reject_invite",
            "click .clickToAcceptWar": "accept_war",
            "click .clickToRejectWar": "reject_war"
        };
        super(opts);
        this.tagName = "div";
        this.template = App.templates["guilds/index"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(App.models.user, "sync change reset add remove", this.updateRender);
        this.listenTo(App.collections.available_for_guild, "change reset add remove", this.updateRender);
    }

    guildAction(event, url, id, msgSuccess) {
        const userID = event.target.getElementsByClassName(id)[0].innerText;
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), id: userID};
        jQuery.post(url, data)
            .done(usersData => {
                console.log(msgSuccess);
                App.models.user.fetch();
                App.collections.available_for_guild.myFetch();
            })
            .fail(
                function(jqXHR, textStatus, errorThrown) {
                    console.log(jqXHR.responseText);
                    alert(jqXHR.responseJSON.alert);
                }
            );
    }

    remove(e) {
        this.guildAction(e, "/api/guilds/remove.json", "remove", "Quit guild");
    }

    invite(e) {
        this.guildAction(e, "/api/guilds/invite.json", "Invite", "Invited member");
    }

    accept_invite(e) {
        this.guildAction(e, "/api/guilds/accept_invite.json", "Invite", "Accepted invite");
    }

    reject_invite(e) {
        this.guildAction(e, "/api/guilds/reject_invite.json", "Invite", "Rejected invite");
    }

    accept_war(e) {
        this.guildAction(e, "/api/wars/accept_war.json", "War", "Accepted war");
    }

    reject_war(e) {
        this.guildAction(e, "/api/wars/reject_war.json", "War", "Rejected war");
    }


    updateRender() {
        this.$el.html(this.template());
        if (App.models.user.toJSON().guild_validated === false || !App.models.user.toJSON().guild_id) {
            this.$("#Guild").append(App.templates["guilds/NoGuild"]({
                current_user: App.models.user.toJSON(),
                guild: App.models.user.toJSON().guild
            }));
        } else {
            this.$("#Guild").append(App.templates["guilds/HasGuild"]({
                current_user: App.models.user.toJSON(),
                users: App.collections.available_for_guild.toJSON(),
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