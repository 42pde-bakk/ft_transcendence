AppClasses.Views.TournamentPage = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
           // "submit #createTournamentForm": "submit"
        }
        super(opts);
        this.tagName = "div";
        this.template = App.templates["tournaments/TournamentPage"];
	this.listenTo(App.collections.upcoming_tournaments, "change reset add remove", this.updateRender);
	this.listenTo(App.collections.tournament_current_game, "change reset add remove", this.updateRender);
        this.updateRender(); // render the template only one time, unless model changed
    }

    updateRender() {
        this.$el.html(this.template({
            user: App.models.user.toJSON(),
	    users: App.collections.tournament_users.toJSON(),
	    current_game: App.collections.tournament_current_game.toJSON(),
            token: $('meta[name="csrf-token"]').attr('content')}));
        return (this);
    }
    render() {
        return (this);
    }
}
