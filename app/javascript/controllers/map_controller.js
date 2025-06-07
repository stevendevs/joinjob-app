// app/javascript/controllers/map_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { x: Number, y: Number, data: Array }

  connect() {
    console.log("Map controller connected");
    console.log("X Value:", this.xValue);
    console.log("Y Value:", this.yValue);
    console.log("Data Value:", this.dataValue);

    let xMap = 9.35986838938843
    let yMap = -83.65938641697076

    if (this.xValue && this.yValue && this.xValue !== 0 && this.yValue !== 0) {
      xMap = this.xValue
      yMap = this.yValue
    }

    console.log("Final map coordinates:", xMap, yMap);

    this.map = L.map('map').setView([xMap, yMap], 10); // Cambié zoom a 10 para ver mejor
    L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
      maxZoom: 19,
      attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
    }).addTo(this.map);
    
    if (this.hasDataValue && this.dataValue.length > 0) {
      console.log("Adding markers for", this.dataValue.length, "courses");
      
      this.dataValue.forEach((item, index) => {
        console.log(`Processing course ${index + 1}:`, item);
        
        // 🔧 CAMBIAR ESTA PARTE - usar latitude/longitude O x/y
        let lat, lng;
        
        // Intentar ambos formatos
        if (item.latitude && item.longitude) {
          lat = item.latitude;
          lng = item.longitude;
        } else if (item.x && item.y) {
          lat = item.x;
          lng = item.y;
        }
        
        if (lat && lng && lat !== 0 && lng !== 0) {
          console.log(`Adding marker at [${lat}, ${lng}] for course:`, item.title || 'Unknown');
          
          const marker = L.marker([lat, lng]).addTo(this.map);
          
          // Popup mejorado
          const popupContent = item.popupMessage || `
            <div style="min-width: 200px;">
              <strong style="font-size: 16px;">${item.title || 'Course'}</strong><br>
              <small style="color: #666;">${item.location || 'No location'}</small>
            </div>
          `;
          
          marker.bindPopup(popupContent);
        } else {
          console.warn("Skipping course with invalid coordinates:", item);
        }
      });
      
      // Ajustar el mapa para mostrar todos los marcadores
      if (this.dataValue.length > 0) {
        const group = new L.featureGroup(this.map._layers);
        if (Object.keys(group._layers).length > 0) {
          this.map.fitBounds(group.getBounds().pad(0.1));
        }
      }
    } else {
      console.log("No course data available for markers");
    }
  }

  disconnect() {
    if (this.map) {
      this.map.remove();
    }
  }
}