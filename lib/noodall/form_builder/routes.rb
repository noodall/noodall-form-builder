module Noodall
  module FormBuilder
    class Routes
      class << self
        def draw(app)
          app.routes.draw do
  
            namespace 'noodall', :as => 'noodall', :path => '' do
              resources :forms do
                resources :form_responses
              end
            end
          
            namespace 'noodall/admin', :as => 'noodall_admin', :path => 'admin' do
              resources :forms do
                resources :form_responses do
                  collection do
                    post :download
                  end
                  member do
                    put :mark_as_spam
                    put :mark_as_not_spam
                  end
                  
                  collection do
                    delete :destroy_all_spam
                  end
                end
              end

              match 'forms/downloads/:download_id' => 'downloads#download', :as => 'download'
              match 'forms/downloads/:download_id/check' => 'downloads#check', :as => 'download_check'
              match 'forms/downloads/:download_id/email' => 'downloads#email', :as => 'download_email_when_ready'

              resources :fields do
                collection do
                  get :form
                end
              end
              match 'components/form/:type' => 'components#form'
            end
          end
        end
      end
    end
  end
end
