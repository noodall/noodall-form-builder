module Noodall
  class Admin::FormsController < Noodall::Admin::BaseController
    include SortableTable::App::Controllers::ApplicationController
    sortable_attributes :created_at, :updated_at, :title
  
    before_filter :set_title
  
    def index
      @forms = Noodall::Form.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @forms }
      end
    end
  
    def show
      @form = Noodall::Form.find(params[:id])
  
      respond_to do |format|
        format.html
        format.xml  { render :xml => @form }
      end
    end
  
    def new
      @form = Noodall::Form.new
      @form.create_mandatory_fields!
  
      respond_to do |format|
        format.html { render :action => "show" }
        format.xml  { render :xml => @form }
      end
    end
  
    def create
      # convert hashes with stringy integer keys to an array of hashes
      params[:form][:fields] = params[:form][:fields].sort{|a,b| a.first.to_i <=> b.first.to_i }.map{|item| item.last }
  
      @form = Noodall::Form.new(params[:form])
  
      respond_to do |format|
        if @form.save
          flash[:notice] = "Form was successfully created."
          format.html { redirect_to noodall_admin_forms_path }
          format.xml  { render :xml => @form, :status => :created }
        else
          format.html do
            render :action => "show"
          end
          format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
        end
      end
    end
  
    def update
      # convert hashes with stringy integer keys to an array of hashes
      params[:form][:fields] = params[:form][:fields].sort{|a,b| a.first.to_i <=> b.first.to_i }.map{|item| item.last }
  
      logger.debug(params[:form][:fields].inspect)
  
      @form = Noodall::Form.find(params[:id])
  
      respond_to do |format|
        if @form.update_attributes(params[:form])
          flash[:notice] = "Form was successfully updated."
          format.html {
            redirect_to noodall_admin_forms_path
          }
          format.xml  { head :ok }
        else
          format.html { render :action => "show" }
          format.xml  { render :xml => @form.errors, :status => :unprocessable_entity }
        end
      end
    end
  
    def destroy
      @form = Noodall::Form.find(params[:id])
  
      @form.destroy
      flash[:notice] = "Form was successfully deleted."
  
      respond_to do |format|
        format.html { redirect_to(noodall_admin_forms_url) }
        format.xml  { head :ok }
      end
    end
  
  
  private
    def set_title
      @page_title = 'Form Builder'
    end
  
  end
end