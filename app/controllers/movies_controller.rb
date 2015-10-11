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
    
    # # check if params[:ratings] and paramas[:sort_by] is null and the session[:ratings] 
    # # and session[:sort_by] is not null
    # # this is the only case when we should update the params to match the saved session
    # if(params[:sort_by].nil? && params[:ratings].nil? && (!session[:sort].nil? || !session[:ratings].nil?))
    #   redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings]) and return 
    # # in any other case session should be updated to match params
    # end
    
    # if(params[:sort_by].nil? && params[:ratings].nil? && (session[:sort].nil? && session[:ratings].nil?))
    #   @movies = Movie.all
    # end
    
    # @ratings = params[:ratings]
    # @sort = params[:sort_by]
    # if(@ratings.nil?)
    #   @justKeys = @all_ratings
    # else
    #   @justKeys = params[:ratings].keys
    # end
    
    
    # if(!@sort.nil?)
    #   if(!@ratings.nil?)
    #     @movies = Movie.where(rating: @justKeys).order(session[:sort_by])
    #   else
    #     @movies = Movie.order(session[:sort_by])
    #   end
    # else
    #   @movies = Movie.all
    # end
     
    
    # session[:ratings] = @ratings
    # session[:sort_by] = @sort
      
    
    # if(params[:ratings].nil? && session[:ratings].nil? && params[:sort_by].nil? && session[:sort_by].nil? || {})
    #     @justKeys = @all_ratings
    #     @movies = Movie.all
    # end
    
    # if(params[:ratings].nil? && params[:sort_by].nil? && 
    #   (!session[:sort_by].nil? && !session[:ratings].nil?))
    #     params[:ratings] = session[:ratings]
    #     params[:sort_by] = session[:sort_by]
    #     @justKeys = params[:ratings].keys()
    #     redirect_to movies_path(params) and return
    # end
    
    # if(!params[:sort_by].nil?) #sort by is not null
    #   if(!params[:ratings].nil?) # ratings is not null 
    #     session[:ratings] = params[:ratings]
    #     session[:sort_by] = params[:sort_by]
    #     @justKeys = session[:ratings].keys
    #     @movies = Movie.where(rating: @justKeys).order(params[:sort_by])
    #   else #ratings is null 
    #     session[:sort_by] = params[:sort_by]
    #     @justKeys = @all_ratings
    #     @movie = Movie.order(params[:sort_by])
    #   end
    # else #sort by is null
    #   @movies = Movie.where(rating: @justKeys)
    # end
    
    # if(!params[:ratings].nil?)
    #   if(!params[:sort_by].nil?)
    #     session[:ratings] = params[:ratings]
    #     session[:sort_by] = params[:sort_by]
    #     @justKeys = session[:ratings].keys
    #     @movies = Movie.where(rating: @justKeys).order(params[:sort_by])
    #   else
    #     session[:ratings] = params[:ratings]
    #     @justKeys = params[:ratings].keys
    #     @movies = Movie.where(rating: @justKeys)
    #   end
    # else
    #   @movies = Movie.order(params[:sort_by])
    # end
    
      
        
        
      # check if params[:ratings] and paramas[:sort_by] is null and the session[:ratings] 
    # and session[:sort_by] is not null
    # this is the only case when we should update the params to match the saved session
    if(params[:sort_by].nil? && params[:ratings].nil? && (!session[:sort].nil? || !session[:ratings].nil?))
      @justKeys = session[:ratings].keys()
      redirect_to movies_path(:sort_by => session[:sort_by], :ratings => session[:ratings]) and return 
    # in any other case session should be updated to match params
    end
    
    if(params[:sort_by].nil? && params[:ratings].nil? && (session[:sort].nil? && session[:ratings].nil?))
      @movies = Movie.all
    end
    
    #sort by is null by ratings is not
    if(params[:sort_by].nil? && session[:sort_by].nil? || {})
      if(!params[:ratings].nil?)
        session[:ratings] = params[:ratings]
        @justKeys = session[:ratings].keys()
        @movies = Movie.where(rating: @justKeys)
      else
        @justKeys = @all_ratings
        @movie = Movie.all
      end
    end
    
    if(params[:sort_by])
      if(params[:ratings])
        session[:sort_by] = params[:sort_by]
        session[:ratings] = params[:ratings]
        @justKeys = session[:ratings].keys
        @movies = Movie.where(rating: @justKeys).order(session[:sort_by])
      else
        session[:sort_by] = params[:sort_by]
        if(session[:ratings].nil?)
          @movies = Movie.order(session[:sort_by])
        else
          @justKeys = session[:ratings].keys
          @movies = Movie.where(rating: @justKeys).order(session[:sort_by])
        end
      end
      
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
  
  private :movie_params
  
end
