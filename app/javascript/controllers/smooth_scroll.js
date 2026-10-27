let cancelCurrent = () => {}

// A single frame loop, never competing with CSS/native smooth scrolling.
export function smoothScrollTo(top) {
  cancelCurrent()
  const start = window.scrollY
  const target = Math.max(0, Math.min(top, document.documentElement.scrollHeight - innerHeight))
  if (matchMedia("(prefers-reduced-motion: reduce)").matches) {
    window.scrollTo({ top: target, behavior: "instant" })
    return () => {}
  }
  const duration = Math.min(950, Math.max(550, Math.abs(target - start) * 0.35))
  let frame
  let started
  const stop = () => {
    cancelAnimationFrame(frame)
    for (const type of ["wheel", "touchstart", "pointerdown", "keydown", "turbo:before-visit"]) {
      document.removeEventListener(type, stop)
    }
  }
  cancelCurrent = stop
  for (const type of ["wheel", "touchstart", "pointerdown", "keydown", "turbo:before-visit"]) {
    document.addEventListener(type, stop, { passive: true })
  }
  const tick = (now) => {
    started ??= now
    const t = Math.min(1, (now - started) / duration)
    const eased = t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2
    window.scrollTo({ top: start + (target - start) * eased, behavior: "instant" })
    if (t < 1) frame = requestAnimationFrame(tick)
    else stop()
  }
  frame = requestAnimationFrame(tick)
  return stop
}
