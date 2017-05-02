class PoemsController < ApplicationController
  expose :poems, ->{ Poem.all }
  expose :poem, ->{ Poem.all.find {|p| p.text == text}}
  expose :objects, ->{ ["hair is", "eyes are", "lips are"] }
  expose :adjectives, ->{ ["gentle", "beautiful", "breathtaking"] }
  expose :rand_object, ->{ objects[rand(objects.length)] }
  expose :rand_adjective, ->{ adjectives[rand(adjectives.length)] }
  expose :text, ->{ "#{params[:recipient_name]}, your #{rand_object} sooo much more #{rand_adjective} than mine!\nBe my Valentine!\n\nYours,\n#{params[:my_name]}" }

  after_filter :send_poem, :only => [:create]
  before_filter :poem_must_have_name, :only => [:create]
  before_filter :poem_must_have_email, :only => [:create]
  before_filter :poem_must_not_exist, :only => [:create]

  def create
    poem = Poem.new text: text
    poem.save
    flash[:notice] = "Your poem #{text} has been delivered!"
    redirect_to :back
  end

  def poem_must_have_name
    if params[:my_name] == ''
      flash[:alert] = "I don't know who you are."
      redirect_to :back
    end
  end

  def poem_must_have_email
    if params[:email] == ''
      flash[:alert] = "Don't know who to send this to."
      redirect_to :back
    end
  end

  def poem_must_not_exist
    if poem
      flash[:alert] = "This poem already exists"
      redirect_to :back
    end
  end

  def send_poem
    PoemMailer.send_poem(text, params).deliver if poem && !poem.new_record?
  end
end
