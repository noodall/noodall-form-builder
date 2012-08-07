
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
    before_filter :find_form, :set_title

    def index
      @responses = @form.responses.paginate(:per_page => 100, :page => params[:page])
    end

    def download
      year = params[:date][:year].to_i
      month = params[:date][:month].to_i

      from = Date.civil(year, month, 01).to_time

      next_month = month + 1
      next_month = 1 if next_month > 12
      to = Date.civil(year, next_month, 01).to_time

      # Only include non-spam responses in CSV download...
      responses = @form.responses.where(:approved => true)

      # ...and between the supplied dates
      responses = responses.where(
        :created_at => {
          :$gte => from,
          :$lt => to
        }
      )

      csv_string = Abstracted_CSV_Class.generate do |csv|
        header_row = @form.fields.map do |field|
          field.name
        end
        header_row += ['Date', 'IP', 'Form Location']
        csv << header_row

        for response in responses
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
      send_data csv_string, :filename => "#{@form.title} responses #{month}-#{year} #{Time.now.to_formatted_s(:db)}.csv",
                            :type => 'text/csv',
                            :disposition => 'attachment'
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
