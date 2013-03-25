module Noodall
  class Admin::FormResponsesController < Noodall::Admin::BaseController

    include SortableTable::App::Controllers::ApplicationController
    before_filter :find_form, :set_title
    
    # Rescue errors caused by the Defensio API being down
    rescue_from Noodall::FormBuilder::DefensioAPIError do |exception|
      redirect_to noodall_admin_form_form_responses_path(@form), :alert => exception.message
    end

    def index
      @responses = @form.responses.paginate(:per_page => 100, :page => params[:page], :order => 'created_at DESC')
    end

    def download
      # TODO: Check if download already exists and that first
      download = FormResponsesDownload.new(@form, params[:date], ( current_user.email if params[:email_me] ))
      redirect_to(noodall_admin_download_path(download.generate.id))
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
