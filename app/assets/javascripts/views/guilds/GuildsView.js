AppClasses.Views.Guilds = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
            "click .clickToQuitGuild": "quit",
            "click .clickToAcceptMember": "accept",
            "click .clickToRejectMember": "reject",
            "click .clickToInviteMember": "invite",
            "click .clickToAcceptInvite": "accept_invite",
            "click .clickToRejectInvite": "reject_invite"
        };
        super(opts);
        this.tagName = "div";
        this.template = App.templates["guilds/index"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(App.models.user, "sync change reset add remove", this.updateRender);
    }

    guildAction(event, url, id, msgSuccess) {
        const userID = event.target.getElementsByClassName(id)[0].innerText;
        let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), id: userID};
        jQuery.post(url, data)
            .done(usersData => {
                console.log(msgSuccess);
                App.models.user.fetch();
                App.collections.users_no_self.myFetch();
            })
            .fail(
                function(jqXHR, textStatus, errorThrown) {
                    console.log(jqXHR.responseText);
                    alert(jqXHR.responseJSON.alert);
                }
            );
    }

    quit(e) {
        this.guildAction(e, "/api/guilds/quit.json", "Leave", "Quit guild");
    }

    accept(e) {
        this.guildAction(e, "/api/guilds/accept_request.json", "Accept_req", "Accepted request");
    }

    reject(e) {
        this.guildAction(e, "/api/guilds/reject_request.json", "Reject_req", "Rejected request");
    }

    invite(e) {
        this.guildAction(e, "/api/guilds/invite.json", "Invite", "Invited member");
    }

    accept_invite(e) {
        this.guildAction(e, "/api/guilds/accept_invite.json", "Accepted invite");
    }

    reject_invite(e) {
        this.guildAction(e, "/api/guilds/reject_invite.json", "Rejected invite");
    }


    updateRender() {
        this.$el.html(this.template());
        if (App.models.user.toJSON().guild_validated === false || !App.models.user.toJSON().guild_id) {
            this.$("#Guild").append(App.templates["guilds/NoGuild"]({
                current_user: App.models.user.toJSON()
            }));
        } else {
            this.$("#Guild").append(App.templates["guilds/HasGuild"]({
                current_user: App.models.user.toJSON(),
                users: App.collections.users_no_self.toJSON(),
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