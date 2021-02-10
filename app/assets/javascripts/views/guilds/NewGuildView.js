AppClasses.Views.NewGuild = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
            "submit #createGuildForm": "submit"
        }
        super(opts);
        this.tagName = "div";
        this.template = App.templates["guilds/NewGuild"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(this.model, "change reset add remove", this.updateRender);
    }

    submit(e) {
        e.preventDefault();
        let guild = new AppClasses.Models.Guild();
        let attr = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), name: $('#guild_name').val(), anagram: $('#anagram').val()};
        guild.save(attr, {patch: true,
            error: function(guild, response){
                alert(response.responseJSON.alert);
            },
            success: function(){
                App.routers.profile.navigate("/guilds", {trigger: true})
            }
        });
        // $.ajax({
        //     type: "POST",
        //     url: "/api/guilds" + "?&authenticity_token=" + $('meta[name="csrf-token"]').attr('content'),
        //     data: new FormData($("#createGuildForm")[0]),
        //     cache: false,
        //     contentType: false,
        //     processData: false
        // })
        //     .done(usersData => {
        //         console.log(msgSuccess);
        //         App.routers.profile.navigate("/guilds", {trigger: true})
        //     })
        //     .fail(function (jqXHR, textStatus, error) {
        //         alert("Post error: " + error);
        //     });
    }

    updateRender() {
        this.$el.html(this.template({current_user: this.model.attributes,
            users: this.collection.users,
            guilds: this.guilds,
            token: $('meta[name="csrf-token"]').attr('content')}));
        return (this);
    }
    render() {
        return (this);
    }
}