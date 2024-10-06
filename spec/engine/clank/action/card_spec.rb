# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clank::Action::Card do
  subject(:base) { described_class.new(Clank::Model::Game.from_json(gameplay_data), type:, value:) }
  let(:type) { 'burgle' }
  let(:value) { 1 }

  let(:gameplay_data) { JSON.parse(file_fixture('clank/new_game.json').read) }

  shared_examples 'a card action' do |type|
    let(:value) { 5 }
    it 'returns the gameplay data' do
      expect { base.send(type) }.to change { base.current_player.send(type) }.by(5)
    end
  end

  shared_examples 'a card action, true/falsey' do |type|
    let(:value) { true }
    it 'returns the gameplay data' do
      expect { base.send(type) }.to change { base.current_player.send(type) }.from(false).to(true)
    end
  end

  it_behaves_like 'a card action', :coins
  it_behaves_like 'a card action', :clank
  it_behaves_like 'a card action', :replace_card_points
  it_behaves_like 'a card action', :discard_number
  it_behaves_like 'a card action, true/falsey', :ignore_monster_path
  it_behaves_like 'a card action, true/falsey', :skip_crystal_cave

  context '#dragon_attack' do
    it 'updates history and attacks' do
      base.dragon_attack
      expect(base.history.size).to eql(4)
      expect(base.history.first[:type]).to eql('dragon_attack')
    end
  end

  context '#other_clank' do
    it 'updates clank' do
      expect { base.other_clank }.to change { base.gameplay_data.players[1].clank }.from(2).to(3)
    end
  end

  context '#dragon_clank' do
    let(:value) { -1 }
    it 'updates clank' do
      expect { base.dragon_clank }.to change { base.gameplay_data.dragon.clank }.by(-1)
    end
  end

  context '#trash_options' do
    let(:value) { -1 }
    it 'updates trash options' do
      expect { base.trash_options }.to change { base.current_player.trash_options }.from([]).to([-1])
    end
  end
end
