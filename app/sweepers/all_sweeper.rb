class AllSweeper < ActionController::Caching::Sweeper
observe Permissao,Menu,Grupo

 
  def after_create(record)
    expire_cache_for(record)
  end

  def after_update(record)
    expire_cache_for(record)
  end
  
  def after_destroy(record)
    expire_cache_for(record)
  end

  
  private
  def expire_cache_for(record)
    expire_fragment(%r{menu_usuario_[0-9]*})
  end
  
  
  
end
