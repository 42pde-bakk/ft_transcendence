function getCookie(cname) {
    var name = cname + "=";
    var decodedCookie = decodeURIComponent(document.cookie);
    var ca = decodedCookie.split(';');
    for(var i = 0; i <ca.length; i++) {
        var c = ca[i];
        while (c.charAt(0) == ' ') {
            c = c.substring(1);
        }
        if (c.indexOf(name) == 0) {
            return c.substring(name.length, c.length);
        }
    }
    return "";
}

AppClasses.Views.ProfileTfa = class extends Backbone.View {
    constructor(opts) {
	opts.events = {
   "click .sendTfa": "sendTfa"
};
        super(opts);
        this.tagName = "div";
        this.template = App.templates["profile/tfa"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(App.models.user, "change reset add remove", this.updateRender);
    }
	sendTfa(event) {
	let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), code_tfa : $('#tfa_code').val(), new_logtoken: getCookie('tar_log_tok'), bypass_tfa: "true"};
       jQuery.post("/api/profile/changeAccount", data)
           .done(usersData => {
               console.log("It worked after tfa doude !");
               this.updateRender(); // or fetch the new data from server
                App.routers.profile.navigate("/profile", {trigger: true})
	   })
           .fail(e => {
               console.log("Error changing account");
           })
}
    updateRender() {
        this.$el.html(this.template({current_user: App.models.user.toJSON()}));
        return (this);
    }
    render() {
        return (this);
    }
}
