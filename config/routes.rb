Rails.application.routes.draw do

  mount Blacklight::Engine => '/'
  root to: "catalog#index"
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # Logout links
  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
  end

  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns :exportable
  end

  # Status page for Pingdom
  get '/status', to: 'application#status'

  # Restricted PAG files
  get 'restricted/pag/*path', to: 'pag_files#download', format: false

  # PAG agreement views
  get 'restricted/pag/*path/agreement', to: 'pag_files#display_agreement'
  post '/submit-agreement', to: 'pag_files#submit_agreement'

  # resources :bookmarks do
  #   concerns :exportable

  #   collection do
  #     delete 'clear'
  #   end
  # end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
mount Geoblacklight::Engine => 'geoblacklight'
        concern :gbl_exportable, Geoblacklight::Routes::Exportable.new
        resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
          concerns :gbl_exportable
        end
        concern :gbl_wms, Geoblacklight::Routes::Wms.new
        namespace :wms do
          concerns :gbl_wms
        end
        concern :gbl_downloadable, Geoblacklight::Routes::Downloadable.new
        namespace :download do
          concerns :gbl_downloadable
        end
        resources :download, only: [:show]
end
