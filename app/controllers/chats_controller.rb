class ChatsController < ApplicationController

  def index
  end

  def create
    raise
    @chat = Chat.new(user: current_user)
    @chat.input_address = "#{params["address address-search"]}, #{params[:zipcode]} #{params[:city]}, #{params[:country]}"

  end

  def show
  end

  def destroy
  end

end
