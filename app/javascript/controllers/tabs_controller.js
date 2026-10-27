import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  select(event) {
    this.show(this.tabTargets.indexOf(event.currentTarget))
  }

  previous() {
    this.show((this.current() - 1 + this.tabTargets.length) % this.tabTargets.length)
  }

  next() {
    this.show((this.current() + 1) % this.tabTargets.length)
  }

  current() {
    return this.tabTargets.findIndex((tab) => tab.getAttribute("aria-selected") === "true")
  }

  show(index) {
    this.tabTargets.forEach((tab, i) => tab.setAttribute("aria-selected", i === index))
    this.panelTargets.forEach((panel, i) => { panel.hidden = i !== index })
    this.element.dataset.color = this.tabTargets[index].dataset.color
  }
}
