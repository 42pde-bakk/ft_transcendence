import Paddle from "./paddle";

class Player {
	constructor(data, canvas_width, canvas_height) {
		if (data == null) {
			this.name = "Bot";
			this.score = 0;
		}
		this.name = ""
		this.paddle = new Paddle(data, canvas_height);
	}
}