module Noodall
  module FormBuilder
    class << self
      attr_accessor :noreply_address
    end

    noreply_address = 'noreply@example.com'

    class Engine < Rails::Engine
      initializer "set menu" do |app|
        Noodall::UI.menu_items['Forms'] = :noodall_admin_forms_path
      end

      initializer "static assets" do |app|
        app.middleware.use ::ActionDispatch::Static, "#{root}/public"
      end
    end
  end
end
