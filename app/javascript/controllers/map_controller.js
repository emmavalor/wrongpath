import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="map"
export default class extends Controller {
  static values = { apiKey: String }

  connect() {

    this.map = new mapboxgl.Map({
      accessToken: this.apiKeyValue,
      container: this.element,
      center: [20.00000, 40.00000],
      zoom: 1
    })

    this.map.addControl(
      new mapboxgl.GeolocateControl({
        positionOptions: { enableHighAccuracy: true },
        trackUserLocation: true,
        showUserHeading: true
      })
    )
  }

  disconnect() {
    this.map?.remove()
  }
}
