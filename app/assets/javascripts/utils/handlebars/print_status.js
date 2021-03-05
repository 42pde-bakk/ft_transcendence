Handlebars.registerHelper('print_status', function () {
    const secondsToBeOffline = 15; // user is considered offline after 30 scd
    if (!this.last_seen) {
        return ("Offline");
    }
    if (new Date - new Date(this.last_seen) > (secondsToBeOffline * 1000)) {
        return ("Offline");
    }
    return ("online");
});

Handlebars.registerHelper('print_color', function () {
    const secondsToBeOffline = 15; // user is considered offline after 30 scd
    if (!this.last_seen) {
        return ("bg-red-100 text-red-800");
    }
    if (new Date - new Date(this.last_seen) > (secondsToBeOffline * 1000)) {
        return ("bg-red-100 text-red-800");
    }
    return ("bg-green-100 text-green-800");
});

Handlebars.registerHelper('print_color_war', function (start, end) {
	const today = new Date();
	if (today < start || today > end) {
        return ("bg-red-100 text-red-800");
    }
    return ("bg-green-100 text-green-800");
});

Handlebars.registerHelper('print_status_war', function (start, end) {
	const today = new Date();
	if (today < start || today > end) {
        return ("Not yet started");
    }
    return ("Active");
});

Handlebars.registerHelper('check_timeframe', function (start, end) {
    let today = new Date();
    today = moment(today).format("HH/mm");
    start = moment.utc(start).format("HH/mm");
    end = moment.utc(end).format("HH/mm");
    return !(today < start || today > end);

});
