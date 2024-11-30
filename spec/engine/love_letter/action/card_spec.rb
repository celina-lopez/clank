# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LoveLetter::Action::Card do
  subject(:base) { described_class.new(LoveLetter::Model::Game.from_json(gameplay_data), type:, value:) }
  let(:type) { 'chancellor' }
  let(:value) { 1 }

  let(:gameplay_data) { JSON.parse(file_fixture('love_letter/new_game.json').read) }

  it 'plays the princess' do
    expect(base).to receive(:immediately_end_turn).and_call_original
    expect { base.princess }.to change { base.gameplay_data.players[0].removed_from_round }
      .from(false).to(true)
  end

  it 'plays the spy' do
    expect(base).to receive(:immediately_end_turn).and_call_original
    base.spy
  end

  it 'plays the countess' do
    expect(base).to receive(:immediately_end_turn).and_call_original
    base.countess
  end

  it 'plays the king' do
    expect { base.king }.to change { base.gameplay_data.players[0].trade_card_points }.from(0).to(1)
  end

  it 'plays the chancellor' do
    expect { base.chancellor }.to change { base.gameplay_data.players[0].deck.active.size }.by(2)
  end

  it 'plays the prince' do
    expect { base.prince }.to change { base.gameplay_data.players[0].choose_player_to_discard_points }.from(0).to(1)
  end

  it 'plays the handmaid' do
    expect(base).to receive(:immediately_end_turn).and_call_original
    expect { base.handmaid }.to change { base.gameplay_data.players[0].protected_from_discard }.from(false).to(true)
  end

  it 'plays the baron' do
    expect { base.baron }.to change { base.gameplay_data.players[0].choose_player_to_compare_points }.from(0).to(1)
  end

  it 'plays the priest' do
    expect { base.priest }.to change { base.gameplay_data.players[0].choose_player_to_reveal_card }.from(0).to(1)
  end

  it 'plays the guard' do
    expect { base.guard }.to change { base.gameplay_data.players[0].choose_player_to_guess_card }.from(0).to(1)
  end
end
