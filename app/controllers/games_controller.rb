# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_view_path, only: %i[new index]

  def new
    @game = Game.new
  end

  def create
    engine = Engine.new
    gameplay_data = engine.execute(type: 'start_game',
                                   value: game_params[:settings])
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
    "/#{game.game_type}/games/#{game.uuid}"
  end

  def game_params
    params[:game][:settings] ||= {}
    params[:game][:settings][:num_players] = params[:game][:number_of_players]
    params.require(:game).permit(
      :title,
      :game_type,
      settings: {}
    )
  end

  def set_view_path
    prepend_view_path Rails.root.join('app', 'views', 'games')
  end
end
