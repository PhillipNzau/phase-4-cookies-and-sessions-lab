class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    session[:page_views] ||= 0
    session[:page_views] += 1

    if (session[:page_views] < 25)
      article = Article.find(params[:id])
    render json: article
    else
      # render json: { errors: articles.errors.full_messages }, status: :unauthorized
      render json: {error:"Eceeded limit", status: 401}, status: :unauthorized
    end
   
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
