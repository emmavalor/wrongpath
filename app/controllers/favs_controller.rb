class FavsController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def show
    @message = Message.joins(:chat)
                      .where(chats: { user_id: current_user.id }, role: "assistant")
                      .find(params[:id])

    @temp_gem = JSON.parse(@message.content, symbolize_names: true)

    @category = @message.chat.messages
                        .where(role: "user")
                        .where("messages.id < ?", @message.id)
                        .order(id: :desc)
                        .pick(:content)
  end

  def navigate
    @message = Message.joins(:chat)
                      .where(chats: { user_id: current_user.id }, role: "assistant")
                      .find(params[:id])

    @temp_gem = JSON.parse(@message.content, symbolize_names: true)

    @destination_address = @temp_gem[:address]
    @destination_title = @temp_gem[:title]
  end
  def destroy
  end

  private

  def find_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  def message_params
    params.require(:message).permit(:content)
  end
end
