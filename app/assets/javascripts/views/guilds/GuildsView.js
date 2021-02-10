AppClasses.Views.Guilds = class extends Backbone.View {
    constructor(opts) {
        super(opts);
        this.tagName = "div";
        this.template = App.templates["guilds/index"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(this.model, "change reset add remove", this.updateRender);
    }
    updateRender() {
        this.$el.html(this.template());
        const elem = $("#Guild");
        if (!this.model.toJSON().guild) {
            elem.html(App.templates["guilds/NoGuild"]());
        } else {
            elem.html(App.templates["guilds/HasGuild"]({current_user: this.model.toJSON(),
                users: this.collection.users,
                guilds: this.guilds,
                token: $('meta[name="csrf-token"]').attr('content')}));
        }
        return (this);
    }

    render() {
        this.model.fetch();
        return (this);
    }
}