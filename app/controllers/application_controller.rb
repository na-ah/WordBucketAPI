class ApplicationController < ActionController::API
  before_action :snake2camel_params

  def snake2camel_params
    params.deep_transform_keys!(&:underscore)
  end
end
