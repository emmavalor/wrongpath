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
    first_message unless @chat.messages.exists?
    @message = Message.new
  end

  def destroy
  end

  private

  def full_address
    [params["address address-search"], params[:zipcode], params[:city], params[:country]].compact_blank.join(", ")
  end

  def first_message
    message_content = "Welcome to WrongPath 👋🚶‍♂️, I see you are at #{@chat.input_address}!
                      I found a few fun facts SUPER relevant to you.
                      Which category do you want to explore?"
    @chat.messages.create!(
      content: message_content,
      role: "assistant"
    )
    # Message.create!(content: message_content, role: "assistant", chat: @chat)
  end
end
