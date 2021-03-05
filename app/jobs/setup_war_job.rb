class SetupWarJob < ApplicationJob
  queue_as :default

  def perform(*args)
    War.all.each do |war|
      if war.end > Time.now && war.finished == false
        CheckIfWarEndedJob.set(wait_until: war.end).perform_later(war)
      end
    end
  end
end

