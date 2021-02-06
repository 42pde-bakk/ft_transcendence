AppClasses.Views.Profile = class extends Backbone.View {
    constructor(opts) {
        super(opts);
        this.tagName = "div";
        this.template = App.templates["profile/index"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(this.model, "change reset add remove", this.updateRender);
        this.collection.fetch().done(() => {
            this.updateRender();
        });
    }
    updateRender() {
        this.$el.html(this.template({current_user: this.model.attributes, users: this.collection.toJSON()}));
        return (this);
    }
    render() {
        return (this);
    }
}