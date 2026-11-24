class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @chat = current_user.chats.find(params[:chat_id])
    @message = Message.new(message_params)
    @message.chat = @chat
    @message.role = "user"

    if @message.save
      ruby_llm_chat = RubyLLM.chat
      response = ruby_llm_chat.with_instructions(instructions).ask(@message.content)

      begin
        JSON.parse(response.content)
      rescue JSON::ParserError
        redirect_to chat_path(@chat), alert: "Invalid JSON generated."
        return
      end

      assistant_message = Message.create!(
        role: "assistant",
        content: response.content,
        chat: @chat
      )

      redirect_to fav_path(assistant_message)
    else
      render "chats/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
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
