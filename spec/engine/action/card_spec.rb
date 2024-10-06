# rubocop:disable Metrics/BlockLength
# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Action::Card do
  subject(:base) { Clank::Action::Card.new(Clank::Model::Game.from_json(gameplay_data), type:, value:) }
  let(:type) { 'burgle' }
  let(:value) { 1 }

  let(:gameplay_data) { JSON.parse(file_fixture('clank/new_game.json').read) }

  describe '#card' do
    it 'returns the card data' do
      expect(base.card['name']).to eq(type)
    end
  end
  shared_examples 'a card action' do |type, val = 5|
    let(:value) { val }
    it 'returns the gameplay data' do
      base.send type
      expect(base.current_player.send(type)).to eq(5)
    end
  end
  it_behaves_like 'a card action', :health, -5
  it_behaves_like 'a card action', :attack_points
  it_behaves_like 'a card action', :move_points
  it_behaves_like 'a card action', :skill_points

  context '#draw' do
    let(:type) { 'draw' }
    let(:value) { 1 }
    it 'draws cards' do
      expect { base.send type }.to change { base.current_player.deck.active.size }.by(1)
    end
  end
end

# rubocop:enable Metrics/BlockLength
