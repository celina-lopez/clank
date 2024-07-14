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
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Game < ApplicationRecord
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
