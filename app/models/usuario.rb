require 'digest/sha1'
class Usuario < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_format_of       :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  
  before_save :encrypt_password
  
  #Association
  has_many :grupo_usuarios, :dependent=> :destroy
  has_many :grupos, :through=> :grupo_usuarios
  has_many :mailboxes,  :dependent=> :destroy
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

  def to_s
    login
  end
  
  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end
  
  # Atualiza e ou insere os grupos relacionado a um determinando usuário,
  # no banco de dados
  # Gedilson
  def update_grupos(grupo_ids)
    unless grupo_ids.nil?    
      self.grupo_usuarios.each do |m|
        m.destroy unless grupo_ids.include?(m.grupo_id.to_s)
        grupo_ids.delete(m.grupo_id.to_s)
      end
      
      grupo_ids.each do |grupo|
        self.grupo_usuarios.create(:grupo_id => grupo) unless grupo.blank?
      end
    end
  end
  
  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at 
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end
  
  # START: permissoes
  def permissoes
    a = []
    grupos.each{|g| g.permissoes.each {|p| a.push(p.recurso) unless a.include?(p.recurso)}}
    a
  end #END:permissoes 
   
  # Return true/false if User is authorized for resource.
  def authorized?(resource)
    match= false 
    permissoes.each do |p|
      r = Regexp.new(p)
      #OPTIMIZE Sair quando achar o primeiro
      match = match || ((r =~ resource) != nil)
    end
    match
  end  
 

 # Cria uma Estrutura de arrays e Hashs para Menus, apartir das permissões 
 # provenientes do grupo do usuário.
 #
 # == Exemplo:
 #   
 #   Usuario 7
 #   Grupos: RH,TI.Geral
 #   
 # ==== Permissões Geral
 # * Home URL: +home+           
 #                  
 # ==== Permissões TI 
 # * Cadastrar Permissões: URL  +permissoes+/+new+
 #    
 # * Editar Permissões: URL  +permissoes+/+edit+
 #        
 # ==== Permissões RH
 # * Cadastrar Usuario: URL +grupos+/+new+ 
 # 
 # * Mostar Usuario: URL +usuario+/+show+
 # 
 # ==== Todos os Menus
 # * Cadastrar Permissões: URL +permissoes+/+new+ , PAI +TI+
 # * Editar Permissões: URL +permissoes+/+edit+, PAI +TI+
 # * Excluir Permissões: URL +permissoes+/+destroy+, PAI +TI+
 # * Mostar Permissões: URL +permissoes+/+show+, PAI +TI+
 # * Listar Permissões: URL +permissoes+/+index+, PAI +TI+
 # 
 # * Cadastrar Peças: URL +pecas+/+new+, PAI +Laboratorio+
 # * Editar Peças: URL +pecas+/+edit+ , PAI +Laboratorio+
 # * Excluir Peças: URL +pecas+/+delete+, PAI +Laboratorio+
 # * Mostar Peças: URL +pecas+/+show+, PAI +Laboratorio+
 # * Listar Peças: URL +pecas+/+index+, PAI +Laboratorio+
 # 
 # * Cadastrar Usuarios: URL +usuarios+/+new+, PAI +RH+
 # * Editar Usuarios: URL +usuarios+/+new+, PAI +RH+
 # * Excluir Usuarios: URL +usuarios+/+new+, PAI +RH+
 # * Mostar Usuarios: URL +usuarios+/+new+, PAI +RH+
 # * Listar Usuarios: URL +usuarios+/+new+, PAI +RH+
 #   
 # * Home :URL +home+, PAI _null_
 # * TI :URL +#+, PAI _null_
 # * RH :URL +#+, PAI _null_
 # * Laboratorio, PAI _null_
 # 
 # 
 # == Resultado
 #    
 # *   +Home+
 # *    +TI+ <br>
 #       - _Cadastrar_ _Permissões_<br> 
 #       - _Editar_ _Permissões_
 # *    +RH+<br>
 #       - _Cadastrar_ _Usuario_<br>
 #       - _Mostrar_ _Usuario_
 # 
 # 
 # == Retorna - Array
 # 
 #  [{:filhos=>[{:label=>"Editar Usuario",:url=>"ti/usuarios/edit"}], # SubMenus(Filhos de TI) 
 #       :url=>"#", :label=>"TI"},  # Url e Label do Menu Principal(TI)
 #   {:filhos=>[{:label=>"Cadastrar Grupo",:url=>"ti/grupos/new"}, {"Cadastrar Usuario"=>"ti/usuarios/new"}],# SubMenus(Filhos de RH)
 #       :url=>"#", :label=>"RH"},# # Url e Label do Menu Principal(RH)
 #   {:filhos=>[], # SubMenus(Filhos de Home)//Menu sem Home
 #       :url=>"home", :label=>"home"}]# Url e Label do Menu Principal(Home)
 # 
 # #LUIZ
  def build_menu
    menu_usuario = []
    menus = Menu.find(:all,:include=>:menu_pai,:order=>"menus.ordem")
    mfilho = [] #Comtém cada Menu-Filho
    
    
    menus.each do |mi| 
      #Se MI(Menu_Item) não tiver pai e possuir filhos
      if(mi.menu_pai.nil? && !mi.menu_filhos.nil?)
        #Coletando menu autorizados para aquele usuario
        mfilho = mi.menu_filhos.collect do |f|         
          if(authorized?(f.url))
            {:label=> f.label,:url=>f.url}
          end
        end 
       
        
        
        #Monta um item do Menu, com o Menu Principal e seus Filhos
        item_menu = {:label=>mi.label,:url=>mi.url,:filhos=>mfilho}
        #Se o Menu Pai Não Possuir Filhos(ou seja, possuir um Array Nullo ou Array Vazio)
        #-> Quando o Usuario tiver permissão para uma URL seu pai será adicionado.
        #
        #Ou se Ele Possuir uma URL('#' por padrão é uma URL Nulla)
        #No caso do HOME que possui uma URL mas não possui Filhos.
        if(item_menu[:filhos]!=[nil] || item_menu[:url]!="#")
          #Adiciona um Item ao menu do usuario  
          menu_usuario.push(item_menu)
        end
      end
      
    end
    menu_usuario
  end

  protected
    # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end
      
    def password_required?
      crypted_password.blank? || !password.blank?
    end

    
end
