# Signals Patterns

### Service with encapsulated writable state

```typescript
import { Injectable, signal, computed } from '@angular/core';

@Injectable({ providedIn: 'root' })
export class CartService {
  private readonly _items = signal<CartItem[]>([]);
  readonly items = this._items.asReadonly();
  readonly total = computed(() =>
    this._items().reduce((sum, item) => sum + item.price * item.qty, 0)
  );

  add(item: CartItem) {
    this._items.update(list => [...list, item]);
  }

  remove(id: number) {
    this._items.update(list => list.filter(i => i.id !== id));
  }
}
```
