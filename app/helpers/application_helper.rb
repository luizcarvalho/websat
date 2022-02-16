# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include Messages
  # Utlizado em Aplication.rb para gerar link sem redundancia de sufuxo
  # 
  #OPTMIZE Buscar Metodo para Retornar o contextroot
  @contextroot = "http://localhost"
  def javascript(*files)
    content_for(:head) { javascript_include_tag(*files) }
  end

  
  
  
  def situacao(active)
    active ? 'Ativo' : 'Inativo'
  end
  
  def line_color(active)
    "#FF7F50" unless active
  end
end
