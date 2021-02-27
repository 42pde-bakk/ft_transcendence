AppClasses.Views.NewTournament = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
            "submit #createTournamentForm": "submit"
        }
        super(opts);
        this.tagName = "div";
        this.template = App.templates["tournaments/NewTournament"];
        this.updateRender(); // render the template only one time, unless model changed
    }

    submit(e) {
        e.preventDefault();
        let tournament = new AppClasses.Models.Tournament();
        let attr = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), name: $('#tournament_name').val(), started: false};
        tournament.save(attr, {patch: true,
            error: function(tournament, response){
                alert("Could not create tournament");
            },
            success: function(){
                App.models.user.fetch();
                App.collections.upcoming_tournaments.myFetch();
                App.routers.profile.navigate("/tournaments", {trigger: true})
            }
        });
    }

    updateRender() {
        this.$el.html(this.template({
            current_user: App.models.user.toJSON(),
            token: $('meta[name="csrf-token"]').attr('content')}));
        return (this);
    }
    render() {
        return (this);
    }
}
