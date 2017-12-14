Rails.application.routes.draw do
  match '/', to: 'submissions#inbound', via: [:post]
end
