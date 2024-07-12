class GameTypeAdded < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :game_type, :integer, default: 0, index: true
  end
end
