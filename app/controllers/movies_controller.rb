class MoviesController < ApplicationController

  # See Section 4.5: Strong Parameters below for an explanation of this method:
  # http://guides.rubyonrails.org/action_controller_overview.html
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    get_all_ratings()
    get_checked_boxes()
    
    if(params[:ratings])
      #:ratings is a hash of the rating which is passed in
      @ratingshash = params[:ratings]
      #justKeys should be something like [G,PG13]
      #if you call keys on a hash it will return just keys 
      @justKeys = @ratingshash.keys
      @movies = Movie.where(rating: @justKeys)
    
    else
      @movies = Movie.all
      @justKeys = @all_ratings
    end

    #if sort by was set to "title" then order by the titles
      if(params[:sort_by] == "title")
        @movies = Movie.order(:title)
        @titleclass = "hilite"
      end
      
      #if sort_by was set to release date then order by release date
      if(params[:sort_by] == "release_date")
        @movies = Movie.order(:release_date)
        @releasedateclass = "hilite"
      end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def get_all_ratings
    # pluck selects one column from a table
    # uniq selects only unique values -- won't repeat the ratings 
    @all_ratings = Movie.uniq.pluck(:rating)
  end
  
  def get_checked_boxes
    @check_box_hash = Hash.new
    @check_box_hash = {"PG" => true ,"PG13" => true , "G" => true, "R" => true}
    # @ratingshash = params[:ratings]
    # @check_box_hash = {@ratingshash}
    # for element in @check_box_hash
    #   if(element.value == 1)
    #     then element.value = true
      
  
  end
  
  private :movie_params
  
end
