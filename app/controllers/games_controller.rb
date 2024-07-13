# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_view_path, only: %i[new index]

  def new
    @game = Game.new
  end

  def create
    engine = Engine.new
    gameplay_data = engine.execute(type: 'start_game', value: game_params[:number_of_players])
    game = Game.create!(
      data: JSON.parse(gameplay_data.to_json),
      history: engine.history,
      title: game_params[:title],
      game_type: game_params[:game_type]
    )
    redirect_to path_for(game)
  end

  private

  def path_for(game)
    "/#{game.game_type}/games/#{game.id}"
  end

  def game_params
    params.require(:game).permit(:number_of_players, :title, :game_type)
  end

  def set_view_path
    prepend_view_path Rails.root.join('app', 'views', 'games')
  end
end
