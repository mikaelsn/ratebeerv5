class RatingsController < ApplicationController

   def index
  #   if cache_does_not_contain_data_or_it_is_too_old
  #     Rails.cache.write "beer top 3", Beer.top(3)   
  #     Rails.cache.write "brewery top 3",  Brewery.top(3)   
  #     Rails.cache.write "style top 3", Style.top(3)   
  #     Rails.cache.write "rating recent 5", Rating.recent(5)   
  #     Rails.cache.write "all ratings", Rating.all
  #     end 

  #   @top_beers = Rails.cache.read "beer top 3"  
  #   @top_breweries = Rails.cache.read "brewery top 3" 
  #   @top_styles = Rails.cache.read "style top 3" 
  #   @recent_ratings = Rails.cache.read "rating recent 5" 
  #   @ratings = Rails.cache.read "all ratings" 
  

    @top_beers = Beer.top 3 
    @top_breweries = Brewery.top 3 
    @recent_ratings = Rating.recent 5  
    @ratings = Rating.all
  end

  def new
    @rating = Rating.new
    @beers = Beer.all
  end

  def create
    @rating = Rating.new params.require(:rating).permit(:score, :beer_id)

    if @rating.save
      current_user.ratings << @rating
      redirect_to user_path current_user
    else
      @beers = Beer.all
      render :new
    end
  end

  def destroy
    rating = Rating.find(params[:id])
    rating.delete if current_user == rating.user
    redirect_to :back
  end

  private
    def cache_does_not_contain_data_or_it_is_too_old
      fragment_exist?( 'ratingfragment' )
    end
end