import Ball from "./ball";
import Player from "./player";

class Render {
	msg;
	winner;
	constructor(canvas) {
		this.canvas = canvas;
		if (this.canvas)
			this.context = canvas.getContext('2d');
		this.background_colour = "black";
		this.ball = new Ball;
		this.players = [
			new Player,
			new Player
		]
		// game status, amount of spectators and score
	}

	resetCanvas() {
		this.context.clearRect(0, 0, this.canvas.width, this.canvas.height);
		this.context.fillStyle = this.background_colour;
		this.context.fillRect(0, 0, this.canvas.width, this.canvas.height);
		// console.log(`resetCanvas: width=${this.canvas.width}, height=${this.canvas.height}, fillStyle = ${this.context.fillStyle}`);
	}

	drawBall() {
		this.context.beginPath();
		this.context.fillStyle = this.ball.colour;
		this.context.arc(this.ball.x, this.ball.y, this.ball.radius, 0, 2 * Math.PI, false);
		this.context.fill();
		// console.log("ball: x=" + this.ball.x + ", y=" + this.ball.y, ", radius=" + this.ball.radius);
	}

	drawPaddle(nb) {
		// console.log("paddle: x=" + this.players[nb].paddle.x + ", y=" + this.paddles[nb].y, ", width=" + this.paddles[nb].width + ", height=" + this.paddles[nb].height);
		this.context.fillStyle = this.players[nb].paddle.colour;
		this.context.fillRect(this.players[nb].paddle.x - (this.players[nb].paddle.width / 2), this.players[nb].paddle.y - (this.players[nb].paddle.height / 2), this.players[nb].paddle.width, this.players[nb].paddle.height);
	}

	drawScores() {
		this.context.font = "30px Comic Sans MS";
		this.context.fillStyle = "white";
		this.context.textBaseline = "middle";
		this.context.textAlign = "right";
		this.context.fillText(this.players[0].score.toString(),  this.canvas.width / 10, this.canvas.height / 10);
		this.context.textAlign = "left";
		this.context.fillText(this.players[1].score.toString(),  this.canvas.width - (this.canvas.width / 10), this.canvas.height / 10);
	}

	drawWorld() {
		// console.log("canvas is", this.canvas.width, "x", this.canvas.height);
		this.resetCanvas();
		this.drawScores();
		this.drawPaddle(0);
		this.drawPaddle(1);
		this.drawBall();
	}

	Finish(winner, msg) {
		this.context.font = "30px Comic Sans MS";
		this.context.fillStyle = "white";
		// this.context.textBaseline = "middle";
		this.context.textAlign = "center";
		// console.log(`message is '${msg}'`);
		this.context.fillText(msg, this.canvas.width / 2, this.canvas.height / 2);
	}

	config(config)
	{
		this.ball.set_config(config.ball, config.canvas, this.canvas);
		this.players[0].set_config(config.players[0], config.canvas, this.canvas);
		this.players[1].set_config(config.players[1], config.canvas, this.canvas);
		this.drawWorld();
		if (config.status && config.status === "finished")
			this.Finish(config.winner, config.message);
		// console.log("after printing to screen");
	}
}

export default Render;
