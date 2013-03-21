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
                  member do
                    put :mark_as_spam
                    put :mark_as_not_spam
                  end
                  
                  collection do
                    delete :destroy_all_spam
                  end
                end
              end
              
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
