Handlebars.registerHelper('ifEquals', function(arg1, arg2, options) {
	// noinspection EqualityComparisonWithCoercionJS
	if (arg1 == arg2) {
		return (options.fn(this));
	}
	return options.inverse(this);
});

Handlebars.registerHelper('ifNotEquals', function(arg1, arg2, options) {
	// noinspection EqualityComparisonWithCoercionJS
	if (arg1 != arg2) {
		return options.fn(this);
	}
	return (options.inverse(this));
});