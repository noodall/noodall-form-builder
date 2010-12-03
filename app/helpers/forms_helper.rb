module FormsHelper

  def response_setup(form)
    # collect the default values together
    defaults = {}
    form.fields.collect{|f| defaults[f.underscored_name.to_sym] = f.default } unless form.nil? || form.fields.nil?

    Noodall::FormResponse.new(defaults)
  end

end
