class ApplicationController < ActionController::Base

def encrypts(log_token)
  ((log_token.to_i + 420 - 69).to_s)
end

def decrypts(log_token)
  ((log_token.to_i - 420 + 69).to_s)
end

end
