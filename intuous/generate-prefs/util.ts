import { mkdirSync, rmSync } from 'fs'
import type { Node, Predicate, Operator } from './types'

export function rmf(s: string) {
  try {
    rmSync(s, { recursive: true })
  } catch {}
}

export function mkdir(s: string) {
  try {
    mkdirSync(s, { recursive: true })
  } catch {}
}

export function apply(
  node: Node,
  predicate: Predicate<Node>,
  fn: Operator<Node>
) {
  if (predicate(node)) {
    fn(node)
  }
  if (node.type === 'element' && node.elements) {
    node.elements.forEach((v) => apply(v, predicate, fn))
  }
}

export function hasElement(node: Node, name: string, value: string): boolean {
  if (node.type !== 'element') return false
  return (node.elements || []).some(
    (e) =>
      e.type === 'element' &&
      e.name === name &&
      (e.elements || []).findIndex(
        (e) => e.type === 'text' && e.text === value
      ) >= 0
  )
}

export function exit() {
  process.exit(1)
}
