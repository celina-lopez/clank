# frozen_string_literal: true

class RandomNameGenerator
  GAME_ADJECTIVES = %w[Legendary Epic Cunning Stealthy Fierce Enchanted Heroic Mystical Relentless Swift].freeze
  GAME_NOUNS = %w[Dragons Knights Mages Rogues Goblins Trolls Wizards Rangers Clerics Barbarians].freeze
  FANTASY_NAME_FIRST = ['Ashen of ', 'Thunder of ', 'Ember of ', 'Frost of ', 'Shadow of ', 'Iron of ', 'Storm of ',
                        'Blaze of ', 'Silver of ', 'Dark of ', 'Wild of '].freeze
  FANTASY_NAME_SECOND = %w[blade heart shade song claw bane fist stone seeker whisper forge].freeze
  ROYAL_NAME_FIRST = %w[King Queen Prince Princess Duke Earl Baron].freeze
  ROYAL_NAME_SECOND = %w[hearts shades songs whispers dreams stars secrets echoes frost embers twilighyt silence flames
                         shadows winds mirrors tides chains light ashes].freeze

  def self.game_name
    adjective = GAME_ADJECTIVES.sample
    noun = GAME_NOUNS.sample
    "#{adjective} #{noun}"
  end

  def self.character_name(theme = 'fantasy')
    if theme == 'fantasy'
      first = FANTASY_NAME_FIRST.sample
      second = FANTASY_NAME_SECOND.sample
    elsif theme == 'royal'
      first = ROYAL_NAME_FIRST.sample
      second = ROYAL_NAME_SECOND.sample
    end
    "#{first}#{second}"
  end
end
