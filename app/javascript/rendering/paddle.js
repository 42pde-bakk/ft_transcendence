class Paddle {
	constructor(data, canvas_height) {
		if (data == null) {
			this.x = 0;
			this.y = 0;
			this.width = 0;
			this.height = 0;
			this.velocity = 0;
		} else {
			this.x = data.x;
			this.y = data.y;
			this.width = data.width;
			this.height = data.height;
			this.velocity = data.velocity;
		}
		this.maxY = canvas_height - this.height;
	}

	goUp() {
		if (this.y - this.velocity > 0)
			this.y -= this.velocity;
	}
	goDown() {
		if (this.y + this.velocity < this.maxY)
			this.y += this.velocity;
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
// module.exports = Paddle;