class FavsController < ApplicationController
  def index
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

  def destroy
  end
end
