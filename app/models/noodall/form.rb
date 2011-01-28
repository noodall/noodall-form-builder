module Noodall
  class Form
    include MongoMapper::Document
    plugin MongoMapper::Plugins::MultiParameterAttributes
    plugin Noodall::GlobalUpdateTime
  
    key :title, String, :required => true
    key :description, String
    key :email, String, :format => /.+\@.+\..+/
  
    MANDATORY_FIELDS = ['Name','Email']
    many :fields, :class => Noodall::Field
    many :responses, :class => Noodall::FormResponse do
      def ham
        self.select {|r| r.spaminess < (self.class.defensio_config['spam_threshold'] || 0.75)}
      end
      def spam
        self.select {|r| r.spaminess >= (self.class.defensio_config['spam_threshold'] || 0.75)}
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