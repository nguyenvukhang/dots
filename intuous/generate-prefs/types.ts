export type Point = { x: number; y: number }

export type Rect = {
  x1: number
  x2: number
  y1: number
  y2: number
}

export type Node =
  | {
      type: 'element'
      name: string
      attributes: { type: 'map' | 'integer' | 'double' | 'string' }
      elements?: Node[]
    }
  | {
      type: 'text'
      text: string
    }

export type RootNode = {
  declaration: {
    attributes: Record<string, string>
  }
  elements: Node[]
}

export type Predicate<T> = (_: T) => boolean
export type Operator<T> = (_: T) => void
