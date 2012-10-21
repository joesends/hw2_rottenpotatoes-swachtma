class MoviesController < ApplicationController
  
  before_filter :apply_session_filter, :only => :index
  after_filter :update_session_filter, :only => :index 
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings

    @movies = Movie.order(params[:sort])

    @movies =  @movies.where(:rating => params[:ratings].keys) unless params[:ratings].nil? 
      
    @title_hilite = "hilite" if params[:sort] == "title"
    @release_date_hilite = "hilite" if params[:sort] == "release_date"
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

private

  def update_session_filter
    session[:sort] = params[:sort] unless params[:sort].nil?
    session[:ratings] = params[:ratings] unless params[:ratings].nil?
  end

  def apply_session_filter
    if params[:sort].nil? and params[:rating].nil?
      if params[:sort].nil?
        params[:sort] = session[:sort] unless session[:sort].nil?
      end

      if params[:ratings].nil?
        params[:ratings] = session[:ratings] unless session[:ratings].nil?
      end

      flash.keep
      redirect_to movies_path(params)
    end
  end

end