class Words::ExamplesController < ApplicationController
  def index
    word = Word.find_by(id: params[:word_id])

    if word
      examples = word.examples
      render json: { examples: examples }, status: 200
    else
      render json: { error: "word not found" }, status: 404
    end
  end

  def show
    word = Word.find_by(id: params[:word_id])
    unless word
      render json: { error: word.errors }, status: 400
    end

    example = word.examples.find_by(id: params[:id])
    if example
      render json: { example: example }, status: 200
    else
      render json: { error: example.errors }, status: 400
    end
  end

  def create
    word = Word.find_by(id: params[:word_id])
    example = word.examples.find_or_initialize_by(example_params)

    if example.save
      render json: { message: 'Example has successfully created' }, status: 200
    else
      render json: { error: example.errors }, status: 400
    end
  end

  def update
    word = Word.find_by(id: params[:word_id])

    unless word
      render json: { error: 'Word not found' }, status: 404
    end

    example = word.examples.find_by(id: params[:id] )

    if example.update(example_params)
      render json: { data: example }, status: 200
    else
      render json: { error: example.errors }, status: 400
    end
  end

  def destroy
    word = Word.find_by(id: params[:word_id])

    unless word
      render json: { error: word.errors }, status: 400
    end

    example = word.examples.find_by(id: params[:id])

    if example
      example.destroy
      render json: { message: 'Example deleted successfully' }, status: 200
    else
      render json: { error: 'Example not found'}, status: 404
    end
  end

  private

  def example_params
    params.permit(:example)
  end
end
