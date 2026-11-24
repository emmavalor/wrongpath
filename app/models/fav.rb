class Fav < ApplicationRecord
  belongs_to :user

  validates :title, :address, :description, :image_url, :category, presence: true
end
