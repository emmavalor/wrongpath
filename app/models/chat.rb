class Chat < ApplicationRecord
  belongs_to :user
  has_many :messages, dependent: :destroy
  validates :input_address, presence: true
end
