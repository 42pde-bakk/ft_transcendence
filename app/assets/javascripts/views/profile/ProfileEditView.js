AppClasses.Views.ProfileEdit = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
            "submit #edit_user": "submit"
        }

        super(opts);
        this.tagName = "div";
        this.template = App.templates["profile/edit"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(this.model, "change", this.updateRender);

    }

    submit(e) {
        e.preventDefault();
        let attr = {name: $('#user_nickname').val(), level: $('#user_level').val()};
        this.model.save(attr, {patch: true, error: function(){alert("Error in update")}});
    }
    updateRender() {
        this.$el.html(this.template({
            user: this.model.attributes,
            token: $('meta[name="csrf-token"]').attr('content')
        }));
        return (this);
    }
    render() {
        return (this);
    }
}
