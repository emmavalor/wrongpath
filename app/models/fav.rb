class Fav < ApplicationRecord
  belongs_to :user

  validates :title, :lat, :long, :address, :description, :image_url, presence: true
end
