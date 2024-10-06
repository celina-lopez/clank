# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Clank::Model::Dragon do
  subject(:base) { described_class.from_json(gameplay_data) }

  let(:gameplay_data) { JSON.parse(file_fixture('clank/new_game.json').read) }
  pending '#clank'
  pending '#position'
  pending '#play_all_cards'
  pending '#num_of_hits'
end
