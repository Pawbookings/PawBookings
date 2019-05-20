class PoliciesController < ApplicationController
  before_action :authenticate_user!

  def new
    @policy = Policy.new
    respond_to do |format|
      format.html
      format.js
    end
  end

  def edit
    @policy = Policy.find(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    policy = Policy.new(policy_params)
    user = User.where(id: current_user.id).first
    kennel = Kennel.where(user_id: current_user.id).last
    if policy.valid? && kennel.policies.create(
        kennel_id: kennel.id,
        title: policy.title,
        description: policy.description
      )
      flash[:notice] = "A new Policy was created successfully!"
      return redirect_to kennels_path(tab: 'policies')
    else
      error_message = "Your Policy failed to save."
      flash[:notice] = error_message
      return redirect_to kennels_path(tab: 'policies')
    end
  end

  def update
    policy = Policy.find(params[:id])
    policy.description = params[:policy][:description]
    policy.title = params[:policy][:title]
    if policy.valid? && policy.save!
      flash[:notice] = "Your Policy updated successfully!"
      return redirect_to kennels_path(tab: 'policies')
    else
      error_message = "Policy failed to update:"
      flash[:notice] = error_message
      return redirect_to kennels_path(tab: 'policies')
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
    return params.require(:policy).permit(:description, :title)
  end

end
