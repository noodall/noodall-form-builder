class User
  include MongoMapper::Document
  include Canable::Cans

  key :name, String
  key :groups, Array
  key :password, String
  key :password_confirmation, String

  def admin?
    groups.include?('website administrator')
  end

  def email
    'user@example.com'
  end
end
