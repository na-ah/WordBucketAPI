class Words::HistoriesController < ApplicationController
  before_action :find_word
  before_action :find_history, only: [:show,  :update, :destroy]

  def index
    render json: { histories: @word.histories }, status: 200
  end

  def show
    render json: { history: @history.as_json }, status: 200
  end

  def create
    history = @word.histories.build(history_params)

    if history.save
      render json: { history: history.as_json }, status: 200
    else
      render json: { error: history.errors }, status: 400
    end
  end

  def update
    if @history.update(history_params)
      render json: { data: @history }, status: 200
    else
      render json: { error: @history.errors }, status: 400
    end
  end

  def destroy
    @history.destroy
    render json: { message: 'History deleted successfully' }, status: 200
  end

  private

  def history_params
    params.permit(:duration, :result, :datetime)
  end

  def find_word
    @word = Word.find_by(id: params[:word_id])

    unless @word
      render json: { error: 'Word not found' }, status: 404
    end
  end

  def find_history
    @history = @word.histories.find_by(id: params[:id])
    render json: { error: 'History not found' }, status: 400 unless @history
  end
end
