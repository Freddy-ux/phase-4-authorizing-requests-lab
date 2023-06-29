class MembersOnlyArticlesController < ApplicationController
  before_action :require_login

  def index
    # Return the JSON data for the members-only articles
    render json: { articles: members_only_articles }
  end

  def show
    # Find the article by ID
    article = Article.find(params[:id])

    if article.is_member_only
      # Return the JSON data for the members-only article
      render json: { article: article }
    else
      # Return a 401 unauthorized status code and an error message
      render json: { error: "Unauthorized access to this article" }, status: 401
    end
  end

  private

  def require_login
    unless logged_in?
      # Return a 401 unauthorized status code and an error message
      render json: { error: "Unauthorized access. Please log in." }, status: 401
    end
  end

  def logged_in?
    # Check if the user is logged in based on the session[:user_id] presence
    session[:user_id].present?
  end

  def members_only_articles
    # Retrieve the members-only articles from the database
    Article.where(is_member_only: true)
  end
end
