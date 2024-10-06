require 'rails_helper'

RSpec.describe Clank::Action::Game do
  subject(:base) { Clank::Action::Game.new(Clank::Model::Game.from_json(gameplay_data), type:, value:) }
  let(:type) { 'burgle' }
  let(:value) { 1 }

  let(:gameplay_data) { JSON.parse(file_fixture('clank/new_game.json').read) }

  describe '#end_turn' do
    before do
      allow(subject.gameplay_data.deck).to receive(:active).and_return([])
    end

    it 'calls next_player! and reload_active_deck' do
      expect(subject.gameplay_data).to receive(:next_player!)
      expect(subject).to receive(:fullfill_immediate_actions)
      subject.end_turn
    end

    context 'when current player is on escape tile and has artifact' do
      before do
        allow(subject.gameplay_data.players[1].position).to receive(:escape_tile?).and_return(true)
        allow(subject.gameplay_data.players[0]).to receive(:artifact?).and_return(true)
      end

      xit 'ends the game when there is only one player left' do
        allow(subject.gameplay_data.players).to receive(:size).and_return(1)
        expect(subject).to receive(:end_game!)
        subject.end_turn
      end

      xit 'decreases the current player’s position and triggers dragon attack if not on end tile' do
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
