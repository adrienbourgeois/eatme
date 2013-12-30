class ReviewsController < ApplicationController

  before_action :check_user_rights, only: [:create]

  def create
    sleep 3
    @user = current_user
    @review = Review.new(place_id: params[:place_id], user_id: @user.id, body: params[:review], note: params[:score])
    if Review.where(place_id: @review.place_id, user_id: @review.user_id).exists?
      render json: REVIEW_ALREADY_EXISTS_MESSAGE.to_json
    else
      if @review.save
        render json: @review.to_json(include: :user)
      else
        render json: @review.errors.to_json
      end
    end
  end

  private

  def check_user_rights
    redirect_to root_path unless current_user
  end
end
