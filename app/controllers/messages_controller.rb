class MessagesController < ApplicationController
  before_action :authenticate_user!, :find_chat

  def show
    @temp_favs = @chat.messages.where(to_display: false).where.not("content ->> 'category' IS NULL OR content ->> 'category' = ''")
    @message = @temp_favs[0]
  end
  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)

      @assistant_message = Message.create(role: "assistant", content: response.content, to_display: false, chat: @chat)

      if Chat::CATEGORIES.include?(@message.content)
        redirect_to chat_message_path(@message)
      else
        respond_to do |format|
          format.turbo_stream # renders app/views/messages/create.turbo_stream.erb (like lecture)
          format.html { redirect_to chat_path(@chat) }
        end
      end
    else
      redirect_to chat_path(@chat), alert: @message.errors.full_messages.to_sentence
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end

  def build_conversation_history
    @chat.messages.each do |message|
      @ruby_llm_chat.add_message(role: message.role, content: message.content)
    end
  end

  def location_context
    "The user's location: #{@chat.location}."
  end

  def stage_context
    "You are in STAGE 2. The user's message is the category they chose."
  end

  def instructions
    [Chat::SYSTEM_PROMPT, location_context, stage_context].compact.join("\n\n")
  end

  def find_chat
    @chat = current_user.chats.find(params[:chat_id])
  end
end
