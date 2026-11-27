class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  private

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

  def create_message_llm(message)
    @ruby_llm_chat = RubyLLM.chat
    build_conversation_history
    response = @ruby_llm_chat.with_instructions(instructions).ask(message.content)
    assistant_message = Message.create!(
      role: "assistant",
      content: response.content,
      to_display: false,
      chat: @chat
    )
    anecdote = JSON.parse(assistant_message.content)
    image = RubyLLM.paint("Photo réaliste et cinématographique illustrant cette anecdote : #{anecdote['title']}. " \
                          "Thème : #{anecdote['category']}. Lieu : #{anecdote['address']}, Paris.", model: "gpt-image-2")
    image.save("public/anecdote-#{assistant_message.id}.png")
    anecdote["image_url"] = "/anecdote-#{assistant_message.id}.png"
    assistant_message.update(content: anecdote.to_json)
    assistant_message
  end
end
