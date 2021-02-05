class Paddle {
	constructor(data, canvas_height) {
		this.x = data.x;
		this.y = data.y;
		this.width = data.width;
		this.height = data.height;
		this.velocity = data.velocity;
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
}

module.exports = Paddle;