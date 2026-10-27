import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["card"]

  next() {
    this.cardTargets.forEach((card) => {
      const slot = Number(card.dataset.slot)
      card.dataset.slot = slot === 3 ? 0 : slot + 1
    })
  }
}
