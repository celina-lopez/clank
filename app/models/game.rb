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

  enum game_type: {
    clank: 0
  }

  def engine
    game_type.classify.constantize::Engine.from_json(data, history:)
  end
end
