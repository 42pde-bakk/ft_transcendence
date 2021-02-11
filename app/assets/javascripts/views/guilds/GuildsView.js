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
        if (!App.models.user.toJSON().guild) {
            this.$("#Guild").append(App.templates["guilds/NoGuild"]());
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
        return (this);
    }
}