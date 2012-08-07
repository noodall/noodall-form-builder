module Noodall
  module FormBuilder
    class << self
      attr_accessor :noreply_address
      attr_accessor :spam_protection
      attr_accessor :spam_api_key
      attr_accessor :spam_url
    end

    noreply_address = 'noreply@example.com'

    class Engine < Rails::Engine
      initializer "set menu" do |app|
        Noodall::UI.menu_items['Forms'] = :noodall_admin_forms_path
      end

      if Rails::VERSION::MINOR == 0 # if rails 3.0.x
        initializer "static assets" do |app|
          app.middleware.use ::ActionDispatch::Static, "#{root}/app/assets"
        end
      else
        initializer "Add noodall assets to precomiler" do |app|
          app.config.assets.precompile += %w( admin/formbuilder.js )
        end
      end

    end
  end
end
