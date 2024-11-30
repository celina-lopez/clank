require 'rails_helper'

RSpec.describe LoveLetter::Action::Game do
  subject(:base) { LoveLetter::Action::Game.new(LoveLetter::Model::Game.from_json(gameplay_data), type:, value:) }
  let(:type) { 'burgle' }
  let(:value) { 1 }

  let(:gameplay_data) { JSON.parse(file_fixture('love_letter/new_game.json').read) }

  describe '#end_turn' do
    it 'calls next_player! and reload_active_deck' do
      expect(subject.gameplay_data).to receive(:next_player!).and_call_original
      subject.end_turn
      expect(subject.current_player.deck.active.size).to eq(2)
    end

    context 'when game is finished' do
      before do
        gameplay_data['deck']['deck'] = []
      end

      it 'ends the game' do
        expect(subject).to receive(:end_of_round!).and_call_original
        subject.end_turn
      end
    end
  end
end
