AppClasses.Views.NewWar = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
            "submit #createWarForm": "submit"
        }
        super(opts);
        this.tagName = "div";
        this.template = App.templates["guilds/NewWar"];
        this.listenTo(App.models.user, "change", this.updateRender);
        this.listenTo(App.collections.guilds, "change", this.updateRender);
        this.updateRender(); // render the template only one time, unless model changed
    }

    submit(e) {
        e.preventDefault();
        let war = new AppClasses.Models.War();
        console.log($('#opponent_id').val());
        console.log($('#start_date').val());
        console.log($('#end_date').val());
        console.log($('#start_wt').val());
        console.log($('#end_wt').val());
        console.log($('#prize').val());
        console.log($('#ladder').is(':checked'));
        console.log($('#tournament').is(':checked'));
        console.log($('#duel').is(':checked'));
        // let attr = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), opponent_id: $('#opponent_id').val()};
        // war.save(attr, {patch: true,
        //     error: function(guild, response){
        //         alert("Could not create war");
        //     },
        //     success: function(){
        //         App.models.user.fetch();
        //         App.routers.profile.navigate("/guilds", {trigger: true})
        //     }
        // });
    }

    updateRender() {
        this.$el.html(this.template({
            current_user: App.models.user.toJSON(),
            users: App.collections.available_for_guild.toJSON(),
            guild: App.models.user.toJSON().guild,
            guilds_available: App.collections.guilds.toJSON(),
            token: $('meta[name="csrf-token"]').attr('content')}));
        return (this);
    }
    render() {
        return (this);
    }
}