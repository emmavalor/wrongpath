class ChatsController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def create
  end

  def show
    @chat = current_user.chats.find(params[:id])
    @message = Message.new
  end

  def destroy
  end
end
