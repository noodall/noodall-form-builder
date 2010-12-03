module Noodall
  class Admin::FieldsController < Noodall::Admin::BaseController
    include SortableTable::App::Controllers::ApplicationController
    # too long on the form builder and the system kicks you out
    before_filter :sign_in_required, :except => [:new]
    
    def new
    
      field = "Noodall::#{params[:type].classify}".constantize
      # check that field class exists
      if defined?(field)
        @field = field.new
        
        respond_to do |format|
          format.html { render :layout => false, :partial => "noodall/admin/fields/#{params[:type]}", :locals => {:field => @field, :index => params[:index].to_i}}
          format.xml  { render :xml => @forms }
        end
      end
    end
  end
end