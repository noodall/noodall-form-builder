
# in ruby 1.9, fastercsv was included as csv
if RUBY_VERSION =~ /1\.8/
  require 'fastercsv'
  Abstracted_CSV_Class = FasterCSV
else
  require 'csv'
  Abstracted_CSV_Class = CSV
end

module Noodall
  class Admin::FormResponsesController < Noodall::Admin::BaseController
    include SortableTable::App::Controllers::ApplicationController
    before_filter :find_form,:set_title

    def index
      if @form.nil?
        @responses = Noodall::FormResponse.where
      else
        @responses = @form.responses
      end

      respond_to do |format|
        format.html do
          Rails.logger.info "FORMAT HTML"
          @responses = @responses.paginate(:per_page => 100, :page => params[:page])
        end

        format.csv do
          
          # Only include non-spam responses in CSV download
          @responses = @responses.where(:approved => true).paginate(:per_page => 100, :page => params[:page])

            csv_string = Abstracted_CSV_Class.generate do |csv|
            header_row = @form.fields.map do |field|
              field.name
            end
            header_row += ['Date', 'IP', 'Form Location']
            csv << header_row

            for response in @responses
              response_row = @form.fields.map do |field|
                begin
                  value = response.send(field.underscored_name)
                  value.respond_to?(:join) ? value.join(', ') : value
                rescue NoMethodError => e
                  nil
                end
              end
              response_row += [response.created_at.to_formatted_s(:long), response.ip, response.referrer]
              csv << response_row
            end
          end
          
          send_data csv_string, :filename => "#{@form.title} responses - #{Time.now.to_formatted_s(:db)}-#{@responses.current_page}.csv",
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
    
    def destroy_all_spam
      @spam_responses = @form.responses.where(:approved => false)
      @spam_responses.each { |spam| spam.destroy }
      redirect_to(noodall_admin_form_form_responses_url(@form), :notice => 'All spam has been deleted')
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
