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
               console.log("Error changing account");
               alert("Could not change account..."); // Your error, or catch error from server
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
