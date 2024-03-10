class Deck
  attr_accessor :cards

  def initialize(cards)
    @cards = cards
  end

  def shuffle
    @cards.shuffle!
  end

  def draw(number = 1)
    @cards.pop(number)
    # TODO: if less than number than reshuffle discard and deal
  end

  def self.from_yaml(type)
    cards = load_deck(type).flat_map do |card|
      card['total'].times.map do
        Card.from_yaml(card)
      end
    end

    new(cards)
  end

  def self.load_deck(type) # rubocop:disable Metrics/MethodLength
    deck = []
    case type
    when :starter
      deck << YAML.load_file('config/game/starting_deck.yml')
    when :reserve
      deck << YAML.load_file('config/game/reserves.yml')
    when :miscellaneous
      deck << YAML.load_file('config/game/gems.yml')
      deck << YAML.load_file('config/game/devices.yml')
      deck << YAML.load_file('config/game/items.yml')
      deck << YAML.load_file('config/game/monsters.yml')
      deck << YAML.load_file('config/game/companions.yml')
    end
    deck
  end
end
