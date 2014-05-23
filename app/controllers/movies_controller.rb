class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = ['G', 'PG', 'PG-13', 'R']
    #debugger
    session[:order] = params[:order] unless params[:order].nil?
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
    if (params[:order].nil? and session[:order]) or (params[:ratings].nil? and session[:ratings])
      flash.keep
      redirect_to movies_path(order: session[:order], ratings: session[:ratings])
    end
    @ratings = params[:ratings] ? params[:ratings].keys : @all_ratings
    @order = params[:order]
    @movies = Movie.find_all_by_rating(@ratings, order: @order)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
