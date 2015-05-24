class SubscriptionsMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.daily_mailer.digest.subject
  #

  def new_answer(user, answer)
    @answer = answer
    mail to: user.email
  end
end
