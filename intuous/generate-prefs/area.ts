import { Node, Rect } from './types'

const el = (name: string, val: number): Node => ({
  type: 'element',
  name,
  attributes: { type: 'integer' },
  elements: [{ type: 'text', text: `${val}` }],
})

const area = (name: string, x: number, y: number): Node => ({
  type: 'element',
  name,
  attributes: { type: 'map' },
  elements: [el('X', x), el('Y', y), el('Z', 0)],
})

export const getAreaElements = (rect: Rect): Node[] => {
  const calc = {
    extent: { x: rect.x2 - rect.x1, y: rect.y2 - rect.y1 },
    origin: { x: rect.x1, y: rect.y1 },
  }
  return [
    area('Extent', calc.extent.x, calc.extent.y),
    area('Origin', calc.origin.x, calc.origin.y),
  ]
}
