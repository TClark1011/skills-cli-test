# DecimalTransformer

Use this transformer on all `decimal` columns so that values are parsed back to JavaScript `number` types (TypeORM returns decimals as strings by default).

## Implementation

```ts
import { ValueTransformer } from 'typeorm';

export class DecimalTransformer implements ValueTransformer {

  to(data: number): number {
    return data;
  }

  from(data: string): number {
    return parseFloat(data);
  }
}
```

Place this file at a shared path (e.g. `src/common/helpers/decimal.transformer.ts`) and import it where needed.

## Usage on a column

```ts
import { DecimalTransformer } from '../../common/helpers/decimal.transformer';

@Column({ type: 'decimal', precision: 10, scale: 2, transformer: new DecimalTransformer() })
amount: number;
```
