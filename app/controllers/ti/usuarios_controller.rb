class Ti::UsuariosController < ResourceController::Base
  
  #Filtra os usuários para um determinado grupo. 
  #Ex.: http://localhost:3000/grupos/1/usuarios -> todos os usuarios que são do grupo com id 1
  belongs_to :grupo

  before_filter :load, :only => [:new, :create, :edit, :update, :show]
  before_filter :filter_search, :only => :index
  
  #Sweeper - Expira os cache de menu criado para o usuario
  cache_sweeper :usuario_sweeper,:only =>[:create,:update,:destroy]
  
  # Carrega na variavel 'grupos', todos os grupos cadastros.
  # Gedilson
  def load
    @all_groups = Grupo.find(:all)
    @grupos = groups_user_permission(@all_groups)
  end
  
  #OPTIMIZE, melhorar para quando encontrar uma determinada permissão do usuário, passar para a proxima
  #permissão do grupo, continuando a verificação.
  #
  #Método que gera a lista de grupos que um determinado usuário terá acesso ao tentar cadastrar
  #um novo usuário, ou seja, se o usuario tiver permissão de cadastro de usuarios, o método
  #trará somente os grupos, que o usuário corrente tiver.
  def groups_user_permission(all_groups)    
    @user_permissions = current_usuario.permissoes
    groups = []
    
    #Verifica quais o grupos que deverão ser listados para o usuário corrente.
    vlr = false
    all_groups.each do |g|      
      @permissions = g.permissoes      
      @user_permissions.each do |pu|
        r = Regexp.new(pu)
        @permissions.each do |p|
          vlr = vlr || ((r =~ p.recurso) != nil)
        end
      end 
      groups.push(g) if vlr != false
      vlr = false      
    end
    
    groups
  end
  
  #Apos atualizar os dados do usuarios, atualiza-se a lista de grupos do usuários
  #atual, chamando o método update_grupos e passando como parametro a lista
  #de grupos atual.
  #Gedilson  
  update do
    after do
      grupos_ids = params[:grupos].nil? ? [] : params[:grupos]
      @object.update_grupos(grupos_ids)
    end 
    flash @@messages['successfully_updated']
  end
  
  #Apos criar o novo usuário uma lista de grupos é passado por parametro para o 
  #método update_grupos, sendo inserido da tabela correspondente.
  #Gedilson
  create do
    after do
      grupos_ids = params[:grupos].nil? ? [] : params[:grupos]
      @object.update_grupos(grupos_ids)
    end
    flash @@messages['successfully_created']
  end
  
  private
  #Gedilson - Sobreescrita do método collection, para o uso do will_pagination
  def collection
    @collection ||= end_of_association_chain.paginate :page => params[:page], :per_page => PER_PAGE, :conditions => @conditions, :order => "usuarios.login"
  end
end
