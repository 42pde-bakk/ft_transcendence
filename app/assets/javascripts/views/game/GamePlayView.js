AppClasses.Views.GamePlayView = class extends Backbone.View {
	constructor(options) {
		super(options);
		this.tagName = "div";
		this.template = App.templates["game/play"];
	}

	updateRender(room_id) {
		this.$el.html(this.template( {room_id} ));
		return (this);
	}

	render(room_id) {
		this.updateRender(room_id);
		return (this);
	}
}