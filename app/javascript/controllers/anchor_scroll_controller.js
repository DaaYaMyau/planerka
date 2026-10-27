import { Controller } from "@hotwired/stimulus"
import { smoothScrollTo } from "controllers/smooth_scroll"

export default class extends Controller {
  navigate(event) {
    if (event.defaultPrevented || event.button !== 0 || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) return
    const link = event.target.closest('a[href^="#"]')
    if (!link) return
    let id
    try { id = decodeURIComponent(link.hash.slice(1)) } catch { return }
    const target = document.getElementById(id)
    if (!target) return
    event.preventDefault()
    event.stopPropagation()
    const header = document.querySelector(".O_HeaderNavigation, .O_MenuBar")
    const offset = (header?.getBoundingClientRect().height || 0) + 24
    history.pushState(null, "", link.hash)
    this.cancelScroll = smoothScrollTo(scrollY + target.getBoundingClientRect().top - offset)
  }

  disconnect() { this.cancelScroll?.() }
}
