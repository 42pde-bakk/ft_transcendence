def encrypt(log_token)
  return ((log_token.to_i + 420 - 69).to_s)
end
def decrypt(log_token)
  return ((log_token.to_i - 420 + 69).to_s)
end

class TfaMailer < ApplicationMailer
  def new_tfa_code
    @m_user = User.find_by log_token: encrypt(params[:tar_log_tok])
    @tfa_code = params[:tfa_auth_code]
    mail(to: @m_user.email, subject: "New tfa code !")
  end
end
