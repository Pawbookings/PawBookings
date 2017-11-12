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
    if policy.valid? && kennel.policies.create(
        kennel_id: kennel.id,
        title: policy.title,
        description: policy.description
      )
      if params[:create_another_policy] == "Save and Add Another Policy"
        flash[:notice] = "A new Policy was created successfully!"
        return redirect_to new_policy_path
      else
        flash[:notice] = "A new Policy was created successfully!"
        return redirect_to kennel_dashboard_path
      end
    else
      @policy = policy
      error_message = "Your Policy failed to save."
      policy.errors.full_messages.each do |err|
        error_message << " #{err}."
      end
      flash[:notice] = error_message
      return render 'new'
    end
  end

  def update
    policy = Policy.find(params[:id])
    policy.description = params[:policy][:description]
    policy.title = params[:policy][:title]
    if policy.valid? && policy.save!
      flash[:notice] = "Your Policy updated successfully!"
      redirect_to new_policy_path
    else
      @policy = policy
      error_message = "Policy failed to update:"
      policy.errors.full_messages.each do |msg|
        error_message << " #{msg}."
      end
      flash[:notice] = error_message
      return render 'new'
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
