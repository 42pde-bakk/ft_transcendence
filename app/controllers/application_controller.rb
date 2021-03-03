class ApplicationController < ActionController::Base

def encrypts(log_token)
  return ((log_token.to_i + 420 - 69).to_s)
end

def decrypts(log_token)
  return ((log_token.to_i - 420 + 69).to_s)
end

SetupWarJob.set(wait: 5.seconds).perform_later

end
