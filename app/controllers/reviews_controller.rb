class ReviewsController < ApplicationController

  def create
    @user = current_user
    @review = Review.new(place_id: params[:place_id], user_id: @user.id, body: params[:review])
    if @review.save
      render json: @review.to_json(include: :user)
    end
  end

end
