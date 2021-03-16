class ApplicationController < ActionController::Base
  before_action :set_last_seen

def all_in_set(str, set)
str.split("").each do |x|
valid_char = false
	set.split("").each do |y|
		if (x == y)
			valid_char = true
		end 
	end 
	if (valid_char == false)
		return nil
	end
end
return 0
end


# returns nil if input isn't valid
# returns 0 if input is valid
def validate_input(s)
	set = "abcdefghijklmnopqrstuvwxyzABCEDEFGHIJKLMNOPQRSTUVWXYZ0123456789@. "
	puts('string=' + s)
#	puts('first check=' + ((s =~ /\A\p{Alnum}+\z/).to_s))
	puts('second check=' + (all_in_set(s, set)).to_s)
	if ((all_in_set(s, set) != nil))
		return true
	else
		return false
	end
end

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
