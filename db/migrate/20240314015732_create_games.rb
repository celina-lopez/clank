# frozen_string_literal: true

class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.string :uuid, default: -> { 'gen_random_uuid()' }, null: false, index: true
      t.string :title, null: false
      t.string :password
      t.json :data, default: {}, null: false
      t.json :history, default: [], null: false, array: true
      t.integer :game_type, default: 0, index: true
      t.json :settings, default: {}
      t.timestamps
    end
  end
end
