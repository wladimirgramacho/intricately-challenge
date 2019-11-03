Rails.application.routes.draw do
  post 'dns_record', to: 'dns_records#create'
  get 'dns_records', to: 'dns_records#index'
end
