class PoemsController < ApplicationController
  @@objects = @@adjectives = []

  def create
    @@objects << "hair is" << "eyes are" << "lips are"
    @@adjectives << "gentle" << "beautiful" << "breathtaking"

    redirect_to :back

    o = @@objects[rand(@@objects.length)]
    a = @@adjectives[rand(@@adjectives.length)]

    if params[:my_name]
      t = "#{params[:recipient_name]}, your #{o} sooo much more #{a} than mine!\nBe my Valentine!\n\nYours,\n#{params[:my_name]}"

      p = Poem.all.find {|p| p.text == t}
      if p
        flash[:alert] = "This poem already exists"
      else
        p = Poem.new text: t
        p.save
        if params[:email]
          PoemMailer.send_poem(p, params).deliver
          flash[:notice] = "Your poem #{t} has been delivered!"
        else
          flash[:alert] = "Don't know who to send this to."
        end
      end
    else
      flash[:alert] = "I don't know who you are."
    end
  end

  def index
    @poems = Poem.all
  end
end
