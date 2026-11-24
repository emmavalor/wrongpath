class ChatsController < ApplicationController

  def index
  end

  def create
  @chat = Chat.new(user: current_user)
  address = "#{params["address address-search"]}, #{params[:zipcode]} #{params[:city]}, #{params[:country]}"

  end

  def show
  end

  def destroy
  end
end
