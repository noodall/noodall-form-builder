module Noodall
  class Admin::FormResponsesController < Noodall::Admin::BaseController
    include SortableTable::App::Controllers::ApplicationController
    before_filter :find_form, :set_title

    def index
      @responses = @form.responses.paginate(:per_page => 100, :page => params[:page])
    end

    def download
      year = params[:date][:year]
      month = params[:date][:month]

      csv = FormResponseCsv.new(@form, params[:date]).output
      send_data(
        csv,
        :filename => "#{@form.title} responses #{month}-#{year} #{Time.now.to_formatted_s(:db)}.csv",
        :type => 'text/csv',
        :disposition => 'attachment'
       )
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
