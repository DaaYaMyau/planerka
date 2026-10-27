import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { delay: { type: Number, default: 4000 } }

  connect() {
    this.timeout = setTimeout(() => this.hide(), this.delayValue)
  }

  disconnect() {
    clearTimeout(this.timeout)
  }

  hide() {
    this.element.classList.add("M_FlashHidden")
    this.timeout = setTimeout(() => this.element.remove(), 400)
  }
}
