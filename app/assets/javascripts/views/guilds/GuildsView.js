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
            "click .clickToUnsetOfficer": "unset_officer",
            "click .clickToInviteBattle": "invite_battle",
            "click .clickToAcceptBattle": "accept_battle",
            "click .clickToRejectBattle": "reject_battle"
        };
        super(opts);
        this.tagName = "div";
        this.template = App.templates["guilds/index"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(App.models.user, "sync change reset add remove", this.updateRender);
        this.listenTo(App.collections.available_for_guild, "change reset add remove", this.updateRender);
        this.listenTo(App.collections.guilds, "change reset add remove", this.updateRender);
    }

    guildAction(event, url, id, msgSuccess) {
        const ID = event.target.getElementsByClassName(id)[0].innerText;
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), id: ID};
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

    battleAction(event, url, id, msgSuccess) {
        const opponent_id = event.target.getElementsByClassName(id)[0].innerText;

        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'),
            user1_id: App.models.user.toJSON().id,
            user2_id: opponent_id,
            time_to_accept: App.models.user.toJSON().guild.active_war.time_to_answer};
        jQuery.post(url, data)
            .done(usersData => {
                console.log(msgSuccess);
                App.models.user.fetch();
                App.collections.available_for_guild.myFetch();
            })
            .fail(
                function(jqXHR, textStatus, errorThrown) {
                    if (jqXHR) {
                        App.models.user.fetch();
                        App.collections.available_for_guild.myFetch();
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

    invite_battle(e) {
	    let battleTargetId = $(e.currentTarget).data('battleTargetId');
	    App.collections.notifications.create_notification(parseInt(battleTargetId), "wartime")
        // this.battleAction(e, "/api/battles/create.json", "battle", "Sent battle invite");
    }

    accept_battle(e) {
        this.battleAction(e, "/api/battles/accept_battle.json", "battle", "Accepted battle invite");
    }

    reject_battle(e) {
        this.battleAction(e, "/api/battles/reject_battle.json", "battle", "Rejected battle invite");
    }

    updateRender() {
        this.$el.html(this.template({current_user: App.models.user.toJSON()}));
        if (App.models.user.toJSON().guild_validated === false || !App.models.user.toJSON().guild_id) {
            this.$("#Guild").append(App.templates["guilds/NoGuild"]({
                current_user: App.models.user.toJSON(),
                guild: App.models.user.toJSON().guild,
                all_guilds: App.collections.guilds.toJSON()
            }));
        } else {
            this.$("#Guild").append(App.templates["guilds/HasGuild"]({
                current_user: App.models.user.toJSON(),
                users: App.collections.available_for_guild.toJSON(),
                all_users: App.collections.users_no_self.toJSON(),
                guild: App.models.user.toJSON().guild,
                all_guilds: App.collections.guilds.toJSON(),
                token: $('meta[name="csrf-token"]').attr('content')}));
        }
        console.log(`Current_user is ${App.models.user.toJSON().toString()}, token is ${$('meta[name="csrf-token"]').attr('content')}`)
        return (this);
    }

    render() {
        return (this);
    }
}
