# JSON-encoded error and redirect results for Devise controllers.
# This overrides an internal method of Devise, so be careful when updating Devise!
#
# Usage:
#
# class Users::RegistrationsController < Devise::RegistrationsController
#   include DeviseJsonAdapter
# end
#
# devise_for :users, :controllers => { :registrations => "users/registrations" }
module DeviseJsonAdapter
  protected

  # Handle JSON registration errors.
  #
  def render_with_scope(action, options={})
    respond_to do |format|
      format.html { super }
      format.json do
        if resource.errors
          render_json_errors(resource, resource_name)
        end
      end
    end
  end

  # Since XMLHttpRequest can't see redirects, we replace redirects with a JSON
  # response of {redirect: url}.
  #
  def redirect_to(*args)
    respond_to do |format|
      format.html { super }
      format.json do
        render :json => {:redirect => stored_location_for(resource_name) || after_sign_in_path_for(resource)}
      end
    end
  end

  # Convert ActiveModel errors into JSON so they can be rendered client-side.
  # Result is {errors: {'name': 'message', ...}} which is suitable for passing to
  # jQuery.validate's formErrors method.
  #
  def render_json_errors(model, model_name = nil)
    model_name ||= model.class.name.underscore

    # Map the error keys into standard HTML element names (e.g., :password -> 'user[password]')
    form_errors = Hash[model.errors.collect { |attr, msg| ["#{model_name}[#{attr}]", msg] }].uniq

    render :status => :unprocessable_entity, :json => {:errors => form_errors}
  end
end
