# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_view_path, only: %i[new index]

  def create
    engine = Engine.new
    gameplay_data = engine.execute(type: 'start_game', value: game_params[:number_of_players])
    game = Game.create!(
      data: JSON.parse(gameplay_data.to_json),
      history: engine.history,
      title: game_params[:title]
    )
    redirect_to clank_game_path(game) # TODO: fix to specific game
  end

  private

  def game_params
    params.require(:game).permit(:number_of_players, :title)
  end

  def set_view_path
    prepend_view_path Rails.root.join('app', 'views', 'games')
  end
end
