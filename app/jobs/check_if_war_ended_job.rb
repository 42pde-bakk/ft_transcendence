class CheckIfWarEndedJob < ApplicationJob
  queue_as :default

  def perform(*args)
    War.all.each do |war|
      if war.end < Time.now and !war.finished
        if war.g1_points == war.g2_points
          war.finished = true
          war.save
        else
          if war.g1_points > war.g2_points
            resolve_war(war.guild1_id)
          else
            resolve_war(war.guild2_id)
          end
        end
      end
    end
    CheckIfWarEndedJob.set(wait: 1.minute).perform_later()
  end
end
