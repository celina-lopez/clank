# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clank::Validation::Player do
  let(:gameplay_data) { JSON.parse(file_fixture('clank/new_game.json').read) }
  let(:value) { '' }
  subject(:validator) do
    described_class.new(Clank::Model::Game.from_json(gameplay_data), player_index: 0, type:, value:)
  end

  describe '#redeem_reward?' do
    let(:type) { 'redeem_reward' }
    let(:value) { '0' }
    it 'returns false and adds an error when reward is invalid' do
      expect(validator).to receive(:add_error_if_error).with('Invalid format', false)
      validator.redeem_reward?
    end
  end

  describe '#buy?' do
    let(:type) { 'buy' }
    before do
      gameplay_data['players'][0]['coins'] = 4
      gameplay_data['players'][0]['position']['current_position'] = 18
    end
    it 'returns false if player is not in marketplace or does not have enough coins' do
      expect(validator).to receive(:add_error_if_error).with('Not in marketplace', true).and_call_original
      expect(validator).to receive(:add_error_if_error).with('Need 3 coins', false).and_call_original
      validator.buy?
    end
  end

  describe '#buy_card?' do
    let(:type) { 'buy_card' }
    context 'when player has enough skill points' do
      let(:value) { 'brilliance' }
      it 'validates buy card process successfully' do
        expect { validator.valid? }.to raise_error(Validation::Base::InvalidMoveError, 'Need 6 more skill points')
      end
    end

    context 'when player has enough attack points' do
      let(:value) { 'goblin' }
      it 'validates buy card process successfully' do
        expect { validator.valid? }.to raise_error(Validation::Base::InvalidMoveError, 'Need 2 more attack points')
      end
    end

    context 'when player doesnt meet conditions' do
      let(:value) { 'the_vault' }
      before do
        gameplay_data['players'][0]['skill_points'] = 6
      end
      it 'validates buy card process successfully' do
        expect { validator.valid? }.to raise_error(Validation::Base::InvalidMoveError, 'Not in Depths')
      end
    end

    context 'when player meets conditions' do
      let(:value) { 'brilliance' }
      before do
        gameplay_data['players'][0]['skill_points'] = 6
      end
      it 'validates buy card process successfully' do
        expect(validator.valid?).to be_truthy
      end
    end
  end

  describe '#move?' do
    let(:type) { 'move' }
    let(:value) { '1' }
    context 'valid' do
      before do
        gameplay_data['players'][0]['move_points'] = 1
      end
      it 'returns true' do
        expect(validator).to receive(:add_error_if_error).with('Please choose adjacent tile', true).and_call_original
        expect(validator).to receive(:add_error_if_error).with('Cant move if you been in a crystal cave',
                                                               true).and_call_original
        expect(validator).to receive(:add_error_if_error).with('Not enough move points', true).and_call_original
        expect(validator).to receive(:add_error_if_error).with("Player doesn't have enough health",
                                                               true).and_call_original
        expect(validator.move?).to be(true)
      end
    end

    context 'invalid - not adjacent' do
      let(:value) { '2' }
      it 'returns false' do
        expect(validator).to receive(:add_error_if_error).with('Please choose adjacent tile', false).and_call_original
        expect(validator.move?).to be(false)
      end
    end
    context 'invalid - been in a crystal cave' do
      before do
        gameplay_data['players'][0]['moved_to_crystal_cave'] = true
        gameplay_data['players'][0]['move_points'] = 1
      end
      it 'returns false' do
        expect(validator).to receive(:add_error_if_error).with('Please choose adjacent tile', true).and_call_original
        expect(validator).to receive(:add_error_if_error).with('Cant move if you been in a crystal cave',
                                                               false).and_call_original
        expect(validator).to receive(:add_error_if_error).with(
          'Not enough move points', true
        ).and_call_original
        expect(validator).to receive(:add_error_if_error).with("Player doesn't have enough health",
                                                               true).and_call_original
        expect(validator.move?).to be(false)
      end
    end

    context 'invalid - trying to escape without an artifact' do
      let(:value) { '0' }
      before do
        gameplay_data['players'][0]['position']['current_position'] = 1
        gameplay_data['players'][0]['move_points'] = 1
      end
      it 'returns false' do
        expect(validator).to receive(:add_error_if_error).with('Please choose adjacent tile', true).and_call_original
        expect(validator).to receive(:add_error_if_error).with('You dont have an artifact', false).and_call_original
        expect(validator).to receive(:add_error_if_error).with('Cant move if you been in a crystal cave',
                                                               true).and_call_original
        expect(validator).to receive(:add_error_if_error).with('Not enough move points', true).and_call_original
        expect(validator).to receive(:add_error_if_error).with("Player doesn't have enough health",
                                                               true).and_call_original
        expect(validator.move?).to be(false)
      end
    end
  end

  describe '#trash?' do
    let(:type) { 'trash' }
    let(:value) { 'burgle,active' }
    context 'when trash option is certain cards' do
        before do
          gameplay_data['players'][0]['trash_options'] = [{ 'burgle' => 1 }]
        end
        context 'when valid' do
          it 'finds the card and is valid' do
            expect(validator).to receive(:add_error_if_error).with('Trash option not found', true).and_call_original
            expect(validator).to receive(:add_error_if_error).with('Card not found', true).and_call_original
            validator.trash?
          end
        end
        context 'when card is not valid' do
          let(:value) { 'some_card' }
          it 'finds the card and is invalid' do
            expect(validator).to receive(:add_error_if_error).with('Trash option not found', false).and_call_original
            validator.trash?
          end
        end
    end
  end

  describe '#replace_card?' do
    let(:type) { 'replace_card' }
    it 'returns false if player has no replace card points' do
      expect(validator).to receive(:add_error_if_error).with('Not enough replace_card points', false).and_call_original
      validator.replace_card?
    end

    context 'when player has replace card points but card not found' do
      before do
        gameplay_data['players'][0]['replace_card_points'] = 1
      end
      it 'returns false' do
        expect(validator).to receive(:add_error_if_error).with('Not enough replace_card points', true).and_call_original
        expect(validator).to receive(:add_error_if_error).with('Card not found', false).and_call_original
        validator.replace_card?
      end
    end

    context 'passes' do
      let(:value) { 'brilliance' }
      before do
        gameplay_data['players'][0]['replace_card_points'] = 1
      end
      it 'returns true' do
        expect(validator).to receive(:add_error_if_error).with('Not enough replace_card points', true).and_call_original
        expect(validator).to receive(:add_error_if_error).with('Card not found', true).and_call_original
        expect(validator.replace_card?).to be(true)
      end
    end
  end

  describe '#redeem_inventory_item?' do
    let(:type) { 'redeem_inventory_item' }
    let(:value) { 'item' }

    it 'returns false if item is not found in inventory' do
      expect(validator).to receive(:add_error_if_error).with('Card not found', false).and_call_original
      validator.redeem_inventory_item?
    end

    context 'item is found with actionable' do
      before do
        gameplay_data['players'][0]['inventory'] = [{ 'name' => value, 'action' => 'actionable' }]
      end
      it 'returns false if item is not actionable' do
        expect(validator).to receive(:add_error_if_error).with('Card not found', true).and_call_original
        expect(validator).to receive(:add_error_if_error).with('Card is not actionable', true).and_call_original
        validator.redeem_inventory_item?
      end
    end
  end

  describe '#buy_artifact?' do
    let(:marketplace_item) { { 'name' => 'artifact' } }
    let(:type) { 'buy_artifact' }
    let(:value) { 'artifact' }
    before do
      gameplay_data['marketplace_items'] = [marketplace_item]
      gameplay_data['players'][0]['coins'] = 7
    end

    it 'returns true if artifact is found and player has enough coins' do
      expect(validator).to receive(:add_error_if_error).with('artifact not found', true).and_call_original
      expect(validator).to receive(:add_error_if_error).with('Cant afford', true).and_call_original
      validator.buy_artifact?
    end

    context 'when artifact is not found' do
      before do
        gameplay_data['marketplace_items'] = []
      end
      it 'returns false' do
        expect(validator).to receive(:add_error_if_error).with('artifact not found', false).and_call_original
        expect(validator.buy_artifact?).to be(false)
      end
    end
  end
end
