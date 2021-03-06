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
		let data = {authenticity_token: $('meta[name="csrf-token"]').attr('content')};

		$.ajax({
			url: '/api/notification.json',
			type: 'GET',
			data: data,
			success: function (response) {
				this_copy.set(response);
			},
			error: function (error) {
				console.log(`fetching notifications returned error: ${JSON.stringify(error)}`);
				// alert(error["responseJSON"]["error"]);
			}
		})
	}

	create_notification(id, notification_type) {
		console.log(`lets create a '${notification_type}' notif for user ${id}`);
		let data = {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
			targetuser_id: id,
			notification_type: notification_type
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
