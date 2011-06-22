module FormsHelper

  def response_setup(form)
    # collect the default values together
    defaults = {}
    form.fields.collect{|f| defaults[f.underscored_name.to_sym] = f.default } unless form.nil? || form.fields.nil?

    Noodall::FormResponse.new(defaults)
  end

  def field_type(field)
    field_type = field._type.gsub(/^.*::/, '').downcase
    
    if field_type == "textfield" && field.rows > 1
      field_type = "textarea"
    end
    
    return field_type
  end

end
