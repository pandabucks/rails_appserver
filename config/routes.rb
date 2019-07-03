Rails.application.routes.draw do
  root  'home#root'
  get   '/secret'  =>  'home#secret'
end
