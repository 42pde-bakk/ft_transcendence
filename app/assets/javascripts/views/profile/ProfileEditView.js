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
       // let attr = {name: $('#user_nickname').val(), img_path: $('#img_path').val(), image: $('#image').val()};
    //imugr
        /* Lets build a FormData object*/
        var fd = new FormData(); // I wrote about it: https://hacks.mozilla.org/2011/01/how-to-develop-a-html5-image-uploader/
        fd.append("image", $('#image')[0].files[0]); // Append the file
        var xhr = new XMLHttpRequest(); // Create the XHR (Cross-Domain XHR FTW!!!) Thank you sooooo much imgur.com
        xhr.open("POST", "https://api.imgur.com/3/image.json", false); // Boooom!
        xhr.extraInfo = ""
	   xhr.onload = function() {
            // Big win!
	
		//   document.querySelector("#link").href = JSON.parse(xhr.responseText).data.link;
       		//url = (JSON.parse(chr.responseText).data.link) 
		 this.extraInfo = (JSON.parse(xhr.responseText)).data.link;
	}
        
        xhr.setRequestHeader('Authorization', 'Client-ID a504f6539d73d5b'); // Get your own key http://api.imgur.com/
        
        // Ok, I don't handle the errors. An exercise for the reader.

        /* And now, we send the formdata */
        xhr.send(fd);
//imugr	
        let attr = {name: $('#user_nickname').val(), img_path: xhr.extraInfo, image: $('#image').val()};
       // let attr = {name: $('#user_nickname').val(), img_path: $('#img_path').val(), image: $('#image').val()};
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
