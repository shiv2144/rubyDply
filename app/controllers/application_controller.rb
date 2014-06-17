class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::StrongParameters
  include ActionController::ImplicitRender
  include CanCan::ControllerAdditions

  before_filter :set_default_response_format

  # Handle authorization exception from CanCan
  rescue_from CanCan::AccessDenied do |exception|
    render json: {errors: ["Insufficient privileges"]}, status: :forbidden
  end

  # Handle RecordNotFound errors
  # rescue_from ActiveRecord::RecordNotFound do |exception|
  #   render json: {errors: [exception.message]}, status: :unprocessable_entity
  # end

  rescue_from(ActionController::ParameterMissing) do |exception|
    # render :text => "Required parameter missing: #{exception.param}", :status => :bad_request
    render json: {errors: [exception.message]}, status: :unprocessable_entity
  end

  # http://joshsymonds.com/blog/2012/08/13/dynamic-error-pages-corrected/
  unless Rails.application.config.consider_all_requests_local
    rescue_from Exception, with: :render_500
    rescue_from ActionController::RoutingError, with: :render_404
    rescue_from ActionController::UnknownController, with: :render_404
    rescue_from AbstractController::ActionNotFound, with: :render_404 # To prevent Rails 3.2.8 deprecation warnings
    rescue_from ActiveRecord::RecordNotFound, with: :render_404
  end


private

  def render_500(exception = nil)
    render_exception(500, exception.message, exception)
  end


  def render_404(exception = nil)
    render_exception(404, 'Page not found', exception)
  end

  def render_exception(status = 500, message = 'Server error', exception)
    @status = status
    @message = message

    if exception
      Rails.logger.fatal "\n#{exception.class.to_s} (#{exception.message})"
      Rails.logger.fatal exception.backtrace.join("\n")
    else
      Rails.logger.fatal "No route matches [#{env['REQUEST_METHOD']}] #{env['PATH_INFO'].inspect}"
    end

    # render template: "errors/error", formats: [:html], layout: 'application', status: @status
    render json: {errors: [message]}, status: status
  end

  def set_default_response_format
    request.format = :json
  end

end
