require 'rakismet'
require 'spam/spam_checker_connection_error'

module Noodall
  module FormBuilder
    
    class AkismetAPIError < SpamCheckerConnectionError; end
    
    class AkismetSpamChecker
      attr_accessor :akismet

      def initialize(akismet = Rakismet)
        api_key = Noodall::FormBuilder.spam_api_key
        url = Noodall::FormBuilder.spam_url

        if api_key.blank? || url.blank?
          raise <<-EOS.strip_heredoc
            API key and URL must not be empty
            Use Noodall::FormBuilder.spam_api_key = '<key>'
            Use Noodall::FormBuilder.spam_url = '<url>'
          EOS
        end

        self.akismet = akismet

        self.akismet.key = api_key
        self.akismet.url = url
        self.akismet.host = 'rest.akismet.com'
      end

      def check(form_response)
        begin
          response = self.akismet.akismet_call(
            'comment-check',
            spam_attributes(form_response)
          )

          not_spam = (response == 'false' ? true : false)

          [not_spam, nil]
        rescue SocketError => e
          # The Defensio API is regularly down. We raise an error here.
          # Noodall::FormBuilder::FormResponse handles any spam checker errors in #check_for_spam
          raise AkismetAPIError.new("Akismet API connection error.")
        end
      end
      

      def mark_as_spam!(form_response)
        attributes = spam_attributes(form_response)
        self.akismet.akismet_call('submit-spam', attributes)
      end

      def mark_as_ham!(form_response)
        attributes = spam_attributes(form_response)
        self.akismet.akismet_call('submit-ham', attributes)
      end

      private

      # To force Akismet to return spam = true
      # add attribute to hash => 'comment_author' => 'viagra-test-123'
      def spam_attributes(form_response)
        {
          'user_ip' => form_response.ip,
          'comment_author_email' => form_response.email,
          'comment_content' => form_content(form_response),
          'comment_name' => form_response.name,
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
