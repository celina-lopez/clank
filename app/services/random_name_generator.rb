# frozen_string_literal: true

class RandomNameGenerator
  GAME_ADJECTIVES = %w[Legendary Epic Cunning Stealthy Fierce Enchanted Heroic Mystical Relentless Swift].freeze
  GAME_NOUNS = %w[Dragons Knights Mages Rogues Goblins Trolls Wizards Rangers Clerics Barbarians].freeze
  NAME_FIRST = %w[Ashen Thunder Ember Frost Shadow Iron Storm Blaze Silver Dark Wild].freeze
  NAME_SECOND = %w[blade heart shade song claw bane fist stone seeker whisper forge].freeze

  def self.game_name
    adjective = GAME_ADJECTIVES.sample
    noun = GAME_NOUNS.sample
    "#{adjective} #{noun}"
  end

  def self.character_name
    first = NAME_FIRST.sample
    second = NAME_SECOND.sample
    "#{first}#{second}"
  end
end
