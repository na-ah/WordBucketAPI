class Words::MeaningsController < ApplicationController
  def index
    word = Word.find_by(id: params[:word_id])

    if word
      meanings = word.meanings
      render json: { meanings: meanings }, status: 200
    else
      render json: { error: "word not found" }, status: 404
    end
  end

  def show
    word = Word.find_by(id: params[:word_id])
    unless word
      render json: { error: word.errors }, status: 400
    end

    meaning = word.meanings.find_by(id: params[:id])
    if meaning
      render json: { meaning: meaning }, status: 200
    else
      render json: { error: meaning.errors }, status: 400
    end
  end

  def create
    word = Word.find_by(id: params[:word_id])
    meaning = word.meanings.find_or_initialize_by(meaning_params)

    if meaning.save
      render json: { word: word.as_json.merge(meanings: word.meanings.as_json) }, status: 200
    else
      render json: { error: meaning.errors }, status: 400
    end
  end

  def update
    word = Word.find_by(id: params[:word_id])

    unless word
      render json: { error: "Word not found" }, status: 404
    end

    meaning = word.meanings.find_by(id: params[:id])

    if meaning.update(meaning_params)
      # render json: { data: meaning }, status: 200
      render json: { word: word.as_json.merge(meanings: word.meanings.as_json) }, status: 200
    else
      render json: { error: meaning.errors }, status: 400
    end
  end

  def destroy
    word = Word.find_by(id: params[:word_id])

    unless word
      render json: { error: word.errors }, status: 400
    end

    meaning = word.meanings.find_by(id: params[:id])

    if meaning
      meaning.destroy
      render json: { message: "Meaning deleted successfully" }, status: 200
    else
      render json: { error: "Meaning not found" }, status: 404
    end
  end

  private

  def meaning_params
    params.permit(:meaning)
  end
end
