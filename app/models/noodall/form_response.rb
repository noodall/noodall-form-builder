require 'spam/defensio_spam_checker'
require 'spam/akismet_spam_checker'

module Noodall
  class FormResponse
    include MongoMapper::Document

    key :name, String, :required => true
    key :email, String, :format => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
    key :ip, String, :required => true
    key :referrer, String, :required => true
    key :created_at, Time, :required => true
    key :approved, Boolean, :default => false
    key :checked, Boolean, :default => false

    # For Defensio only
    key :defensio_signature, String

    before_save :check_for_spam

    attr_protected :approved

    timestamps!

    belongs_to :form, :class => Noodall::Form, :foreign_key => 'noodall_form_id'

    # Overriden to set up keys after find
    def initialize_from_database(attrs={})
      super.tap do
        set_up_keys!
      end
    end

    def approve!
      self.approved = true
      self.save!
      self.class.spam_checker.mark_as_ham!(self)
    end

    def mark_as_spam!
      self.approved = false
      self.save!
      self.class.spam_checker.mark_as_spam!(self)
    end

    def is_spam?
      self.approved == false
    end

    # Create appropriate MongoMapper keys for current instance
    # based on the fields of the form it belongs to
    def set_up_keys!
      form.fields.each do |f|
        class_eval do
          key f.underscored_name, f.keys['default'].type, :required => f.required, :default => f.default
        end
      end if form
    end

    # Merge meta keys with real keys
    def keys
      super.merge( class_eval( 'keys' ) )
    end

    protected

    def check_for_spam
      return if spam_checked?

      # If no spam checking is enabled, just approve automatically
      if self.class.spam_checker.nil?
        self.approved = true
        return
      end
      
      begin
        spam, metadata = self.class.spam_checker.check(self)

        self.approved           = spam
        self.defensio_signature = metadata
        self.checked            = true
      rescue Noodall::FormBuilder::SpamCheckerConnectionError => e
        # TODO - here we need to chuck the error at exceptional if it is available
        self.approved           = true
        self.defensio_signature = nil
        self.checked            = false
      end

      true
    end

    def spam_checked?
      self.checked
    end

    def self.spam_checker
      @@spam_checker ||= begin

        spam_service = Noodall::FormBuilder.spam_protection
        return if spam_service.nil?

        spam_checker = "#{spam_service.capitalize}SpamChecker"
        klass = Noodall::FormBuilder.const_get(spam_checker)

        klass.new
      end
    end
  end
end
