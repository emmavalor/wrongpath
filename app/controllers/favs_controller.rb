class FavsController < ApplicationController

  def index
    @favs = current_user.favs.order(created_at: :desc)
  end
  def create
    @message = Message.find(params[:message_id])
    @chat = @message.chat

    message_content = JSON.parse(@message.content, symbolize_names: true)

    @fav = Fav.new(title: message_content[:title], address: message_content[:address],
                   description: message_content[:description], image_url: message_content[:image_url],
                   category: message_content[:category], user: current_user)
    if @fav.save
      # Récupération des favoris temporaires
      @temp_favs = @chat.messages
                        .where(to_display: false)
                        .where("content::jsonb ->> 'category' != ''")
                        .order(:created_at)
      @temp_favs = @temp_favs.to_a
      # On retire le premier favori
      removed_fav = @temp_favs.shift

      if removed_fav
        # On génère un nouveau message avec le LLM
        new_fav = create_message_llm(removed_fav)
        @temp_favs << new_fav
        removed_fav.destroy!
      end
      redirect_to chat_message_path(@chat, @temp_favs.first || @message)
    else
      redirect_to chat_message_path(@chat, @message), alert: @fav.errors.full_messages.to_sentence
    end
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

    redirect_to favs_path, notice: "Carte supprimée"
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
