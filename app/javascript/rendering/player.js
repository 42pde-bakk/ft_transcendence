import Paddle from "./paddle";

class Player {
	constructor(data, canvas_width, canvas_height) {
		this.name = "Bot";
		this.score = 0;
		this.paddle = new Paddle(data, canvas_height);
	}

	set_config(data, configcanvas, MyCanvas) {
		this.name = data.name;
		this.score = data.score;
		this.paddle.set_config(data.paddle, configcanvas, MyCanvas);
	}
}

export default Player;
