Rails.application.routes.draw do
  scope module: 'web' do
    root "welcome#index"
    post 'auth/:provider', to: 'auth#request', as: :auth_request
    get 'auth/:provider/callback', to: 'auth#callback', as: :callback_auth
    delete 'logout', to: 'auth#destroy', as: :logout
  end
end
