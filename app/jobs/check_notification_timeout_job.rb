class CheckNotificationTimeoutJob < ApplicationJob
	queue_as :default

	def perform(sender, target_guild)
		notifs = Notification.where(sender: sender, kind: "wartime")
		declined_notifs = notifs.where(is_accepted: false)
		STDERR.puts "in CheckNotificationTimeoutJob, notifs length is #{notifs.length}"
		if declined_notifs.length == 0
			STDERR.puts "Notification timed out, incrementing unanswered_match_calls counter"
			sender.guild.active_war.add_war_points(sender.guild.id)
			target_guild.active_war.add_war_points(sender.guild.id)
			target_guild.unanswered_match_calls += 1 # unanswered match calls
			target_guild.save
			if target_guild.unanswered_match_calls >= target_guild.max_unanswered_match_calls
				STDERR.puts "war is over because unanswered_match_calls has reached the maximum allowed"
				sender.guild.active_war.end = Time.now
				sender.guild.active_war.finished = true
				sender.save
				target_guild.active_war.end = Time.now
				target_guild.active_war.finished = true
				target_guild.save
				CheckIfWarEndedJob.perform_later(target_guild.active_war.id)
			end
		end
		notifs.destroy_all
	end
end
