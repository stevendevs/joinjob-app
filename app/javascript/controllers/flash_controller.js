// app/javascript/controllers/flash_controller.js
import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flash"
export default class extends Controller {
  static targets = ["toast"]

  connect() {
    // Animar la entrada del toast
    requestAnimationFrame(() => {
      this.toastTarget.classList.remove("translate-x-full", "opacity-0")
      this.toastTarget.classList.add("translate-x-0", "opacity-100")
    })

    // Auto-dismiss después de 4 segundos
    setTimeout(() => {
      this.dismiss()
    }, 4000)
  }

  dismiss() {
    // Animar la salida del toast
    this.toastTarget.classList.remove("translate-x-0", "opacity-100")
    this.toastTarget.classList.add(
      "translate-x-full", 
      "opacity-0",
      "transition-all", 
      "duration-300", 
      "ease-in-out"
    )

    // Remover del DOM después de la animación
    setTimeout(() => {
      if (this.toastTarget.parentNode) {
        this.toastTarget.remove()
      }
    }, 300)
  }
}