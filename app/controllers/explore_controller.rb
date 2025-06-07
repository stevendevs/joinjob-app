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
        
        # 🔧 SOLUCIÓN: Usar filtro manual en lugar de Course.near()
        search_lat = @center_lat
        search_lng = @center_lng
        radius_km = 50
        
        # Opción 1: Filtro en Ruby (más lento pero funciona siempre)
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
        
        # Opción 2: Si quieres usar SQL (más rápido), descomenta esto y comenta lo de arriba:
        # @courses = @courses.where(
        #   "ST_DWithin(
        #     ST_Point(longitude, latitude)::geography,
        #     ST_Point(?, ?)::geography,
        #     ?
        #   )",
        #   search_lng, search_lat, radius_km * 1000 # metros
        # ) # Solo si tienes PostGIS instalado
        
        # Opción 3: Fórmula Haversine manual en SQL (si no tienes PostGIS)
        # @courses = Course.where("
        #   (6371 * acos(
        #     cos(radians(?)) *
        #     cos(radians(latitude)) *
        #     cos(radians(longitude) - radians(?)) +
        #     sin(radians(?)) *
        #     sin(radians(latitude))
        #   )) <= ?",
        #   search_lat, search_lng, search_lat, radius_km
        # ).where.not(latitude: nil, longitude: nil)
        
      else
        # Si no se encuentra la ubicación, usar coordenadas por defecto
        @center_lat = 9.9281
        @center_lng = -84.0907
      end
    else
      # Sin búsqueda, usar coordenadas por defecto de Costa Rica
      @center_lat = 9.9281
      @center_lng = -84.0907
    end
    
    # Preparar datos para el mapa JavaScript
    @courses_data = @courses.map do |course|
      {
        id: course.id,
        title: course.title,
        x: course.latitude.to_f,    # Tu JS busca 'x' para latitud
        y: course.longitude.to_f,   # Tu JS busca 'y' para longitud
        latitude: course.latitude.to_f,  # También incluir formato estándar
        longitude: course.longitude.to_f,
        location: course.location,
        popupMessage: "<div style='min-width: 200px;'><strong style='font-size: 16px;'>#{course.title}</strong><br><small style='color: #666;'>#{course.location}</small></div>"
      }
    end
    
    # Variables para compatibilidad con tu vista
    @map_x = @center_lat
    @map_y = @center_lng
    @listing_data = @courses_data
    
    # Debug logging
    Rails.logger.info "📍 Search location: #{params[:location]}"
    Rails.logger.info "📍 Center coordinates: #{@center_lat}, #{@center_lng}"
    Rails.logger.info "📍 Found courses: #{@courses.count}"
  end
end