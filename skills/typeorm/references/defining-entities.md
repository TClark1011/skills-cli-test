# Defining Entities

Always define entities in code (code-first). Always specify the column `type` explicitly. `nullable` defaults to `false` — only set it to `true` when required, and mark the TypeScript property optional too (`value?: string`).

---

## Column types

### Numbers

- **Never use `float` columns.** For decimal numbers use `decimal` columns with `precision: 10, scale: 2`.
- Apply `DecimalTransformer` to all `decimal` columns so values are returned as JS `number`, not `string`.  
  See [decimal-transformer.md](decimal-transformer.md) for the implementation and usage.
- Use `int` for integer and foreign key columns.

```ts
@Column({ type: 'int' })
organisationId!: number;

@Column({ type: 'decimal', precision: 10, scale: 2, transformer: new DecimalTransformer() })
price!: number;

@Column({ type: 'decimal', precision: 10, scale: 2, nullable: true, transformer: new DecimalTransformer() })
discount?: number;
```

### Strings

Always define `length` on `varchar` columns.

```ts
@Column({ type: 'varchar', length: 127 })
email!: string;

@Column({ type: 'text', nullable: true })
notes?: string;
```

### Enums

Always provide the referenced enum.

```ts
@Column({ type: 'enum', enum: UserRole, default: UserRole.User })
role!: UserRole;
```

### Dates

Use `@Type(() => Date)` from **class-transformer** on DTO/entity fields so that ISO date strings received from JSON requests are always parsed to `Date` instances.

```ts
import { Type } from 'class-transformer';

@Type(() => Date)
@Column({ type: 'timestamp' })
startDate!: Date;
```

Use `@CreateDateColumn` and `@UpdateDateColumn` for audit timestamps — TypeORM manages these automatically.

```ts
@CreateDateColumn()
createdAt!: Date;

@UpdateDateColumn()
updatedAt!: Date;
```

---

## Validation (class-validator)

Add `class-validator` decorators to entity/DTO classes to validate data before it reaches the database.

```ts
import { IsEmail, Length, IsEnum, IsPositive, IsOptional } from 'class-validator';

@Length(1, 127)
@IsEmail()
email!: string;

@IsEnum(UserRole)
role!: UserRole;

@IsInt()
@Min(0)
amount!: number;

@IsOptional()
@Length(0, 500)
notes?: string;
```

---

## Relationships

- Define all relationships on at least one side.
- For `ManyToOne`, define on the "many" side.
- Always name `name`, `referencedColumnName`, and `foreignKeyConstraintName`.
- `foreignKeyConstraintName` convention: `FK_{{CurrentEntity}}_{{TargetEntity}}`

```ts
@ManyToOne(() => Organisation)
@JoinColumn({
  name: 'organisationId',
  referencedColumnName: 'id',
  foreignKeyConstraintName: 'FK_User_Organisation'
})
organisation: Organisation;
```

---

## Indexes

Add `@Index()` to columns that are frequently filtered or sorted on to improve query performance.

```ts
@Index()
@Column({ type: 'varchar', length: 127 })
email!: string;

// Composite index at entity level
@Index(['lastName', 'firstName'])
@Entity()
export class User { ... }
```

## Other best practices

- Use `!` to mark non-nullable properties to satisfy Typescript `strictPropertyInitialization` rule.
