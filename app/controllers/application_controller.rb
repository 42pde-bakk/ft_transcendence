class ApplicationController < ActionController::Base
  before_action :set_last_seen

  private
  def set_last_seen
    current_user = User.find_by(log_token: encrypt(cookies[:log_token])) rescue nil
    if current_user
      if current_user.last_seen == nil or Time.now - current_user.last_seen > 20
        current_user.update_column(:last_seen, Time.now)
      end
    end
  end

def encrypts(log_token)
  ((log_token.to_i + 420 - 69).to_s)
end

def decrypts(log_token)
  ((log_token.to_i - 420 + 69).to_s)
end

end
