ActionController::Routing::Routes.draw do |map|

  map.root :controller => 'sessoes', :action => 'new' #Público --- Não pode estar logado

  map.home '/home', :controller => 'home', :action => 'index' #Publico --- Deve estar logado
  map.login '/login', :controller => 'sessoes', :action => 'new' #Publico --- Não pode estar logado
  map.logout '/logout', :controller => 'sessoes', :action => 'destroy' #Publico --- Deve estar logado
  map.change_password '/change_password', :controller => 'passwords', :action => 'edit'  #Público --- Deve estar logado
  
  map.resource :sessao
  map.resource :password
  
  map.namespace :ti do |ti|
    ti.resources :permissoes #Protegido --- Deve estar logado e ter permissão
    ti.resources :grupos, :has_many=>[ :usuarios, :permissoes ] #Protegido --- Deve estar logado e ter permissão
    ti.resources :usuarios, :has_many=> [:mailboxes,:grupos] #Protegido --- Deve estar logado e ter permissão   
    ti.resources :menus  #Protegido --- Deve estar logado e ter permissão
    ti.resources :dominios, :has_many=>[ :aliases, :mailboxes] #Protegido --- Deve estar logado e ter permissão
    ti.resources :aliases #Protegido --- Deve estar logado e ter permissão
    ti.resources :mailboxes #Protegido --- Deve estar logado e ter permissão
  end

  map.resources :usuarios, :only => [:show]

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect ':controller/:action.:format'
end
