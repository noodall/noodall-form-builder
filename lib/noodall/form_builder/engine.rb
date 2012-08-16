module Noodall
  module FormBuilder
    class << self
      attr_accessor :noreply_address
      attr_accessor :spam_protection
      attr_accessor :spam_api_key
      attr_accessor :spam_url
      attr_accessor :use_background_queue
    end

    noreply_address = 'noreply@example.com'
    use_background_queue = false

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

      rake_tasks do
        Dir[File.join(File.dirname(__FILE__),'tasks/*.rake')].each { |f| load f }
      end
    end
  end
end
