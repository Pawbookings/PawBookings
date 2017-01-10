class PoliciesController < ApplicationController
  before_action :authenticate_user!

  def new
    kennel = Kennel.where(user_id: current_user.id).first
    @policy = Policy.new
    @policies = Policy.where(kennel_id: kennel[:id])
  end

  def create
    policy = Policy.new(policy_params)
    user = User.where(id: current_user.id).first
    kennel = Kennel.where(user_id: current_user.id).last
    if policy.valid? && kennel.policies.create(kennel_id: kennel.id, description: policy.description)
      if params[:create_another_policy] == "Save and Add Another Policy"
        flash[:notice] = "A new Policy was created successfully!"
        redirect_to new_policy_path
      else
        flash[:notice] = "A new Policy was created successfully!"
        redirect_to kennel_dashboard_path
      end
    else
      flash[:notice] = "Your Policy failed to save. #{policy.errors.full_messages.first}"
      redirect_to request.referrer
    end
  end

  def update
    policy = Policy.find(params[:id])
    policy.description = params[:policy][:description]
    if policy.valid? && policy.save!
      flash[:notice] = "Your Policy updated successfully!"
      redirect_to new_policy_path
    else
      flash[:notice] = "Your Policy falied to update. #{policy.errors.full_messages.first}"
      redirect_to request.referrer
    end
  end

  def destroy
    kennel = Kennel.where(user_id: current_user.id).first
    policy = Policy.where(id: params[:id], kennel_id: kennel[:id]).first
    policy.delete
    redirect_to new_policy_path
  end

  private

  def policy_params
    return params.require(:policy).permit(:description)
  end

end
