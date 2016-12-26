Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  match '/listen_click', to: "tracking#listen_click_event", via: :post
  match '/listen_open', to: "tracking#listen_click_event", via: :post
  
end
