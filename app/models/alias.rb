class Alias < ActiveRecord::Base
   #Associations
   belongs_to :dominio
   
  #Validations
  validates_presence_of :address #email
  validates_presence_of :goto #emails
  
  
end
