module Noodall
  class FormResponse
    include MongoMapper::Document

    key :name, String
    key :email, String, :format => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
    key :ip, String, :required => true
    key :referrer, String, :required => true
    key :created_at, Time, :required => true
    key :approved, Boolean, :default => true
    key :defensio_signature, String
    key :spaminess, Float, :default => 0

    before_save :check_for_spam
    attr_protected :approved

    timestamps!

    belongs_to :form, :class => Noodall::Form, :foreign_key => 'noodall_form_id'

    def required_fields
      self.form.fields.select{ |f| f.required? }
    end
    
    def correct_fields?
      self.form.fields.each do |f|
        return false unless self.respond_to?(f.name.downcase.parameterize("_").to_sym)
      end
      return true
    end

    def approve!
      self.approved = true
      self.save!
      self.class.defensio.put_document(defensio_signature, { :allow => true })
    end

    def mark_as_spam!
      self.approved = false
      self.save!
      self.class.defensio.put_document(defensio_signature, { :allow => false })
    end

    def is_spam?
      self.approved == false
    end

    def string_value(name)
      return '' unless self.respond_to?(name)
      value = self.send(name)

      if value.is_a?(Array)
        value.join(', ')
      else
        value.to_s
      end
    end

  protected
    def check_for_spam
      if self.defensio_signature.blank?
        status, response = self.class.defensio.post_document(self.defensio_attributes)
        return true unless status == 200

        self.defensio_signature = response['signature']
        self.spaminess = response['spaminess']
        self.approved = response['allow']
      end
      return true 
    end

    def self.defensio
      @@defensio ||= Defensio.new(self.defensio_api_key)
    end

    def self.defensio_api_key
      defensio_config['api_key']
    end

    def self.defensio_config
      logger.info "No Defensio config found" unless FileTest.exists?(File.join(Rails.root, 'config', 'defensio.yml'))
      @defensio_config ||= YAML::load(File.open(File.join(Rails.root, 'config', 'defensio.yml')))
    end

    def defensio_attributes
      {
        'client' => 'Noodall Form Builder | 1.0 | Beef Ltd | hello@wearebeef.co.uk ',
        'type' => 'other',
        'platform' => 'noodall',
        'content' => self.form.fields.map{|f| "#{f.name}: #{self.send(f.underscored_name) if self.respond_to?(f.underscored_name)}" }.join(' '),
        'author-email' => self.email,
        'author-name' => self.name,
        'author-ip' => self.ip
      }
    end


  private
    validate :custom_validation

    def custom_validation
      return true if required_fields.nil? || !self.new_record?
      required_fields.each do |field|
        self.errors.add(field.underscored_name.to_sym, "can't be empty") if self.send(field.underscored_name).blank?
      end
      return true if self.errors.empty? 
    end
    
    def method_missing(method)
      # If the form doesn't have a field that matches this method, act normally. Otherwise, return nil to show the field is empty. 
      if form.fields.select{|f| f.underscored_name.to_sym == method}.empty? 
        super
      else
        return nil
      end
    end
    
  end
end
