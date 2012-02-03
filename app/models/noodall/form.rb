module Noodall
  class Form
    include MongoMapper::Document
    plugin Noodall::GlobalUpdateTime

    key :title, String, :required => true
    key :description, String
    key :email, String, :format => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
    key :thank_you_message, :default => 'Thank you for getting in contact.'
    key :thank_you_email, :default => 'Thank you for getting in contact.'

    MANDATORY_FIELDS = ['Name','Email']
    many :fields, :class => Noodall::Field
    many :responses, :class => Noodall::FormResponse, :foreign_key => 'noodall_form_id' do
      def ham
        self.select {|r| r.spaminess < (self.class.defensio_config['spam_threshold'] || 0.75)}
      end
      def spam
        self.select {|r| r.spaminess >= (self.class.defensio_config['spam_threshold'] || 0.75)}
      end
      def build(attrs={})
        doc = klass.new
        apply_scope(doc)
        doc.set_up_keys!
        doc.attributes = attrs
        @target ||= [] unless loaded?
        @target << doc
        doc
      end
    end

    before_save :create_mandatory_fields!

    timestamps!

    validates_associated :fields, :message => "have not had a name completed"

    def boolean_fields
      self.fields.select{|f| f.class == Noodall::CheckBox }
    end

    def required_fields
      self.fields.select{|f| f.required }
    end

    def create_mandatory_fields!
      MANDATORY_FIELDS.each do |mf|
        if fields.blank? or fields.select{|f| f.name == mf }.empty?
          self.fields << Noodall::TextField.new(:name => mf, :required => true)
        end
      end
    end

  end
end
