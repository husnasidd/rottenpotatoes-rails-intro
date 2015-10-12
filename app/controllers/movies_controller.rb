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
    
    # check if params[:ratings] and paramas[:sort_by] is null and the session[:ratings] 
    # and session[:sort_by] is not null
    # this is the only case when we should update the params to match the saved session
    if(params[:sort_by].nil? && params[:ratings].nil? && (!session[:sort].nil? || !session[:ratings].nil?))
      @justKeys = session[:ratings].keys()
      flash.keep(:notice)
      redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings]) and return 
    end
    
    #if both params and session are null, show all ratings unsorted
    if(params[:sort_by].nil? && params[:ratings].nil? && (session[:sort].nil? && session[:ratings].nil?))
      @movies = Movie.all
    end
    
    # if(params[:ratings] != session[:ratings])
    #   if(params[:sort_by].nil? && !session[:sort_by].nil?)
    #     @justKeys = params[:ratings].keys
    #     @movies = Movie.where(rating: @justKeys).order(session[:sort_by])
    #   end
    # end
      
    #if there is no filter for sort by 
    if(params[:sort_by].nil? && session[:sort_by].nil? || {})
      #and there is filtering by ratings then filter the movies by which ratings were choosen
      if(!params[:ratings].nil?)
        session[:ratings] = params[:ratings]
        @justKeys = session[:ratings].keys()
        @movies = Movie.where(rating: @justKeys)
      elsif(!session[:ratings].nil?)
        params[:ratings] = session[:ratings]
        @justKeys = params[:ratings].keys()
        @movies = Movie.where(rating: @justKeys)
      else
        @justKeys = @all_ratings
        @movie = Movie.all
      end
    end
    
    #if params has a filter for sort by
    if(params[:sort_by])
      if(params[:ratings])
        #set the session to match params so updated settings are remembered
        session[:sort_by] = params[:sort_by]
        session[:ratings] = params[:ratings]
        @justKeys = session[:ratings].keys
        @movies = Movie.where(rating: @justKeys).order(session[:sort_by])
      else
        session[:sort_by] = params[:sort_by]
        if(session[:ratings].nil?)
          @movies = Movie.order(session[:sort_by])
        else
          params[:ratings] = session[:ratings]
          @justKeys = params[:ratings].keys
          @movies = Movie.where(rating: @justKeys).order(session[:sort_by])
        end
      end
    else
      if(session[:sort_by])
        session[:ratings] = params[:ratings]
        params[:sort_by] = session[:sort_by]
        @justKeys = session[:ratings].keys
        @movies = Movie.where(rating: @justKeys).order(session[:sort_by])
      end
    end
      
      #hilite the title of which sort_by type was chosen
      if(params[:sort_by] == "title")
        @titleclass = "hilite"
      end
      if(params[:sort_by] == "release_date")
        @releasedateclass = "hilite"
      end
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    flash.keep
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    flash.keep
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    flash.keep
    redirect_to movies_path
  end

  def get_all_ratings
    # pluck selects one column from a table
    # uniq selects only unique values -- won't repeat the ratings 
    @all_ratings = Movie.uniq.pluck(:rating)
  end
  
  private :movie_params
  
end
