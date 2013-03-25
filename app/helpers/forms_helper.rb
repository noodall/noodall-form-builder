module FormsHelper

  def response_setup(form)
    form.responses.build
  end

  def field_type(field)
    field_type = field._type.gsub(/^.*::/, '').downcase

    if field_type == "textfield" && field.rows > 1
      field_type = "textarea"
    end

    return field_type
  end

  def spam_protection_configured?
    !Noodall::FormBuilder.spam_protection.nil?
  end
end
