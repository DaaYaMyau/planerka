import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["list", "button"]
  static values = { step: { type: Number, default: 5 }, shown: { type: Number, default: 5 } }

  connect() {
    this.render()
  }

  more() {
    this.shownValue += this.stepValue
    this.render()
  }

  render() {
    const items = Array.from(this.listTarget.children)

    items.forEach((item, index) => { item.hidden = index >= this.shownValue })
    this.buttonTarget.hidden = items.length <= this.shownValue
  }
}
