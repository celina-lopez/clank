# frozen_string_literal: true

class AeonsEnd::Model::Deck < Model::Deck
  def reload_deck
    self.deck = discarded
    self.discarded = []
  end
end
