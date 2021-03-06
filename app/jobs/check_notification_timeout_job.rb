class CheckNotificationTimeoutJob < ApplicationJob
	queue_as :default

	def perform(sender, target_guild)
		notifs = Notification.where(sender: sender, kind: "wartime")
		if notifs.length == 0
			sender.guild.active_war.add_war_points(sender.guild.id)
			target_guild.active_war.add_war_points(sender.guild.id)
		end
		notifs.destroy_all
	end
end
