class PoliciesController < ApplicationController
  before_action :authenticate_user!

  def new
    @policy = Policy.new
    if params[:mobile].nil?
      respond_to do |format|
        format.html
        format.js
      end
    else
      @policy_create = params[:policy_create]
    end
  end

  def edit
    @policy = Policy.find(params[:id])
    if params[:mobile].nil?
      respond_to do |format|
        format.html
        format.js
      end
    else
      @policy_update = params[:policy_update]
      @policy_id = params[:policy_id]
    end
  end

  def create
    policy = Policy.new(policy_params)
    if policy.valid? && kennel.policies.create(
        kennel_id: kennel.id,
        title: policy.title,
        description: policy.description
      )
      flash[:notice] = "A new Policy was created successfully!"
      return redirect_to kennels_path(tab: 'policies', policy_create: nil)
    else
      error_message = []
      policy.errors.each do |attr,err|
        error_message << attr
      end
      if params[:policy][:mobile] != 'true'
        redirect_to kennels_path(tab: 'policies', policy_create: error_message.uniq)
      else
        redirect_to new_policy_path(mobile: true, policy_create: error_message.uniq)
      end
    end
  end

  def update
    policy = Policy.find(params[:id])
    policy.description = params[:policy][:description]
    policy.title = params[:policy][:title]
    if policy.valid? && policy.save
      flash[:notice] = "Your Policy updated successfully!"
      return redirect_to kennels_path(tab: 'policies', policy_update: nil)
    else
      error_message = []
      policy.errors.each do |attr, err|
        error_message << attr
      end
      if params[:policy][:mobile] != 'true'
        redirect_to kennels_path(tab: 'policies', policy_update: error_message.uniq, policy_id: policy.id)
      else
        redirect_to edit_policy_path(policy_update: error_message.uniq, policy_id: policy.id, mobile: true)
      end
    end
  end

  def destroy
    Policy.find(params[:id]).delete
    redirect_to kennels_path(tab: 'policies')
  end

  private

  def policy_params
    return params.require(:policy).permit(:description, :title)
  end

  def kennel
    Kennel.where(user_id: current_user.id).last
  end
end
