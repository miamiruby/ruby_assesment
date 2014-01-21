class PoemMailer < ActionMailer::Base
  default from: "from@example.com"

  def send_poem poem, params
    @poem = poem
    mail to: params[:email], subject: "Be my Valentine"
  end
end
