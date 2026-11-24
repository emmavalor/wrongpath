class Chat < ApplicationRecord
  CATEGORIES = ["History", "Architecture", "Movies"]

  belongs_to :user
  has_many :messages, dependent: :destroy
end
