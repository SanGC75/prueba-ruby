import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["submitBtn"]

  connect() {
  }

  disableButton() {
    this.submitBtnTarget.value = "Cargando..."
    this.submitBtnTarget.classList.add("opacity-50", "cursor-not-allowed")
  }
}