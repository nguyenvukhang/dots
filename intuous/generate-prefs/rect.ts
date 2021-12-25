export class Rect {
  w: number
  h: number
  r: number // aspect ratio (width:height)
  x: [number, number]
  y: [number, number]

  w2h = (width: number) => width / this.r
  h2w = (height: number) => height * this.r
  err = (m: string) => `Invalid dimensions: ${m}`

  constructor(w: number, h: number, r: number) {
    this.w = w
    this.h = h
    this.r = r
    this.x = [0, w]
    this.y = [0, h]
  }

  setHorizontalMargin(mx: number) {
    this.x[0] = mx
    this.y[0] = (this.h - this.w2h(this.w - 2 * mx)) / 2
    this.x[1] = this.w - this.x[0]
    this.y[1] = this.h - this.y[0]
  }

  /**
   * Draw from (`xr`, `yr`), with width of `wr`. All parameters are ratios
   * of the total width and height
   */
  setByRatio(xr: number, yr: number, wr: number) {
    const width = wr * this.w
    const height = this.w2h(width)
    const x = this.w * xr
    const y = this.h * yr
    if (x + width > this.w) throw new Error(this.err('width overflow'))
    if (y + height > this.h) throw new Error(this.err('height overflow'))
    this.x = [x, x + width]
    this.y = [y, y + height]
  }

  /**
   * Centers the rectangle at the ratio of the screen width
   */
  setCenterByRatio(r: number) {
    if (r > 1) return
    const width = this.w * r
    const height = this.w2h(width)
    const { w, h } = this
    if (height > this.h) throw new Error(this.err('height overflow'))
    this.x = [w / 2 - width / 2, w / 2 + width / 2]
    this.y = [h / 2 - height / 2, h / 2 + height / 2]
  }

  export = () => {
    const r = Math.round
    return {
      x1: r(this.x[0]),
      x2: r(this.x[1]),
      y1: r(this.y[0]),
      y2: r(this.y[1]),
    }
  }
}

const s = { width: 3024, height: 1964 }
s.width /= 2
s.height /= 2

export const rect = new Rect(s.width, s.height, 1.6)
