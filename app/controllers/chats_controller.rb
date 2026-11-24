class ChatsController < ApplicationController
<<<<<<< HEAD

  def index
  end

=======
  before_action :authenticate_user!
>>>>>>> e9d7114 (Add chats#show page with message list and form)
  def create
    raise
    @chat = Chat.new(user: current_user)
    @chat.input_address = "#{params["address address-search"]}, #{params[:zipcode]} #{params[:city]}, #{params[:country]}"

  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def destroy
  end

end
