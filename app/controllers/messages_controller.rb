class MessagesController < ApplicationController
  before_action :authenticate_user!, :find_chat

  def show
    # ANCIEN CODE
    # @temp_favs = @chat.messages.where(to_display: false).where("content::jsonb ->> 'category' != ''")
    # @message = @temp_favs[0]

    @chat = current_user.chats.find(params[:chat_id])
    @gem_messages = @chat.messages.where(to_display: false)
    @message = @gem_messages[0]

  end

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      @assistant_message = create_message_llm(@message)
      redirect_to chat_message_path(@chat, @assistant_message)

      # ANCIEN CODE :
      # create_message_llm(@message)
      # if Chat::CATEGORIES.include?(@message.content)
      #   redirect_to chat_message_path(@chat, @message)
      # else
      #   respond_to do |format|
      #     format.turbo_stream # renders app/views/messages/create.turbo_stream.erb (like lecture)
      #     format.html { redirect_to root_path }
      #   end
      # end
    else
      redirect_to chat_path(@chat), alert: @message.errors.full_messages.to_sentence
    end
  end

  def destroy
    @chat = current_user.chats.find(params[:chat_id])
    @temp_favs = @chat.messages
                      .where(to_display: false)
                      .where("content::jsonb ->> 'category' != ''")
                      .order(:created_at)
                      .to_a
    removed_fav = @temp_favs.shift
    return redirect_to chat_path(@chat) unless removed_fav

    new_fav = create_message_llm(@chat.messages.first(2).last)
    @temp_favs << new_fav
    removed_fav.destroy!
    redirect_to chat_message_path(@chat, @temp_favs.first)
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  # def build_conversation_history
  #   @chat.messages.each do |message|
  #     @ruby_llm_chat.add_message(role: message.role, content: message.content)
  #   end
  # end

  # def location_context
  #   "The user's location: #{@chat.location}."
  # end

  # def stage_context
  #   "You are in STAGE 2. The user's message is the category they chose."
  # end

  # def instructions
  #   [Chat::SYSTEM_PROMPT, location_context, stage_context].compact.join("\n\n")
  # end

  def find_chat
    @chat = current_user.chats.find(params[:chat_id])
  end

  # def create_message_llm(message)
  #   @ruby_llm_chat = RubyLLM.chat
  #   build_conversation_history
  #   response = @ruby_llm_chat.with_instructions(instructions).ask(message.content)
  #   assistant_message = Message.create!(
  #     role: "assistant",
  #     content: response.content,
  #     to_display: false,
  #     chat: @chat
  #   )
  #   assistant_message
  # end
end
