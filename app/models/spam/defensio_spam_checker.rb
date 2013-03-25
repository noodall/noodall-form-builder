require 'defensio'

module Noodall
  module FormBuilder
    
    class DefensioAPIError < StandardError; end
    
    class DefensioSpamChecker
      attr_accessor :defensio

      def initialize
        api_key = Noodall::FormBuilder.spam_api_key

        if api_key.blank?
          raise <<-EOS.strip_heredoc
            API key must not be empty
            Use Noodall::FormBuilder.spam_api_key = '<key>'
          EOS
        end

        self.defensio = Defensio.new(api_key)
      end

      def check(form_response)
        status, response = self.defensio.post_document(
          spam_attributes(form_response)
        )
        
        # The Defensio API is regularly down. We raise an error here and let the application decide
        # how to handle it
        raise DefensioAPIError.new("Spam checking is currently unavailable. Please contact the administrator.") if status == 503

        [response['allow'], response['signature']]
      end

      def mark_as_spam!(form_response)
        defensio.put_document(
          form_response.defensio_signature, { :allow => false }
        )
      end

      def mark_as_ham!(form_response)
        defensio.put_document(
          form_response.defensio_signature, { :allow => true }
        )
      end

      private

      def spam_attributes(form_response)
        {
          'client' => 'Noodall Form Builder | 1.0 | Beef Ltd | hello@wearebeef.co.uk ',
          'type' => 'other',
          'platform' => 'noodall',
          'content' => form_content(form_response),
          'author-email' => form_response.email,
          'author-name' => form_response.name,
          'author-ip' => form_response.ip
        }
      end

      def form_content(form_response)
        form_response.form.fields.map do |f|
          if form_response.respond_to?(f.underscored_name)
            "#{f.name}: #{form_response.send(f.underscored_name)}"
          end
        end.join(' ')
      end
    end
  end
end
