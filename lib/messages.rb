module Messages
  @@labels = {'new' => 'Novo', 'show' => 'Visualizar', 'edit' => 'Alterar', 'emails' => 'E-mails',
    'destroy' => 'Apagar', 'back' => 'Voltar', 'create' => 'Salvar', 'update' => 'Atualizar',
    'editing' => 'Editando', 'changing' => 'Alterando', 'registration' => 'Registro',
    'filings' => 'Registros', 'modify' => 'Modificar', 'confirm_destroy' => 'Deseja realmente excluir o registro?',
    'registration' => 'Registro', 'details' => 'Detalhes', 'next' => '|Próximo', 'previous' => 'Anterior|',
    'change_password' => 'Alterar Senha', 'log_in' => 'Acessar', 'permission' => 'Permissão', 'users' => 'Usuários'
  }
  @@labels.default = "...."
  
  @@messages = {'successfully_created' => 'Registro inserido com sucesso!', 
    'successfully_updated' => 'Registro atualizado com sucesso!', 
    'login_successful' => 'Login realizado com sucesso!', 
    'user_and_or_incorrect_password' => 'Usuário e/ou senha incorretos!',
    'exit_system' => 'Você saiu do sistema!',
    'password_successfully_amended' => 'Senha alterada com sucesso!',
    'error_change_password' => 'Erro ao alterar senha!',
    'new_not_password_confirmation' => 'Nova senha não confere com a senha de confirmação!',
    'old_password_wrong' => 'Senha antiga incorreta!', 'between_and_characters' => 'Entre 4 e 40 caracteres'
  }
  @@messages.default = "...."
    
  def labels(indice)   
    @@labels[indice]
  end
  
  def msg(indice)    
    @@messages[indice]
  end
end