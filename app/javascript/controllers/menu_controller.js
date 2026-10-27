import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "menu"]

  toggle() {
    this.render(this.menuTarget.hidden)
  }

  close() {
    this.render(false)
  }

  disconnect() {
    document.documentElement.classList.remove("Q_NoScroll")
  }

  render(open) {
    this.menuTarget.hidden = !open
    this.element.toggleAttribute("data-open", open)
    this.buttonTarget.setAttribute("aria-expanded", open)
    document.documentElement.classList.toggle("Q_NoScroll", open)
  }
}
