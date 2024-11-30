# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoveLetter::Action::Player do
  subject { described_class.new(LoveLetter::Model::Game.from_json(gameplay_data), type:, value:) }
  let(:type) { 'burgle' }
  let(:value) { '1' }

  let(:gameplay_data) { JSON.parse(file_fixture('love_letter/new_game.json').read) }

  xit '#trade_card' do
    deck_before = subject.gameplay_data.players[0].deck.active.dup

    subject.trade_card
    expect(subject.gameplay_data.players[0].deck.active).to contain_exactly(deck_before)
  end
  context '#keep_card' do
    let(:value) { 'chancellor' }
    it 'keeps the card and puts the other two at the bottom of the deck' do
      subject.keep_card
      expect(subject.gameplay_data.players[0].deck.active).to contain_exactly(hash_including({ 'name' => 'chancellor' }))
    end
  end

  context '#choose_player_to_discard' do
    let(:value) { '0' }
    it 'discards the chosen player\'s card and draws a new one' do
      subject.choose_player_to_discard
      expect(subject.gameplay_data.players[0].deck.active).to contain_exactly(hash_including({ 'name' => 'chancellor' }))
    end
  end

  pending '#choose_player_to_compare' do
    let(:value) { '0' }
    it 'compares the chosen player\'s card and draws a new one' do
      subject.choose_player_to_compare
      expect(subject.gameplay_data.players[0].deck.active).to contain_exactly(hash_including({ 'name' => 'chancellor' }))
    end
  end

  context '#choose_player_to_reveal' do
    it 'reveals the chosen player\'s card' do
      subject.choose_player_to_reveal
      expect(subject.gameplay_data.players[0].revealed_card_to_player[:index]).to eq(1)
    end
  end

  context '#choose_player_to_guess' do
    let(:value) { '0,chancellor' }
    it 'guesses the chosen player\'s card' do
      subject.choose_player_to_guess
      expect(subject.gameplay_data.players[0].removed_from_round).to eq(true)
    end
  end
end
