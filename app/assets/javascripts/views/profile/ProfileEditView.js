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
    	//imugr
        var url = $('#img_path').val();
	if ($('#image').val() != "")
	{
	var fd = new FormData();
	fd.append("image", $('#image')[0].files[0]);
        var xhr = new XMLHttpRequest();
	xhr.open("POST", "https://api.imgur.com/3/image.json", false);
        xhr.extraInfo = ""
	   xhr.onload = function() {
		 this.extraInfo = (JSON.parse(xhr.responseText)).data.link;
	}
        xhr.setRequestHeader('Authorization', 'Client-ID a504f6539d73d5b');
        xhr.send(fd);
	url = xhr.extraInfo;
	}
        let attr = {name: $('#user_nickname').val(), img_path: url, image: $('#image').val()};
	    this.model.save(attr, {patch: true, error: function(){alert("Error in update")},
            success: function(){App.routers.profile.navigate("/profile", {trigger: true})}});
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
