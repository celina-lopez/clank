# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clank::Validation::Game do
  let(:gameplay_data) { JSON.parse(file_fixture('clank/new_game.json').read) }
  subject(:validator) do
    described_class.new(Clank::Model::Game.from_json(gameplay_data), type:, value: nil, player_index:)
  end
  let(:player_index) { 0 }

  describe '#end_turn?' do
    let(:type) { 'end_turn' }
    context 'when the game has ended' do
      before do
        gameplay_data['end_game'] = true
        gameplay_data['players'][0]['deck']['active'] = []
        gameplay_data['players'][0]['rewards'] = []
      end
      it 'returns false and adds an error message' do
        expect(validator).to receive(:add_error_if_error).with('Your game has ended', false).and_call_original
        expect(validator).to receive(:add_error_if_error).with('You must play all your cards in your hand',
                                                                true).and_call_original
        result = validator.end_turn?
        expect(result).to be(false)
      end
    end

    context 'when active deck is not empty' do
      it 'returns false and adds an error message about playing all cards' do
        expect(validator).to receive(:add_error_if_error).with('Your game has ended', true).and_call_original
        expect(validator).to receive(:add_error_if_error).with('You must play all your cards in your hand',
                                                                false).and_call_original
        result = validator.end_turn?
        expect(result).to be(false)
      end
    end

    context 'when rewards are not empty' do
      before do
        gameplay_data['players'][0]['deck']['active'] = []
        gameplay_data['players'][0]['rewards'] = ['card']
      end

      it 'returns false and adds an error message about collecting all rewards' do
        expect(validator).to receive(:add_error_if_error).with('Your game has ended', true).and_call_original
        expect(validator).to receive(:add_error_if_error).with('You must play all your cards in your hand',
                                                               true).and_call_original
        expect(validator).to receive(:add_error_if_error).with('You must collect all your rewards',
                                                               false).and_call_original
        result = validator.end_turn?
        expect(result).to be(false)
      end
    end

    context 'when the game has not ended, all cards are played, and all rewards are collected' do
      before do
        gameplay_data['players'][0]['deck']['active'] = []
      end
      it 'returns true without errors' do
        expect(validator).to receive(:add_error_if_error).with('Your game has ended', true).and_call_original
        expect(validator).to receive(:add_error_if_error).with('You must play all your cards in your hand',
                                                               true).and_call_original
        expect(validator).to receive(:add_error_if_error).with('You must collect all your rewards',
                                                               true).and_call_original
        result = validator.end_turn?
        expect(result).to be(true)
      end
    end
  end
end
