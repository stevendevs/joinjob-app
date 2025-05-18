class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @courses = Course.all.limit(3)
    @latest_courses = Course.order(created_at: :desc).limit(3)
  end



  def newest
    @latest_courses = Course.order(created_at: :desc).limit(10)  # o la lógica que uses
    render partial: "newest_courses"
  end

  def activity
    @activities = PublicActivity::Activity.all
  end



end
