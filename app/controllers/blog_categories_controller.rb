class BlogCategoriesController < ApplicationController
  http_basic_authenticate_with name: "pawbookings", password: "helloworld"
  def new
    @blog_category = BlogCategory.new
  end

  def create
    blog_category = BlogCategory.new(blog_category_params)
    if blog_category.save!
      redirect_to all_blog_categories_path
    else
      redirect_to request.referrer
    end
  end

  def show
    @blogs = Blog.where("publish_date < ?", Date.tomorrow).where(keyword: params[:id])
  end

  def edit
    @blog_category = BlogCategory.find(params[:id])
  end

  def update
    blog_category = BlogCategory.find(params[:id])
    blog_category.title = params[:blog_category][:title]
    blog_category.publish_date = params[:blog_category][:publish_date]
    if blog_category.save!
      redirect_to all_blog_categories_path
    else
      redirect_to request.referrer
    end
  end

  def destroy
    blog = BlogCategory.find(params[:id])
    if blog.destroy
      redirect_to all_blog_categories_path
    else
      redirect_to request.referrer
    end
  end

  def all_blog_categories
    @all_blog_categories = BlogCategory.all
  end

  private

  def blog_category_params
    params.require(:blog_category).permit(:title, :publish_date)
  end
end
