class BlogsController < ApplicationController
  http_basic_authenticate_with name: ENV["pawbookings_email"], password: ENV["pawbookings_password"], except: [:show, :blog_search, :index, :all_blogs]

  def index
    @latest_blogs = Blog.where("publish_date < ?", Date.tomorrow).limit(10).order('id desc')
    @blog_categories = BlogCategory.where("publish_date < ?", Date.tomorrow)
  end

  def new
   @blog = Blog.new
  end

  def create
    params[:blog][:publish_date] = Date.parse(sanitize_date(params[:blog][:publish_date]))
    blog = Blog.new(blog_params)
    if blog.save!
      blog.blogID = blog[:id]
      blog.save!
      redirect_to blog_path(blog[:id])
    else
      redirect_to request.referrer
    end
  end

  def show
    @blog = Blog.friendly.find(params[:id])
  end

  def edit
    if session[:blog].nil?
      @blog = Blog.find(params[:id])
    else
      @blog = Blog.find(session[:blog]["id"])
      @blog.title = session[:blog]["title"]
      @blog.body = session[:blog]["body"]
      @blog.keyword = session[:blog]["keyword"]
      @blog.publish_date = session[:blog]["publish_date"]
      @blog.blog_display_image = session[:blog]["blog_display_image"]
      flash[:notice] = "Blog did not save. Please try again."
    end
  end

  def update
    session[:blog] = nil
    blog = Blog.find(params[:id])
    blog.title = params[:blog][:title]
    blog.body = params[:blog][:body]
    blog.keyword = params[:blog][:keyword]
    blog.publish_date = params[:blog][:publish_date]
    blog.blog_display_image = params[:blog][:blog_display_image]
    if blog.save
      redirect_to blog_path(params[:id])
    else
      session[:blog] = params[:blog]
      redirect_to edit_blog_path(params[:id])
    end
  end

  def destroy
    blog = Blog.find(params[:id])
    if blog.destroy
      redirect_to blog_search_path
    else
      flash[:notice] = "This record did not delete, please try again."
      redirect_to request.referrer
    end
  end

  def blog_search
    params[:search_by] = "title" if params[:search_by] == nil
    if !params[:blog_search_text].nil?
      @blog_search_results = Blog.where("publish_date < ?", Date.tomorrow).where(params[:search_by].to_sym => params[:blog_search_text]).to_a
    end
  end

  def all_blogs
    @all_blogs = Blog.all
  end

  private

  def blog_params
    return params.require(:blog).permit(:blog_display_image, :blogID, :title, :body, :keyword, :publish_date)
  end
end
