# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Action::Base do
  subject(:base) { Clank::Action::Card.new(gameplay_data, type:, value: '') }

  let(:gameplay_data) { JSON.parse(file_fixture('clank/new_game.json').read) }

  describe '#card' do
    let(:type) { 'burgle' }
    it 'returns the card data' do
      expect(base.card['name']).to eq(type)
    end
  end
end

class Action::Card < Action::Base
  def execute!
    if card.nil?
      send(type)
      return gameplay_data
    end
    redeem_card_rewards
  end

  %i[cards health attack_points move_points skill_points].each do |type|
    define_method(type) do |v = value|
      history << { type:, value: v, player_index: current_player_index }
      current_player.public_send("#{type}=", current_player.public_send(type) + v)
    end
  end

  def draw(val = value)
    current_player.deck.draw(val)
  end
end
