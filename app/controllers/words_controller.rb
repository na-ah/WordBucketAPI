class WordsController < ApplicationController
  def index
    words = Word.includes(:meanings, :examples).map do |word|
      word.as_json.merge({
        meanings: word.meanings.pluck(:meaning),
        examples: word.examples.pluck(:example)
      })
    end

    render json: {words: words}, status: 200
  end

  def show
    word = Word.find_by(id: params[:id])
    if word
      word_json = word.as_json
      word_json[:meanings] = word.meanings.map(&:meaning)
      word_json[:examples] = word.examples.map(&:example)
      render json: {word: word_json}, status: 200
    else
      render json: { error: 'Word not found' }, status: 404
    end

  end

  def create
    word = Word.new(word_params)

    if word.save
      render json: {data: word}, status: 200
    else
      render json: { errors: word.errors }, status: 400
    end
  end

  def update
    word = Word.find_by(id: params[:id])

    unless word
      render json: { message: 'Word not found' }, status: 404
    end

    ActiveRecord::Base.transaction do
      if params[:meaning].present?
        word.meanings.find_or_create_by(meaning: meaning_params[:meaning])
      end

      if params[:example].present?
        word.examples.find_or_create_by(example: example_params[:example])
      end

      if word.update(word_params)
        word_json = word.as_json.merge({
            meanings: word.meanings.pluck(:meaning),
            examples: word.examples.pluck(:example)
          })
        render json: {word: word_json}, status: 200
      else
        render json: { errors: word.errors }, status: 400
      end
    end
  end

  def destroy
    word = Word.find_by(id: params[:id])

    if word
      word.destroy
      render json: { message: 'Word deleted successfully' }, status: 200
    else
      render json: { error: 'Word not found' }, status: 404
    end
  end

  private

  def word_params
    params.permit(:word)
  end

  def example_params
    params.permit(:example)
  end

  def meaning_params
    params.permit(:meaning)
  end

end
