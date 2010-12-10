class ContactForm < Noodall::Component
  key :form_id, String

  has_one :form, :class => Noodall::Form

  allowed_positions :wide

  module ClassMethods
    def form_options
      lists = Noodall::Form.all(:fields => [:id, :title], :order => 'title ASC')
      lists.collect{|l| [l.title, l.id.to_s]}
    end

  end
  extend ClassMethods
end
