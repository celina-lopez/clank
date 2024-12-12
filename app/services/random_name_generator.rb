# frozen_string_literal: true

class RandomNameGenerator
  GAME_ADJECTIVES = %w[Legendary Epic Cunning Stealthy Fierce Enchanted Heroic Mystical Relentless Swift].freeze
  GAME_NOUNS = %w[Dragons Knights Mages Rogues Goblins Trolls Wizards Rangers Clerics Barbarians].freeze
  FANTASY_NAME_FIRST = %w[Ashen Thunder Ember Frost Shadow Iron Storm Blaze Silver Dark Wild].freeze
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
      first = "#{ROYAL_NAME_FIRST.sample} of "
      second = ROYAL_NAME_SECOND.sample
    end
    "#{first}#{second}"
  end
end
