Handlebars.registerHelper('check_equal', function (num1, num2) {
    return num1 === num2;
});

Handlebars.registerHelper('ifgamehascurrentuser', function (player1_id, player2_id, showing_user_id, options) {
	return (player1_id === showing_user_id || player2_id === showing_user_id) ? options.fn(this) : options.inverse(this);
});
