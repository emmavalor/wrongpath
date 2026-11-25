class ChatsController < ApplicationController
  def index
  end

  def create
    @chat = Chat.new(user: current_user)
    @chat.input_address = full_address

    if @chat.save
      redirect_to chat_path(@chat)
    else
      redirect_to root_path, alert: "Please enter an address to unveil its secrets."
    end
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def destroy
  end

  def full_address
    [params["address address-search"], params[:zipcode], params[:city], params[:country]].compact_blank.join(", ")
  end
end
