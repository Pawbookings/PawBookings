class PoliciesController < ApplicationController
  before_action :authenticate_user!

  def new
    @policy = Policy.new
  end

  def create
    @policy = Policy.new(policy_params)
    @user = User.where(id: current_user.id).first
    @user.completed_registration = true
  @kennel = Kennel.where(user_id: @user.id).last
    if @kennel.policies.create(kennel_id: @kennel.id, description: @policy.description) && @user.save
      if params[:create_another_policy] == "Submit and create another 'Policy'"
        redirect_to new_policy_path
      else
        redirect_to kennel_dashboard_path
      end
    end
  end

  private

  def policy_params
    return params.require(:policy).permit(:description)
  end

end
