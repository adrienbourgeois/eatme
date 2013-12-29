class ReviewsController < ApplicationController

  before_action :check_user_rights, only: [:create]

  def create
    @user = current_user
    @review = Review.new(place_id: params[:place_id], user_id: @user.id, body: params[:review])
    if @review.save
      render json: @review.to_json(include: :user)
    end
  end

  private

  def check_user_rights
    redirect_to root_path unless current_user
  end
end
