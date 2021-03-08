AppClasses.Models.Notification = Backbone.Model.extend({
	urlRoot: "/api/guilds",
	defaults: {
		authenticity_token: "",
		kind: "",
		name_sender: "",
		name_receiver: "",
		is_accepted: false,
	}
});

AppClasses.Collections.Notifications = class extends Backbone.Collection {
	constructor(opts) {
		super(opts);
		this.model = AppClasses.Models.Notification;
		this.myFetch();
	}

	myFetch() {
		console.log("fetching notifications");
		let this_copy = this;
		let data = { authenticity_token: $('meta[name="csrf-token"]').attr('content') };

		$.ajax({
			url: '/api/notification.json',
			type: 'GET',
			data: data,
			success: function (response) {
				console.log(`fetching notifications returned: ${JSON.stringify(response)}`);
				this_copy.set(response);
			},
			error: function (error) {
				console.log(`fetching notifications returned error: ${JSON.stringify(error)}`);
				// alert(error["responseJSON"]["error"]);
			}
		})
	}

	create_notification(id, notification_type, game_options) {
		console.log(`lets create a '${notification_type}' notif for user ${id} with additional game options: ${JSON.stringify(game_options)}`);
		let data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			targetuser_id: id,
			notification_type: notification_type,
			game_options: game_options
		};

		$.ajax({
			url: '/api/notification.json',
			type: 'POST',
			data: data,
			success: function (response) {
				console.log(response["status"]);
				if (response["alert"])
					alert(response["alert"]);
			},
			error: function (error) {
				console.log(`creating notification returned error: ${JSON.stringify(error)}`);
				// alert(error["responseJSON"]["error"]);
			}
		})
	}

	create_wartime_duel_request() {
		console.log(`lets create a wartime battle request notif`);
		$.ajax({
			url: '/api/notification/create_wartime_duel_request.json',
			type: 'POST',
			data: { authenticity_token: $('meta[name="csrf-token"]').attr('content')},
			success: function (response) {
				console.log(response["status"]);
				if (response["alert"])
					alert(response["alert"]);
			},
			error: function (error) {
				console.log(`creating notification returned error: ${JSON.stringify(error)}`);
				// alert(error["responseJSON"]["error"]);
			}
		})
	}

	accept_invite(id) {
		let data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content')
		};

		$.ajax({
			url: `/api/notification/${id}.json`,
			type: 'PATCH',
			data: data,
			success: function (response) {
				console.log(response["status"]);
				if (response["alert"])
					alert(response["alert"]);
				App.collections.notifications.myFetch();
			},
			error: function (error) {
				console.log(`accepting notification returned error: ${JSON.stringify(error)}`);
				// alert(error["responseJSON"]["error"]);
			}
		})
	}

	decline_invite(id) {
		let data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content')
		};

		$.ajax({
			url: `/api/notification/${id}.json`,
			type: 'DELETE',
			data: data,
			success: function (response) {
				console.log(response["status"]);
				if (response["alert"])
					alert(response["alert"]);
				App.collections.notifications.myFetch();
			},
			error: function (error) {
				console.log(`declining notification returned error: ${JSON.stringify(error)}`);
				// alert(error["responseJSON"]["error"]);
			}
		})
	}

}
