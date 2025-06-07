class ExploreController < ApplicationController
    def show
      Rails.logger.info "=== EXPLORE CONTROLLER DEBUG ==="
      
      # Siempre obtener TODOS los cursos para el mapa
      @all_courses = Course.all
      Rails.logger.info "📊 Total courses in database: #{@all_courses.count}"
      
      # Inicializar @courses (para mostrar en la lista/info) con todos los cursos por defecto
      @courses = Course.all
      
      # Coordenadas por defecto (San José, Costa Rica)
      @center_lat = 9.9281
      @center_lng = -84.0907
      
      if params[:location].present?
        Rails.logger.info "🔍 Location search: #{params[:location]}"
        begin
          results = Geocoder.search(params[:location])
          if results.first
            @map_coordinates = results.first.coordinates
            @center_lat = @map_coordinates[0]
            @center_lng = @map_coordinates[1]
            
            Rails.logger.info "✅ Geocoded location: #{params[:location]} to #{@center_lat}, #{@center_lng}"
            
            # Buscar cursos cerca de la ubicación SOLO para la lista/información
            # pero mantener todos los cursos para el mapa
            if Course.respond_to?(:near)
              @courses = Course.near(params[:location], 50)
              Rails.logger.info "✅ Found #{@courses.count} courses near #{params[:location]}"
            else
              # Si no tienes geocoder configurado aún, mantener todos los cursos
              @courses = Course.all
              Rails.logger.warn "⚠️  Geocoder not configured for Course model"
            end
          else
            # Si no se encuentra la ubicación, mostrar todos los cursos
            @courses = Course.all
            Rails.logger.warn "⚠️  No results found for location: #{params[:location]}"
          end
        rescue => e
          # En caso de error con geocoder, mostrar todos los cursos
          @courses = Course.all
          Rails.logger.error "❌ Geocoder error: #{e.message}"
        end
      end
      
      # DEBUG: Verificar coordenadas de cada curso
      Rails.logger.info "=== COURSE COORDINATES DEBUG ==="
      @all_courses.each_with_index do |course, index|
        Rails.logger.info "Course #{index + 1}: #{course.title}"
        Rails.logger.info "  ID: #{course.id}"
        Rails.logger.info "  Location: #{course.location}"
        Rails.logger.info "  Latitude: #{course.latitude} (#{course.latitude.class})"
        Rails.logger.info "  Longitude: #{course.longitude} (#{course.longitude.class})"
        Rails.logger.info "  Has coordinates: #{!!(course.latitude && course.longitude)}"
        Rails.logger.info "  Valid coordinates: #{course.latitude.present? && course.longitude.present? && course.latitude != 0 && course.longitude != 0}"
      end
      
      # Preparar datos de TODOS los cursos para el mapa (no solo los filtrados)
      geocoded_courses = @all_courses.where.not(latitude: nil, longitude: nil)
      
      Rails.logger.info "📍 Found #{geocoded_courses.count} geocoded courses for map"
      
      # DEBUG: Verificar qué cursos se están filtrando
      excluded_courses = @all_courses.where(latitude: nil).or(@all_courses.where(longitude: nil))
      if excluded_courses.any?
        Rails.logger.warn "⚠️  Excluded courses without coordinates:"
        excluded_courses.each do |course|
          Rails.logger.warn "  - #{course.title} (ID: #{course.id})"
        end
      end
      
      @courses_data = geocoded_courses.map do |course|
        course_data = {
          id: course.id,
          title: course.title,
          description: course.description.to_plain_text.truncate(100),
          latitude: course.latitude.to_f,
          longitude: course.longitude.to_f,
          location: course.location,
          creator: course.user&.email || 'Usuario desconocido'
        }
        
        Rails.logger.info "✅ Prepared course data: #{course.title} -> lat: #{course_data[:latitude]}, lng: #{course_data[:longitude]}"
        course_data
      end.to_json
      
      Rails.logger.info "📦 Final courses data JSON length: #{@courses_data.length}"
      Rails.logger.info "📦 Final courses data preview: #{@courses_data.truncate(200)}"
      
    rescue => e
      # Manejo de errores general
      Rails.logger.error "❌ General error in ExploreController#show: #{e.message}"
      Rails.logger.error "❌ Backtrace: #{e.backtrace.first(5).join(', ')}"
      @all_courses = Course.all || []
      @courses = Course.all || []
      @center_lat = 9.9281
      @center_lng = -84.0907
      @courses_data = [].to_json
    end
  end