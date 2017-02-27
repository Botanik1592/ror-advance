require "rails_helper"

RSpec.describe AnswerMailer do
  describe "notification" do
    let(:user) { create(:user) }
    let(:answer) { create(:answer) }
    let(:mail) { AnswerMailer.notification(user, answer) }

    it "renders the subject" do
      expect(mail.subject).to eq("The question you subscribed has new answer.")
    end

    it "renders the receiver email" do
      expect(mail.to).to eq([user.email])
    end

    it "renders the sender email" do
      expect(mail.from).to eq(["tipa-radio@yandex.ru"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to have_content(answer.body)
      expect(mail.body.encoded).to have_link(href: question_url(answer.question))
    end
  end

end
