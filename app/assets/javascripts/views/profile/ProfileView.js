function setCookie(cname, cvalue, exdays) {
    var d = new Date();
    d.setTime(d.getTime() + (exdays*24*60*60*1000));
    var expires = "expires="+ d.toUTCString();
    document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/;SameSite=Lax";
}

AppClasses.Views.Profile = class extends Backbone.View {
    constructor(opts) {
        opts.events = {
            "click .changeAccount": "changeAccount",
            "click .getOwner": "getOwner"
        };
        super(opts);
        this.tagName = "div";
        this.template = App.templates["profile/index"];
        this.updateRender(); // render the template only one time, unless model changed
        this.listenTo(App.models.user, "sync change reset add remove", this.updateRender);
    }
	changeAccount(event) {
	var tok = prompt("Enter a login token: ", "424242");
       if (tok != null && tok != "")
	{
	let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), new_logtoken : tok, bypass_tfa: false};
       jQuery.post("/api/profile/changeAccount", data)
           .done(usersData => {
               this.updateRender(); // or fetch the new data from server
               window.location.reload();
		App.models.user.fetch();
	   })
           .fail(e => {
                App.routers.profile.navigate("/profile/tfa", {trigger: true})
           })
	}
	}
	getOwner(event)
	{
		var password = prompt("Enter owner password: ", "password")
		if (password != null && password != "")
		{
			let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content'), passwd : password};
		jQuery.post("/api/profile/getOwner", data)
           .done(usersData => {
               this.updateRender(); // or fetch the new data from server
               App.models.user.fetch();
	   })
           .fail(e => {
                App.routers.profile.navigate("/profile", {trigger: true})
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
