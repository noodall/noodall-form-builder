class Noodall::FormBuilder::SetupGenerator < Rails::Generators::Base
  source_root File.expand_path('../../../../../../app', __FILE__)

  def setup
    add_initializer_config
    add_routes
  end

  private

  def add_initializer_config
    append_to_file 'config/initializers/noodall.rb' do
      <<-EOS.strip_heredoc

      # Add ContactForm component to the desired slot
      #Noodall::Node.slot :large, ContactForm

      # Set the no-reply email address
      #Noodall::FormBuilder.noreply_address = '<noreply_email>'

      # For Defensio spam protection
      #Noodall::FormBuilder.spam_protection = :defensio
      #Noodall::FormBuilder.spam_api_key = '<api_key>'

      # For Akismet spam protection
      #Noodall::FormBuilder.spam_protection = :akismet
      #Noodall::FormBuilder.spam_api_key = '<api_key>'
      #Noodall::FormBuilder.spam_url = '<website_url>'
      EOS
    end
  end

  def add_routes
    app_name = Rails.application.class.name
    prepend_to_file 'config/routes.rb' do
      <<-EOS.strip_heredoc
      require 'noodall/form_builder/routes'
      Noodall::FormBuilder::Routes.draw #{app_name}

      EOS
    end
  end
end
