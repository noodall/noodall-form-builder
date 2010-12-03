module Noodall
  class FormResponse
    include MongoMapper::Document
    include MongoMapper::EmbeddedDocument
    plugin MongoMapper::Plugins::MultiParameterAttributes
    include Validatable
  
    key :name, String
    key :email, String, :format => /.+\@.+\..+/
    key :ip, String, :required => true
    key :referrer, String, :required => true
    key :created_at, Time, :required => true
    key :approved, Boolean, :default => false
    key :defensio_signature, String
  
    attr_accessor :spam_filter
  
    def required_fields
      self.form.fields.select{ |f| f.required? }
    end
  
    before_create :check_for_spam
    attr_protected :approved
  
  
    embedded_in :form
  
    #validates_true_for :spam_filter, :allow_nil => false, :logic => Proc.new{|p| is_spam? }, :message => "believes response to be spam.", :if => Proc.new{|p| p.new? }
  
  
  public
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
      self.approved == true
    end
  
  protected
    def check_for_spam
      result = self.class.defensio.post_document(self.defensio_attributes)
      status, response = result.first, result.last
      
      return unless status == 200
      
      self.defensio_signature = response[:signature]
      self.approved = (response[:spaminess] < (defensio_config['spam_threshold'] || 0.75))
      
      logger.info response.inspect unless self.approved
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
        'content' => self.fields.map{|f| "#{f.name}: #{self.send(f.underscored_name) if self.respond_to?(f.underscored_name)}" },
        'author-email' => self.email,
        'author-name' => self.name,
        'author-url' => Settings.site_name,
        'author-ip' => self.response.remote_ip
      }
    end
  
  
  private
    validate :custom_validation
  
    def custom_validation
      return if required_fields.nil?
      required_fields.each do |field|
        self.add_error(field.underscored_name.to_sym, "can't be empty") if self.send(field.underscored_name).blank?
      end
    end
  end
end