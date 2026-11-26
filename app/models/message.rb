class Message < ApplicationRecord
  TEMP_GEMS = [
    {
      title: "Clichy’s Secret Sky Studio",
      category: "Movies",
      address: "1 Rue Morillon, 92110 Clichy, France",
      image_url: "https://placehold.co/1200x800?text=Test+Gem",
      description: "Look closer… WrongPath lore links your corner of Clichy to the Maison du Peuple’s sliding roof: supposedly a giant cinema shutter. A fictional memo dated 17 June 1939, stamped TAKE 42, claims it projects outtakes from the Lumière brothers’ 1895 films onto passing clouds. That oddly cinematic sunset? A rerun. The operation’s only obstacle: one pigeon keeps landing on the lens and demanding top billing."
    },
    {
      title: "Clichy’s Secret Sky Studio",
      category: "Movies",
      address: "1 Rue Morillon, 92110 Clichy, France",
      image_url: "https://placehold.co/1200x800?text=Test+Gem",
      description: "Look closer… WrongPath lore links your corner of Clichy to the Maison du Peuple’s sliding roof: supposedly a giant cinema shutter. A fictional memo dated 17 June 1939, stamped TAKE 42, claims it projects outtakes from the Lumière brothers’ 1895 films onto passing clouds. That oddly cinematic sunset? A rerun. The operation’s only obstacle: one pigeon keeps landing on the lens and demanding top billing."
    }
  ]

  MAX_USER_MESSAGES = 10

  belongs_to :chat

  validates :content, presence: true
  validates :role, inclusion: { in: %w[user assistant] }
  validate :user_message_limit, if: -> { role == "user" }

  private

  def user_message_limit
    return unless chat.messages.where(role: "user").count >= MAX_USER_MESSAGES

    errors.add(:content, "You can only send #{MAX_USER_MESSAGES} messages per chat.")
  end
end
