class MoviesController < ApplicationController
  def index
    # @movies = Movie.order("average_vote DESC") # Order by average vote in descending order # This creates n+1 problem
    @movies = Movie.includes(:production_company).all.order("average_vote DESC") # Order by average vote in descending order
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def search
    wildcard_search = "%#{params[:keywords]}%"
    @movies = Movie.where("title LIKE ?", wildcard_search)
  end
end
