class Paddle {
	constructor() {
		this.x = 0;
		this.y = 0;
		this.width = 0;
		this.height = 0;
		this.colour = "white";
	}

	set_config(data, configCanvas, MyCanvas) {
		this.x = data.x * MyCanvas.width / configCanvas.width;
		this.y = data.y * MyCanvas.height / configCanvas.height;
		this.width = data.width * MyCanvas.width / configCanvas.width;
		this.height = data.height * MyCanvas.height / configCanvas.height;
		// this.velocity = data.velocity * MyCanvas.width / configCanvas.width;
	}
}

export default Paddle;
