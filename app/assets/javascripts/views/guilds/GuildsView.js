AppClasses.Views.Guilds = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
            "click .clickToInviteMember": "invite",
            "click .clickToRemoveMember": "remove",
            "click .clickToAcceptInvite": "accept_invite",
            "click .clickToRejectInvite": "reject_invite",
            "click .clickToAcceptWar": "accept_war",
            "click .clickToRejectWar": "reject_war",
            "click .clickToSetOfficer": "set_officer",
            "click .clickToUnsetOfficer": "unset_officer"
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
                    if (jqXHR) {
                        console.log(jqXHR.responseText);
                        alert(jqXHR.responseJSON.alert);
                    } else {
                        alert("Error while performing action on guild");
                    }
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

    set_officer(e) {
        this.guildAction(e, "/api/guilds/set_officer.json", "officer", "Set Officer");
    }

    unset_officer(e) {
        this.guildAction(e, "/api/guilds/unset_officer.json", "officer", "Unset Officer");
    }


    updateRender() {
        this.$el.html(this.template({current_user: App.models.user.toJSON()}));
        if (App.models.user.toJSON().guild_validated === false || !App.models.user.toJSON().guild_id) {
            this.$("#Guild").append(App.templates["guilds/NoGuild"]({
                current_user: App.models.user.toJSON(),
                guild: App.models.user.toJSON().guild
            }));
        } else {
            this.$("#Guild").append(App.templates["guilds/HasGuild"]({
                current_user: App.models.user.toJSON(),
                users: App.collections.available_for_guild.toJSON(),
                all_users: App.collections.users_no_self.toJSON(),
                guild: App.models.user.toJSON().guild,
                token: $('meta[name="csrf-token"]').attr('content')}));
        }
        return (this);
    }

    render() {
        return (this);
    }
}
