class SalesTaxesController < ApplicationController
  def new
    @sales_tax = SalesTax.new
  end

  def create
    sales_tax = SalesTax.new(sales_tax_params)
    kennel = Kennel.where(user_id: current_user.id).first
    if sales_tax.valid? && sales_tax.save! && kennel.sales_tax = sales_tax
      redirect_to kennel_dashboard_path
    else
      flash[:notice] = "Data did not save, please try again."
      redirect_to request.referrer
    end
  end

  private

  def sales_tax_params
    params.require(:sales_tax).permit(:percentage)
  end
end
