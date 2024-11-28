# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clank::CalculateVictoryPoints do
  let(:gameplay_data) { JSON.parse(file_fixture('clank/new_game.json').read) }
  subject(:calculator) { described_class.new(Clank::Model::Game.from_json(gameplay_data)) }

  describe '#execute!' do
    it 'calculates victory points' do
      calculator.execute!
      expect(calculator.gameplay_data.results).to contain_exactly([{ name: 'coins', points: 7 }],
                                                                   [{ name: 'coins', points: 7 }],
                                                                   { name: 'mastery_token', points: 20 })
      expect(calculator.gameplay_data.players.first.victory_points).to eq(27)
    end
  end
end
