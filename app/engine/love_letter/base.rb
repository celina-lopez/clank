# frozen_string_literal: true

def config_yaml(name)
  YAML.load_file(Rails.root.join('config', 'game', 'love_letter', "#{name}.yml"))
end

class Clank::Base < Base
  CARDS = config_yaml('cards').freeze
  CARD_NAMES = CARDS.map { |c| c['name'] }.freeze
end
