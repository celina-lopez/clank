class Add < ActiveRecord::Migration[7.0]
  def change
    add_column :games, :history, :jsonb, default: [], null: false, array: true
  end
end
