import { Controller } from "@hotwired/stimulus"
import { smoothScrollTo } from "controllers/smooth_scroll"

export default class extends Controller {
  connect() {
    this.consent = this.element.querySelector(".M_Consent")
    if (this.consent?.classList.contains("M_ConsentVisible")) this.reveal()
  }

  disconnect() {
    clearTimeout(this.timer)
    this.cancelScroll?.()
  }

  reveal(event) {
    // Moving between email and checkboxes must not restart the scroll.
    if (event?.relatedTarget && this.element.contains(event.relatedTarget)) return
    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      if (!this.element.isConnected || !this.consent) return
      if (!this.element.matches(":focus-within") && !this.consent.classList.contains("M_ConsentVisible")) return
      const missing = this.consent.getBoundingClientRect().bottom + 24 - innerHeight
      if (missing > 1) this.cancelScroll = smoothScrollTo(scrollY + missing)
    }, 480)
  }
}
