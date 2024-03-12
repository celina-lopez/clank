# frozen_string_literal: true

class Executeable
  PLAYER_ACTIONS = %i[
    attack
    buy_artifact
    move
    teleport
    buy_card
  ].freeze

  CARD_ACTIONS = %i[
    add_teleport
    add_attack_points
    add_clank
    add_coins
    add_move_points
    add_health
    remove_clank
  ].freeze

  GAME_ACTIONS = %i[
    end_turn
    start_game
  ].freeze
  ACTIONS = PLAYER_ACTIONS + CARD_ACTIONS + GAME_ACTIONS
end
