# class ExamplesController < ApplicationController
#   def index
#     examples = Example.all
#     render json: { examples: examples }
#   end

#   def show
#     example = Example.find_by(id: params[:id])
#     render json: { example: example }, status: 200
#   end

#   def create
#     example = Example.new(create_example_params)

#     if example.save
#       render json: {data: example}, status: 200
#     else
#       render json: {error: example.errors }, status: 400
#     end
#   end

#   def update
#     example = Example.find_by(id: params[:id])

#     if example.update(update_example_params)
#       render json: { data: example }, status: 200
#     else
#       render json: { error: example.errors }, status: 400
#     end
#   end

#   def destroy
#     example = Example.find_by(id: params[:id])

#     if example
#       example.destroy
#       render json: { message: 'Example deleted successfully' }, status: 200
#     else
#       render json: { error: 'Example not found' }, status: 404
#     end
#   end

#   private

#   def create_example_params
#     params.permit(:example, :word_id)
#   end

#   def update_example_params
#     params.permit(:example)
#   end
# end
