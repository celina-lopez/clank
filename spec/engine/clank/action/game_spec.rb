require 'rails_helper'

RSpec.describe Clank::Action::Game do
  subject(:base) { Clank::Action::Game.new(Clank::Model::Game.from_json(gameplay_data), type:, value:) }
  let(:type) { 'burgle' }
  let(:value) { 1 }

  let(:gameplay_data) { JSON.parse(file_fixture('clank/new_game.json').read) }

  describe '#end_turn' do
    it 'calls next_player! and reload_active_deck' do
      expect(subject.gameplay_data).to receive(:next_player!).and_call_original
      expect(subject).to receive(:fullfill_immediate_actions).and_call_original
      subject.end_turn
    end

    context 'end game with one player' do
      context 'when game is finished' do
        before do
          gameplay_data['players'] = [gameplay_data['players'][0]]
          gameplay_data['players'][0]['position']['current_position'] = 0
          gameplay_data['players'][0]['inventory'] = [{ 'is_artifact' => true }]
        end

        it 'ends the game when there is only one player left' do
          expect(subject).to receive(:end_game!).and_call_original
          subject.end_turn
          expect(subject.gameplay_data.end_game).to be_truthy
        end
      end

      context 'when game is not finished' do
        before do
          gameplay_data['players'][1]['position']['current_position'] = 0
          gameplay_data['players'][1]['inventory'] = [{ 'is_artifact' => true }]
        end
        it 'decreases the current player’s position and triggers dragon attack if not on end tile' do
          expect(subject).to receive(:dragon_attack!).and_call_original
          subject.end_turn
          expect(subject.gameplay_data.players[1].position.current_position).to eq(-1)
        end
      end

      context 'ends game when player is on ending tile' do
        before do
          gameplay_data['players'][1]['position']['current_position'] = -3
          gameplay_data['players'][1]['inventory'] = [{ 'is_artifact' => true }]
        end
        it 'decreases the current player’s position and triggers dragon attack if not on end tile' do
          subject.end_turn
          expect(subject.gameplay_data.end_game).to be_truthy
        end
      end
    end
  end

  describe '#dragon_attack!' do
    let(:player) { subject.gameplay_data.players[0] }

    it 'reduces dragon clank if hit by dragon' do
      allow_any_instance_of(Array).to receive(:sample).and_return([-1, 0])
      expect(subject.gameplay_data.dragon).to receive(:clank=).with(23)
      expect(player).to receive(:clank=).with(2)
      subject.dragon_attack!
    end

    it 'logs dragon clank events to history' do
      expect { subject.dragon_attack! }.to change { subject.history.size }.by(3)
    end
  end

  describe '#increase_dragon' do
    it 'increases the dragon position by 1' do
      expect { subject.increase_dragon }.to change { subject.gameplay_data.dragon.position }.by(1)
    end
  end
end
