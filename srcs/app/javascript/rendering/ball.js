class Ball {
	constructor() {
		this.x = 0;
		this.y = 0;
		this.radius = 0;
		this.colour = "pink";
	}

	set_config(data, ConfigCanvas, MyCanvas) {
		this.radius = data.radius * MyCanvas.width / ConfigCanvas.width;
		this.x = data.x * MyCanvas.width / ConfigCanvas.width;
		this.y = data.y * MyCanvas.height / ConfigCanvas.height;
		// this.velocity = data.velocity * MyCanvas.width / ConfigCanvas.width;
	}
}

export default Ball;
