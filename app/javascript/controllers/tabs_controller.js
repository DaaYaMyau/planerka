import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  select(event) {
    const index = this.tabTargets.indexOf(event.currentTarget)

    this.tabTargets.forEach((tab, i) => tab.setAttribute("aria-selected", i === index))
    this.panelTargets.forEach((panel, i) => { panel.hidden = i !== index })
    this.element.dataset.color = event.currentTarget.dataset.color
  }
}
