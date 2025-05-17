# app/controllers/dashboard_controller.rb
class DashboardController < ApplicationController
  def show
    @course = Course.find_by(id: params[:course_id])
  end
end
