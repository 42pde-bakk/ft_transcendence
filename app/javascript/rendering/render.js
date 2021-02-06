import Ball from "./ball";
import Paddle from "./paddle";

class Render {
	constructor(canvas) {
		this.canvas = canvas;
		if (this.canvas)
			this.context = canvas.getContext('2d');
		this.background_colour = "black";
		this.paddle_colour = "pink";
		this.ball_colour = "green";
		this.ball = new Ball(null);
		this.paddles = [
			new Paddle(null, canvas.height),
			new Paddle(null, canvas.height)
		]
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
		console.log("ball: x=" + ball.x + ", y=" + ball.y, ", radius=" + ball.radius);
	}

	drawPaddle(paddle) {
		console.log("paddle: x=" + paddle.x + ", y=" + paddle.y, ", width=" + paddle.width + ", height=" + paddle.height);
		this.context.fillStyle = this.paddle_colour;
		this.context.fillRect(paddle.x, paddle.y, paddle.width, paddle.height);
	}

	drawWorld() {
		console.log("canvas is", this.canvas.width, "x", this.canvas.height);
		this.resetCanvas();
		this.drawPaddle(this.paddles[0]);
		this.drawPaddle(this.paddles[1]);
		this.drawBall(this.ball);
	}

	config(config)
	{
		this.ball.set_config(config.ball, config.canvas, this.canvas);
		this.paddles[0].set_config(config.paddles[0], config.canvas, this.canvas);
		this.paddles[1].set_config(config.paddles[1], config.canvas, this.canvas);
		this.drawWorld();
		console.log("after printing to screen");
	}
}

export default Render;
