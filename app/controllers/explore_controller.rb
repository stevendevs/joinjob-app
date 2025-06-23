
# app/controllers/explore_controller.rb
class ExploreController < ApplicationController
  def show
    @courses = Course.where.not(latitude: nil, longitude: nil)
    
    if params[:location].present?
      results = Geocoder.search(params[:location])
      if results.first
        @map_coordinates = results.first.coordinates
        @center_lat = @map_coordinates[0]
        @center_lng = @map_coordinates[1]
        
        # Filtro por proximidad
        search_lat = @center_lat
        search_lng = @center_lng
        radius_km = 50
        
        # Filtro en Ruby
        @courses = @courses.select do |course|
          if course.latitude.present? && course.longitude.present?
            distance = Geocoder::Calculations.distance_between(
              [search_lat, search_lng], 
              [course.latitude, course.longitude]
            )
            distance <= radius_km
          else
            false
          end
        end
      else
        @center_lat = 9.9281
        @center_lng = -84.0907
      end
    else
      @center_lat = 9.9281
      @center_lng = -84.0907
    end
    
    # Datos simplificados para el mapa - el popup_message se maneja en el partial
    @courses_data = @courses.map do |course|
      {
        id: course.id,
        x: course.latitude.to_f,
        y: course.longitude.to_f,
        # El popup_message ahora se renderiza desde el partial directamente
        popupMessage: render_to_string(
          partial: "courses/popup_message", 
          locals: { course: course }
        )
      }
    end
    
    @map_x = @center_lat
    @map_y = @center_lng
  end
end