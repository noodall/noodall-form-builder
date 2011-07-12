module Noodall
  class FormResponsesController < ApplicationController
    skip_before_filter :verify_authenticity_token
    # POST /responses
    # POST /responses.xml
    def create

      # long way of adding a new response to a form (create then append to form model)
      # as redirecting back to the form will cause errors with half built appended objects
      @form = Noodall::Form.find(params[:form_id])

      @form_response = @form.responses.build(params[:form_response])
      
      #If the form response hasn't been constructed properly (i.e. a random spam POST)
      raise MongoMapper::DocumentNotFound, "Form response does not match form" unless @form_response.correct_fields?
      
      @form_response.ip = request.remote_ip
      @form_response.referrer = request.referer if @form_response.referrer.blank?
      @form_response.created_at = Time.zone.now

      respond_to do |format|        
        if @form_response.valid? and @form_response.save
          if @form_response.is_spam?
            logger.info "Form response was deemed to be spam: #{@form_response.inspect}"
          else
            begin
              # mail the response to the form recipient
              FormMailer.form_response(@form, @form_response).deliver unless @form.email.blank?
              FormMailer.form_response_thankyou(@form, @form_response).deliver
            rescue Net::SMTPSyntaxError
            end
          end

          flash.now[:notice] = @form.thank_you_message
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
