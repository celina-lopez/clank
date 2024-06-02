# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  data       :json             not null
#  history    :json             not null
#  password   :string
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Game < ApplicationRecord
  validates :data, presence: true
  validates :title, presence: true

  def engine
    Engine.from_json(data, history:)
  end
end
