Rails.application.routes.draw do
  post 'dns_records', to: 'dns_records#create'
  get 'dns_records', to: 'dns_records#index'
end
