# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Action::Game do
  subject(:base) { Clank::Action::Game.new({}, type: 'start_game', value:) }
  let(:value) { { players: %w[marisa celina], map_type: 'map_1' } }

  describe '#start_game' do
    it 'returns the gameplay data' do
      base.start_game
      expect(base.gameplay_data.players.size).to eq(2)
      expect(base.gameplay_data.players.map(&:name)).to contain_exactly('marisa', 'celina')
    end
  end
end
