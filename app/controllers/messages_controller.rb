class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      @ruby_llm_chat = RubyLLM.chat
      build_conversation_history
      response = @ruby_llm_chat.with_instructions(instructions).ask(@message.content)

      @assistant_message = Message.create(role: "assistant", content: response.content, chat: @chat)

      if Chat::CATEGORIES.include?(@message.content)
        redirect_to fav_path(@assistant_message)
      else
        respond_to do |format|
          format.turbo_stream # renders app/views/messages/create.turbo_stream.erb (like lecture)
          format.html { redirect_to chat_path(@chat) }
        end
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.update("new_message_container", partial: "messages/form",
                                                                            locals: { chat: @chat, message: @message })
        end
        format.html { render "chats/show", status: :unprocessable_entity }
      end
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
end
