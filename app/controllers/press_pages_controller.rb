class PressPagesController < ApplicationController
  http_basic_authenticate_with name: ENV["pawbookings_email"], password: ENV["pawbookings_password"], except: [:index, :show]

  def index
    @press_pages = PressPage.all
  end

  def new
    @press_page = PressPage.new
  end

  def create
    @press_page = PressPage.new(press_page_params)
    if @press_page.save
      flash[:notice] = "Your entry was saved successfully!"
      return redirect_to pawbookings_admins_path
    else
      flash[:notice] = "Something went wrong. Please try again."
      render("new")
    end
  end

  def show
  end

  def edit
    @press_page = PressPage.find(params[:id])
  end

  def update
    @press_page = PressPage.find(params[:id])
    if @press_page.update_attributes(press_page_params)
      flash[:notice] = "Your entry was update successfully!"
      return redirect_to pawbookings_admins_path
    else
      flash[:notice] = "Something went wrong. Please try again"
      render("edit")
    end
  end

  def destroy
    pp = PressPage.find(params[:id])
    if pp.delete
      flash[:notice] = "Your entry was deleted successfully!"
      return redirect_to pawbookings_admins_path
    else
      flash[:notice] = "Something went wrong. Please try again."
      return redirect_to request.referrer
    end
  end

  private

  def press_page_params
    params.require(:press_page).permit(:title, :body, :link_to_press)
  end
end
