Rails.application.routes.draw do
  root  'home#root'
  get   '/secret'  =>  'home#secret'
  get   '/stocker' =>  'home#stocker'
  get   '/calc'    =>  'home#calc'
end
