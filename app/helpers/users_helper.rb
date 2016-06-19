require "base64"
module UsersHelper
  def random_password
    password = rand(1000000000..999999999999999).to_s
    @encrypted_password = Base64.encode64(password)
    return @encrypted_password
  end
end
