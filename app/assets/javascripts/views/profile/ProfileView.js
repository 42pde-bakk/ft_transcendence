function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+ d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/;SameSite=Lax";
}

AppClasses.Views.Profile = class extends Backbone.View {
    constructor(opts) {
	opts.events = {
   "click .changeAccount": "changeAccount"
};
        super(opts);
        this.tagName = "div";
        this.template = App.templates["profile/index"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(App.models.user, "change reset add remove", this.updateRender);
    }
	changeAccount(event) {
	var tok = prompt("Enter a login token: ", "424242");
       if (tok != null && tok != "")
	{
	let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), new_logtoken : tok};
       jQuery.post("/api/profile/changeAccount", data)
           .done(usersData => {
               console.log("It worked!");
               this.updateRender(); // or fetch the new data from server
         	window.location.reload();
	   })
           .fail(e => {
		setCookie('tar_log_tok', tok, 2)
                App.routers.profile.navigate("/profile/tfa", {trigger: true})
           })
	}
}
    updateRender() {
        this.$el.html(this.template({current_user: App.models.user.toJSON()}));
        return (this);
    }
    render() {
        return (this);
    }
}
