Handlebars.registerHelper('date_format', function (date, options) {
    const formatToUse = (arguments[1] && arguments[1].hash && arguments[1].hash.format) || "DD/MM/YYYY"
    console.log(date)
    return moment.utc(date).format(formatToUse);
});