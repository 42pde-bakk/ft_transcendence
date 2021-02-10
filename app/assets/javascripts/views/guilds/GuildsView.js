AppClasses.Views.Guilds = class extends Backbone.View {
    constructor(opts) {
        super(opts);
        this.tagName = "div";
        this.template = App.templates["guilds/index"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(this.model, "change reset add remove", this.updateRender);
    }
    updateRender() {
        this.$el.html(this.template({current_user: this.model.attributes,
                                    users: this.collection.users,
                                    guilds: this.guilds,
                                    token: $('meta[name="csrf-token"]').attr('content')}));
        const elem = $("#Guild");
        if (!this.model.guild_id) {
            elem.html(App.templates["guilds/NoGuild"]());
        } else {
            elem.html(App.templates["guilds/HasGuild"]());
        }
        return (this);
    }
    render() {
        return (this);
    }
}