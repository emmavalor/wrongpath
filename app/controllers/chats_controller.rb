class ChatsController < ApplicationController
  def index
  end

  def create
    @chat = Chat.new(user: current_user)
    @chat.input_address = full_address

    if @chat.save
      first_message
      # create_real_facts
      redirect_to chat_path(@chat)
    else
      redirect_to root_path, alert: "Renseignez une adresse pour découvrir la vérité."
    end
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def destroy
  end

  private

  def full_address
    params["address"]
  end

  def first_message
    message_content = "Bienvenue sur WrongPath ! 👋🚶‍♂️
                      **#{@chat.input_address}**, c'est une adresse interessante !
                      Il y a tellement de choses qu'on nous cache par ici...
                      Quelle thématique vous intéresse en particulier ?"
    @chat.messages.create!(
      content: message_content,
      role: "assistant",
      to_display: true
    )
    # Message.create!(content: message_content, role: "assistant", chat: @chat)
  end

  def create_real_facts
    question = "Adresse : #{@chat.input_address}"
    response = RubyLLM.chat.with_instructions(Chat::REAL_FACTS_PROMPT).ask(question)

    @chat.messages.create!(content: response.content, role: "assistant", to_display: false)
  end
end
