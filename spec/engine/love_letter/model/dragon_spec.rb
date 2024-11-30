# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clank::Model::Dragon do
  let(:json_data) { { clank: 10, position: 3, num_players: 3 } }
  let(:dragon) { described_class.new(clank: 10, position: 3, num_players: 3) }

  describe '.from_json' do
    it 'creates a new Dragon instance from JSON' do
      dragon_instance = described_class.from_json(json_data)
      expect(dragon_instance.clank).to eq(10)
      expect(dragon_instance.position).to eq(1) # based on num_players logic
    end
  end

  describe '#initialize' do
    context 'with num_players 3' do
      it 'sets position based on the number of players' do
        expect(dragon.position).to eq(1)
      end
    end

    context 'with no num_players' do
      let(:dragon) { described_class.new(clank: 10, position: 3) }

      it 'sets position as provided' do
        expect(dragon.position).to eq(3)
      end
    end
  end

  describe '#clank=' do
    it 'caps the clank value at MAX_CLANK' do
      dragon.clank = 30
      expect(dragon.clank).to eq(Clank::Model::Dragon::MAX_CLANK)
    end
  end

  describe '#position=' do
    it 'caps the position value at the length of POSTION_ARRAY' do
      dragon.position = 10
      expect(dragon.position).to eq(Clank::Model::Dragon::POSTION_ARRAY.length - 1)
    end
  end

  describe '#num_of_hits' do
    it 'returns the correct number of hits based on position' do
      expect(dragon.num_of_hits).to eq(Clank::Model::Dragon::POSTION_ARRAY[dragon.position])
    end
  end
end
