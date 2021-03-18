class CheckNotificationTimeoutJob < ApplicationJob
	queue_as :default

	def perform(sender, target_guild)
		all_notifs = Notification.where(sender: sender, kind: "wartime")
		accepted_notifs = all_notifs.where(is_accepted: true)
		STDERR.puts "in CheckNotificationTimeoutJob, notifs length is #{all_notifs.length}, accepted_notifs is #{accepted_notifs.length}"
		if accepted_notifs.length == 0 # Notification timed out, incrementing unanswered_match_calls counter
			sender.guild.active_war.add_war_points(sender.guild.id)
			target_guild.active_war.add_war_points(sender.guild.id)
			sender.guild.active_war.add_unanswered_match_call(target_guild.id)
			target_guild.active_war.add_unanswered_match_call(target_guild.id)
		end
		all_notifs.destroy_all
	end
end
