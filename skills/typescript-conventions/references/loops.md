# Loops

- **`forEach`** — preferred for functional style, fast.
- **`for...of`** — readable but slower; fine for small collections.
- **`for`** — fastest; use when performance matters on large datasets.
- Default to readability; optimize for performance only when needed.

## Performance Reference

Approximate performance over 1 million iterations (Node 10, desktop PC):

| Loop type | Time | Notes |
|---|---|---|
| `for (let i = 0; ...)` | ~1.6ms | Fastest forward |
| `for (let i = mil; i > 0; ...)` | ~1.5ms | Fastest overall |
| `arr.forEach(v => v)` | ~2.1ms | Fast, functional style |
| `for (const v of arr)` | ~11.7ms | Slowest, most readable |
