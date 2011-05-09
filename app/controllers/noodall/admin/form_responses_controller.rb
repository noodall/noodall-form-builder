require 'fastercsv'

module Noodall
  class Admin::FormResponsesController < Noodall::Admin::BaseController
    include SortableTable::App::Controllers::ApplicationController
    before_filter :find_form,:set_title

    def index
      if @form.nil?
        @responses = Noodall::FormResponse.all
      else
        @responses = @form.responses
      end

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @responses }


        format.csv do
          csv_string = FasterCSV.generate do |csv|
            header_row = @form.fields.map do |field|
              field.name
            end
            header_row += ['Date', 'IP', 'Form Location']
            csv << header_row

            for response in @responses
              response_row = @form.fields.map do |field|
                begin
                  response.send(field.underscored_name)
                rescue NoMethodError => e
                  nil
                end
              end
              response_row += [response.created_at.to_formatted_s(:long_dot), response.ip, response.referrer]
              csv << response_row
            end
          end
          send_data csv_string, :filename => "#{@form.title} responses - #{Time.now.to_formatted_s(:db)}.csv",
                                :type => 'text/csv',
                                :disposition => 'attachment'
        end

      end
    end

    def destroy
      @form.responses = @form.responses.reject{|r| r.id.to_s == params[:id]}

      @form.save
      flash[:notice] = "Response was successfully deleted."

      respond_to do |format|
        format.html { redirect_to(noodall_admin_form_form_responses_url(@form)) }
        format.xml  { head :ok }
      end
    end

    def mark_as_spam
      @response = @form.responses.find(params[:id])
      @response.mark_as_spam!     
      redirect_to(noodall_admin_form_form_responses_url(@form))
    end
    
    def mark_as_not_spam
      @response = @form.responses.find(params[:id])
      @response.approve!     
      
      FormMailer.form_response(@form, @response).deliver unless @form.email.blank?
      FormMailer.form_response_thankyou(@form, @response).deliver
      
      redirect_to(noodall_admin_form_form_responses_url(@form))
    end

  private
    def set_title
      @page_title = "#{@form.title} Responses"
    end
    def find_form
      @form = Noodall::Form.find(params[:form_id]) unless params[:form_id].blank?
    end

  end
end
