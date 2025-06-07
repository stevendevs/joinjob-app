import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    centerLat: Number,
    centerLng: Number,
    courses: String,
    searchLocation: String
  }

  connect() {
    console.log("=== MAP CONTROLLER DEBUG INFO ===");
    console.log("Map controller connected");
    console.log("Center coordinates:", this.centerLatValue, this.centerLngValue);
    console.log("Search location:", this.searchLocationValue);
    console.log("Raw courses value:", this.coursesValue);
    
    // Inicializar el mapa
    this.map = L.map('map').setView([
      this.centerLatValue || 9.35986838938843,
      this.centerLngValue || -83.65938641697076
    ], 7);

    // Agregar capa de tiles
    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(this.map);

    // DEBUG: Verificar si coursesValue existe y es válido
    if (!this.coursesValue) {
      console.error("❌ No courses data received!");
      return;
    }

    console.log("✅ Courses data received, length:", this.coursesValue.length);

    // Agregar marcadores de cursos
    try {
      const courses = JSON.parse(this.coursesValue);
      console.log("✅ Successfully parsed courses JSON");
      console.log("📊 Number of courses:", courses.length);
      console.log("📍 Full courses data:", courses);
      
      // DEBUG: Verificar cada curso individualmente
      courses.forEach((course, index) => {
        console.log(`--- Course ${index + 1}: ${course.title} ---`);
        console.log("  ID:", course.id);
        console.log("  Latitude:", course.latitude, typeof course.latitude);
        console.log("  Longitude:", course.longitude, typeof course.longitude);
        console.log("  Has valid coordinates:", !!(course.latitude && course.longitude));
        console.log("  Location:", course.location);
      });
      
      this.addCourseMarkers(courses);
    } catch (error) {
      console.error("❌ Error parsing courses data:", error);
      console.error("Raw courses value that failed:", this.coursesValue);
    }

    // Si hay una búsqueda activa, agregar marker del centro de búsqueda
    if (this.hasSearchLocationValue && this.searchLocationValue) {
      console.log("✅ Adding search marker");
      this.addSearchMarker();
    }
  }

  addCourseMarkers(courses) {
    console.log("=== ADDING COURSE MARKERS ===");
    let successCount = 0;
    let failCount = 0;

    courses.forEach((course, index) => {
      console.log(`\n--- Processing course ${index + 1}: ${course.title} ---`);
      
      // Verificar coordenadas más estrictamente
      const lat = parseFloat(course.latitude);
      const lng = parseFloat(course.longitude);
      
      console.log(`  Original lat: ${course.latitude} (${typeof course.latitude})`);
      console.log(`  Original lng: ${course.longitude} (${typeof course.longitude})`);
      console.log(`  Parsed lat: ${lat} (${typeof lat})`);
      console.log(`  Parsed lng: ${lng} (${typeof lng})`);
      console.log(`  Is lat valid: ${!isNaN(lat) && lat !== 0}`);
      console.log(`  Is lng valid: ${!isNaN(lng) && lng !== 0}`);

      if (!isNaN(lat) && !isNaN(lng) && lat !== 0 && lng !== 0) {
        try {
          console.log(`  ✅ Adding marker for ${course.title} at [${lat}, ${lng}]`);
          
          // Crear marcador con icono personalizado
          const marker = L.marker([lat, lng])
            .addTo(this.map);

          // Crear popup con información del curso
          const popupContent = `
            <div class="p-2">
              <h3 class="font-bold text-lg mb-2">${course.title}</h3>
              <p class="text-sm text-gray-600 mb-2">${course.description}</p>
              <p class="text-xs text-gray-500 mb-1"><strong>Ubicación:</strong> ${course.location}</p>
              <p class="text-xs text-gray-500 mb-2"><strong>Creador:</strong> ${course.creator}</p>
              <a href="/courses/${course.id}" class="inline-block bg-blue-500 hover:bg-blue-600 text-white px-3 py-1 rounded text-sm">
                Ver curso
              </a>
            </div>
          `;

          marker.bindPopup(popupContent);
          successCount++;
          
          console.log(`  ✅ Marker added successfully!`);
        } catch (error) {
          console.error(`  ❌ Error adding marker for ${course.title}:`, error);
          failCount++;
        }
      } else {
        console.warn(`  ⚠️  Course ${course.title} has invalid coordinates: lat=${lat}, lng=${lng}`);
        failCount++;
      }
    });

    console.log(`\n=== MARKER SUMMARY ===`);
    console.log(`✅ Successfully added: ${successCount} markers`);
    console.log(`❌ Failed to add: ${failCount} markers`);
    console.log(`📊 Total courses processed: ${courses.length}`);

    if (successCount === 0) {
      console.error("🚨 NO MARKERS WERE ADDED! Check your course coordinates in the database.");
    }
  }

  addSearchMarker() {
    console.log(`Adding search marker at ${this.centerLatValue}, ${this.centerLngValue}`);
    
    // Verificar que tenemos coordenadas válidas
    if (!this.centerLatValue || !this.centerLngValue) {
      console.error("No valid coordinates for search marker");
      return;
    }

    // Crear un marker distintivo para el centro de búsqueda
    const searchIcon = L.divIcon({
      html: '<div style="background-color: red; width: 16px; height: 16px; border-radius: 50%; border: 3px solid white; box-shadow: 0 0 4px rgba(0,0,0,0.3);"></div>',
      iconSize: [22, 22],
      iconAnchor: [11, 11],
      className: 'search-center-marker'
    });

    const searchMarker = L.marker([this.centerLatValue, this.centerLngValue], { 
      icon: searchIcon 
    }).addTo(this.map);

    searchMarker.bindPopup(`
      <div class="p-2">
        <strong>Centro de búsqueda:</strong><br>
        ${this.searchLocationValue}<br>
        <small>Lat: ${this.centerLatValue}, Lng: ${this.centerLngValue}</small>
      </div>
    `);

    // Agregar círculo de radio de búsqueda (50km)
    const searchCircle = L.circle([this.centerLatValue, this.centerLngValue], {
      color: 'red',
      fillColor: '#f03',
      fillOpacity: 0.1,
      radius: 50000, // 50km en metros
      weight: 2
    }).addTo(this.map);

    // Ajustar el zoom para que se vea bien el área de búsqueda
    this.map.fitBounds(searchCircle.getBounds(), { padding: [20, 20] });
  }

  disconnect() {
    if (this.map) {
      this.map.remove();
    }
  }
}