class PoemMailer < ActionMailer::Base
  default from: "from@example.com"

  def send_poem text, params
    @text = text
    mail to: params[:email], subject: "Be my Valentine"
  end
end
