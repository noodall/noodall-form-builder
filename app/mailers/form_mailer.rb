class FormMailer < ActionMailer::Base
  def form_response(form, response)
    # Email header info MUST be added here
    recipients  form.email
    reply_to    response.email
    subject     "#{Noodall::UI.app_name}: Response to the #{form.title} form."

    # Email body substitutions go here
    body[:form] = form
    body[:response] = response
  end

  def form_response_thankyou(form, response)
    # Email header info MUST be added here
    recipients  response.email
    reply_to    form.email
    subject     "Thank you for getting in contact."

    # Email body substitutions go here
    body[:form] = form
    body[:response] = response
  end
end