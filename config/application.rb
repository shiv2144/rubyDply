require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

# App CONFIG
CONFIG = YAML.load(File.read(File.expand_path('../config.yml', __FILE__)))
CONFIG.merge! CONFIG.fetch(Rails.env, {})
CONFIG.symbolize_keys!

module ChampApi
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Needed by Devise and Doorkeeper
    config.middleware.use ActionDispatch::Flash

    # Autoload lib files: http://stackoverflow.com/questions/19098663/auto-loading-lib-files-in-rails-4
    # config.autoload_paths += %W(#{config.root}/lib)
    config.autoload_paths += Dir["#{config.root}/lib/**/"]

    # 404 catcher
    # http://joshsymonds.com/blog/2012/08/13/dynamic-error-pages-corrected/
    # config.after_initialize do |app|
    #   app.routes.append{ match '*a', to: 'application#render_404' } unless config.consider_all_requests_local
    # end

  end
end
