class Dominio < ActiveRecord::Base
  #Associasoes
  has_many :aliases
  has_many :mailboxes
  
  #Validations
  validates_presence_of :domain
  validates_presence_of :maxaliases
    validates_length_of :maxaliases, :within => 1..750
  validates_presence_of :description
  validates_presence_of :maxmailboxes
    validates_length_of :maxmailboxes, :within => 1..500
  validates_presence_of :maxquota, :within => 10240000..102400000
  validates_presence_of :transport


  





  def to_s
    domain
  end
end
