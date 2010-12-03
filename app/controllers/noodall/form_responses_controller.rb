module Noodall
  class FormResponsesController < ApplicationController
    # POST /responses
    # POST /responses.xml
    def create
    
      # long way of adding a new response to a form (create then append to form model)
      # as redirecting back to the form will cause errors with half built appended objects
      @form = Noodall::Form.find(params[:form_id])
      
      @form_response = @form.responses.build(params[:form_response])
      
      @form_response.ip = request.remote_ip
      @form_response.referrer = request.referer if @form_response.referrer.blank?
      @form_response.created_at = Time.zone.now
  
      respond_to do |format|
        if @form_response.save
          @form.responses << @form_response
          @form.save
          
          
          unless @form_response.is_spam?
           begin
            # mail the response to the form recipient
            FormMailer.deliver_form_response(@form, @form_response) unless @form.email.blank?
            FormMailer.deliver_form_response_thankyou(@form, @form_response)
           rescue Net::SMTPSyntaxError
           end
          end
          
          flash[:notice] = 'Thank you for getting in contact.'
          format.html
          format.xml  { render :xml => @form, :status => :created, :location => @form }
        else
          format.html { render 'new' }
          format.xml  { render :xml => @form_response.errors, :status => :unprocessable_entity }
        end
      end
    end
  end
end