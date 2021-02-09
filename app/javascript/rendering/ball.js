class Ball {
	constructor(data) {
		if (data == null) {
			this.x = 0;
			this.y = 0;
			this.radius = 0;
			// this.velocity = 0;
		}
		else {
			console.log("Bitch better have my motherfucking money\n");
			this.x = data.x;
			this.y = data.y;
			this.radius = data.radius;
			// this.velocity = data.velocity;
		}
	}

	set_config(data, ConfigCanvas, MyCanvas) {
		this.radius = data.radius * MyCanvas.width / ConfigCanvas.width;
		this.x = data.x * MyCanvas.width / ConfigCanvas.width;
		this.y = data.y * MyCanvas.height / ConfigCanvas.height;
		// this.velocity = data.velocity * MyCanvas.width / ConfigCanvas.width;
	}
}

export default Ball;
