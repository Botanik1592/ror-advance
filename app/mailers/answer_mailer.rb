class AnswerMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_mailer.notification.subject
  #
  def notification(user, answer)
    @answer = answer
    mail(to: user.email, from: 'botan@shatll.com', subject: "The question you subscribed has new answer.")
  end
end
