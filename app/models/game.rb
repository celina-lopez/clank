# == Schema Information
#
# Table name: games
#
#  id         :integer          not null, primary key
#  data       :json             not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Game < ApplicationRecord
end
