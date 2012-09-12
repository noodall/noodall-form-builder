class FormMailer < ActionMailer::Base
  default :from => Noodall::FormBuilder.noreply_address

  def form_response(form, response)
    @form = form
    @response = response

    mail(:to       => form.email,
         :reply_to => response.email,
         :subject  =>   "[#{Noodall::UI.app_name}] Response to the #{form.title} form.")
  end

  def form_response_thankyou(form, response)
    @form = form
    @response = response

    mail(:to       => response.email,
         :reply_to => form.email,
         :subject  =>   "[#{Noodall::UI.app_name}] Thank you for getting in contact.")
  end

  def download_ready(download)
    @download = download

    mail(:to       => download.email,
         :subject  => "[#{Noodall::UI.app_name}] Form CSV Download is ready.")
  end
end
