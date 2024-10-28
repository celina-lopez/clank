# frozen_string_literal: true

def config_yaml(name)
  YAML.load_file(Rails.root.join('config', 'game', 'aeons_end', "#{name}.yml"))
end

class AeonsEnd::Base < Base
  STARTING_DECK_CARDS = config_yaml('starting_deck').freeze
  MARKETPLACE = config_yaml('marketplace').freeze
  MONSTER_CARDS = config_yaml('monster_cards').freeze
end
