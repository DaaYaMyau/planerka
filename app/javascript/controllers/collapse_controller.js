import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "button", "label"]
  static values = { limit: { type: Number, default: 3 }, expanded: Boolean }

  connect() {
    this.render()
  }

  toggle() {
    this.expandedValue = !this.expandedValue
    this.render()
  }

  render() {
    const items = Array.from(this.listTarget.children)

    items.forEach((item, index) => {
      item.hidden = !this.expandedValue && index >= this.limitValue
    })

    this.buttonTarget.hidden = items.length <= this.limitValue
    this.buttonTarget.setAttribute("aria-expanded", this.expandedValue)
    this.labelTarget.textContent = this.expandedValue ? "свернуть" : `показать все (${items.length})`
  }
}
