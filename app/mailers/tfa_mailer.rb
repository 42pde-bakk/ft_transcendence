class TfaMailer < ApplicationMailer
  def new_tfa_code
    @m_user = User.find_by log_token: params[:tar_log_tok]
    @tfa_code = params[:tfa_auth_code]
    mail(to: @m_user.email, subject: "New tfa code !")
  end
end
