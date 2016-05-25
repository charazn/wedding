require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Wedding
  class Application < Rails::Application
    config.time_zone = 'Hong Kong'
    config.active_record.default_timezone = :local

    config.active_record.raise_in_transactional_callbacks = true

    config.generators do |g|
      g.helper false
      g.assets false
      g.stylesheets false
      g.javascripts false
      g.jbuilder false
      g.test_framework false
    end
  end
end
