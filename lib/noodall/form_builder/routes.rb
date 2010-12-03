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
                    get :mark_as_spam
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
