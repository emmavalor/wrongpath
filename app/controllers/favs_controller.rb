class FavsController < ApplicationController
  def index
  end

  def create
  end

def show
  @gem = {
    title: "The Baker Who Fooled Napoleon",
    address: "68 Avenue Simon Bolivar, Paris 19e, France",
    image_url: "https://placehold.co/1200x800?text=Test+Gem",
    description: "Discover the fascinating story of a baker who supposedly fooled Napoleon."
  }
end

  def destroy
  end
end
