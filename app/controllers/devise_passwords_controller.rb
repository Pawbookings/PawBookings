class DevisePasswordsController < Devise::PasswordsController

  def new
    self.resource = resource_class.new
  end

  private

end
