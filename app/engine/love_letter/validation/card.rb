# frozen_string_literal: true

class LoveLetter::Validation::Card < Validation::Card
  def can_play
    true
  end
  alias princess? can_play
  alias spy? can_play
  alias countess? can_play
  alias chancellor? can_play
  alias handmaid? can_play
  alias baron? can_play
  alias priest? can_play
  alias guard? can_play

  def king?
    countess = current_player.deck.active.find { |card| card['name'] == 'countess' }
    add_error_if_error('You must play your Countess if you have a king.', countess.nil?)
  end

  alias prince? king?
end
