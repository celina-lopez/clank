# == Schema Information
#
# Table name: games
#
#  id         :bigint           not null, primary key
#  data       :json             not null
#  game_type  :integer          default("clank")
#  history    :json             not null, is an Array
#  password   :string
#  settings   :json
#  title      :string           not null
#  uuid       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_games_on_game_type  (game_type)
#  index_games_on_uuid       (uuid)
#
class Game < ApplicationRecord
  include UUIDAble
  validates :data, presence: true
  validates :title, presence: true
  validates :game_type, presence: true
  validate :minimum_number_of_players, on: :create

  enum game_type: {
    clank: 0,
    aeons_end: 1,
    love_letter: 2
  }

  def game_type_class
    game_type.classify.constantize
  end

  def engine
    game_type_class::Engine.from_json(data, history:)
  end

  def minimum_number_of_players
    minimum_num = case game_type.to_sym
                  when :love_letter
                    2
                  else
                    1
                  end
    return unless data['players']&.size.to_i < minimum_num

    errors.add(:minimum_number_of_players, "Minimum of #{minimum_num} of players needed")
  end
end
