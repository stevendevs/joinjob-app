import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  connect() {
    this.contentTarget = document.querySelector('main')
    this.setInitialState()

    window.addEventListener('resize', () => this.setInitialState())
  }

  disconnect() {
    window.removeEventListener('resize', () => this.setInitialState())
  }

  toggleMenu() {
    this.menuTarget.classList.toggle("hidden")
    this.updatePadding()
  }

  setInitialState() {
    if (window.innerWidth >= 768) {
      this.menuTarget.classList.remove("hidden")
      this.contentTarget.classList.add("pt-14")
      this.contentTarget.classList.remove("pt-24")
    } else {
      this.menuTarget.classList.add("hidden")
      this.contentTarget.classList.add("pt-14")
      this.contentTarget.classList.remove("pt-24")
    }
  }

  updatePadding() {
    if (window.innerWidth < 768) {
      if (this.menuTarget.classList.contains("hidden")) {
        this.contentTarget.classList.add("pt-14")
        this.contentTarget.classList.remove("pt-24")
      } else {
        this.contentTarget.classList.add("pt-24")
        this.contentTarget.classList.remove("pt-14")
      }
    }
  }
}
