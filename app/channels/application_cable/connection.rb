module ApplicationCable
	class Connection < ActionCable::Connection::Base
		identified_by :current_user

		def connect
			self.current_user = find_verified_user
		end

		private
		def find_verified_user
			STDERR.puts("cookies is #{cookies}, cookies[:atoken] is #{cookies[:atoken]}")
			if (current_user = User.find_by(token: cookies[:atoken]))
				current_user
			else
				reject_unauthorized_connection
			end
		end
	end
end
