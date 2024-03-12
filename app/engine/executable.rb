# frozen_string_literal: true

class Executeable
  PLAYER_ACTIONS = %i[
    attack
    buy
    move
    teleport
  ].freeze

  CARD_ACTIONS = %i[
    add_teleport
    add_attack_points
    add_clank
    remove_clank
    add_move_points
    heal
    increase_coins
  ].freeze

  GAME_ACTIONS = %i[
    end_turn
    start_game
  ].freeze
  ACTIONS = PLAYER_ACTIONS + CARD_ACTIONS + GAME_ACTIONS
end
