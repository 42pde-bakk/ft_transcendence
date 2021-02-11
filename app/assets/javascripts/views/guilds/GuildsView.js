AppClasses.Views.Guilds = class extends Backbone.View {
    constructor(opts) {
        super(opts);
        this.tagName = "div";
        this.template = App.templates["guilds/index"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(App.models.user, "change reset add remove", this.updateRender);
    }
    updateRender() {
        this.$el.html(this.template());
        const elem = $("#Guild");
        if (!App.models.user.toJSON().guild) {
            elem.html(App.templates["guilds/NoGuild"]());
        } else {
            elem.html(App.templates["guilds/HasGuild"]({
                current_user: App.models.user.toJSON(),
                users: App.collections.users_no_self.toJSON(),
                guilds: App.collections.guilds.toJSON(),
                token: $('meta[name="csrf-token"]').attr('content')}));
        }
        return (this);
    }

    render() {
        App.models.user.fetch();
        return (this);
    }
}