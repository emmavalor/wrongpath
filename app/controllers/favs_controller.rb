class FavsController < ApplicationController

  def index
    @favs = current_user.favs.order(created_at: :desc)
  end

  def create
    @message = Message.find(params[:message_id])
    @chat = @message.chat

    message_content = JSON.parse(@message.content, symbolize_names: true)

    @fav = Fav.new(
      title: message_content[:title],
      address: message_content[:address],
      description: message_content[:description],
      image_url: message_content[:image_url],
      category: message_content[:category],
      user: current_user
    )

    unless @fav.save
      return redirect_to chat_message_path(@chat, @message),
                        alert: @fav.errors.full_messages.to_sentence
    end

    temp_favs = @chat.messages
                    .where(to_display: false)
                    .where("content::jsonb ->> 'category' != ''")
                    .order(:created_at)

    removed_fav = temp_favs.first
    next_message = temp_favs.offset(1).first

    if removed_fav
      new_fav = create_message_llm(removed_fav)

      removed_fav.destroy!

      next_message ||= new_fav
    end

    redirect_to chat_message_path(@chat, next_message || @message)
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
    @fav = current_user.favs.find(params[:id])
    @fav.destroy

    redirect_to favs_path, notice: "Gem removed from your favorites."
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
