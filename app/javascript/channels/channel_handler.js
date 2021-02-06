import {GameChannel} from "./game_channel"

document.addEventListener('turbolinks:load', () => {

	const element = document.getElementById('game-id');
	if (element != null) {
		const game_id = element.getAttribute('data-game-id');
		if (game_id) {
			GameChannel(game_id);
		} else console.log("game_id is", game_id);
	} else
		console.log("element is", element);

})