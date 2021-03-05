AppClasses.Views.NewGuild = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
            "submit #createGuildForm": "submit"
        }
        super(opts);
        this.tagName = "div";
        this.template = App.templates["guilds/NewGuild"];
        this.updateRender(); // render the template only one time, unless model changed
    }

    updateRender() {
        this.$el.html(this.template({
            current_user: App.models.user.toJSON(),
            guilds: App.collections.guilds.toJSON(),
            token: $('meta[name="csrf-token"]').attr('content')}));
        return (this);
    }
    render() {
        return (this);
    }
}