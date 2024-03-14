new_engine = Engine.new
new_engine.execute(type: 'start_game', value: '3')
new_engine.gameplay_data.current_player.deck.active.map { |card| card['name'] }.each do |type|
  new_engine.execute(type:, value: '3')
end
new_engine.execute(type: 'end_turn', value: '3')
new_engine.gameplay_data.current_player.deck.active.map { |card| card['name'] }.each do |type|
  new_engine.execute(type:, value: '3')
end
# new_engine.execute(type: 'move', value: '2')
player = new_engine.gameplay_data.current_player
