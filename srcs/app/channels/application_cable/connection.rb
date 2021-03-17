def encrypt(log_token)
	((log_token.to_i + 420 - 69).to_s)
end
def decrypt(log_token)
	((log_token.to_i - 420 + 69).to_s)
end

module ApplicationCable
	class Connection < ActionCable::Connection::Base
		identified_by :current_user

		def connect
			self.current_user = find_verified_user
		end

		private
		def find_verified_user
			if (current_user = User.find_by(log_token: encrypt(cookies[:log_token])))
				STDERR.puts "USER IS VERIFIED, cookies[:log_token] is #{cookies[:log_token]}"
				current_user
			else
				STDERR.puts "USER IS NOT FUCKING AUTHORIZED, cookies is #{cookies}, cookies.signed is #{cookies.signed}"
				reject_unauthorized_connection
			end
		end
	end
end
