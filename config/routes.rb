Rails.application.routes.draw do
  get 'foo/bar'

  get 'foo/baz'

  get 'static_pages/home'

  get 'static_pages/help'

  get 'static_pages/contact'
  get  'static_pages/about'


  root 'static_pages#home'


end
