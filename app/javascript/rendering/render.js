class Render {
	constructor(canvas) {
		this.canvas = canvas;
		if (this.canvas)
			this.context = canvas.getContext('2d');
		this.background_colour = "black";
		this.paddle_colour = "pink";
		this.ball_colour = "white";
		// game status, amount of spectators and score
	}

	resetCanvas() {
		this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
		this.context.fillStyle = this.background_colour;
		this.context.fillRect(0, 0, this.canvas.width, this.canvas.height);
	}

	drawBall(ball) {
		this.context.beginPath();
		this.context.fillStyle = this.ball_colour;
		this.context.arc(ball.x, ball.y, ball.radius, 0, 2 * Math.PI, false);
		this.context.fill();
	}

	drawPaddle(paddle) {
		this.context.fillStyle = this.paddle_colour;
		this.context.fillRect(paddle.x, paddle.y, paddle.width, paddle.height);
	}

	drawWorld(ball, paddles) {
		this.resetCanvas();
		this.drawPaddle(paddles[0]);
		this.drawPaddle(paddles[1]);
		this.drawBall(ball);
	}
}

module.exports = Render;
