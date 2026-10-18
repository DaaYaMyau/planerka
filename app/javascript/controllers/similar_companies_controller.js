import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "frame"]
  static values = { url: String }

  search() {
    clearTimeout(this.timer)
    this.timer = setTimeout(() => {
      const url = new URL(this.urlValue, window.location.origin)
      url.searchParams.set("name", this.inputTarget.value)
      this.frameTarget.src = url.toString()
    }, 300)
  }
}
