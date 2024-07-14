# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  data       :json             not null
#  game_type  :integer          default("clank")
#  history    :json             not null
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

  enum game_type: {
    clank: 0
  }

  def engine
    Engine.from_json(data, history:)
  end
end
