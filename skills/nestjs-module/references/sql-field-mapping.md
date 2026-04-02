# SQL-to-TypeORM Field Mapping

## String Fields

| SQL | TypeORM | DTO Validators |
|---|---|---|
| `varchar(N)` | `@Column({ type: 'varchar', length: N })` | `@IsString()`, `@IsNotEmpty()`, `@MaxLength(N)` |
| `text` | `@Column({ type: 'text' })` | `@IsString()`, `@IsNotEmpty()` |

## Numeric Fields

| SQL | TypeORM | DTO Validators |
|---|---|---|
| `int` | `@Column({ type: 'int' })` | `@IsInt()` |
| `decimal(P,S)` | `@Column({ type: 'decimal', precision: P, scale: S })` | `@IsNumber()` |

## Date Fields

| SQL | TypeORM | DTO Validators |
|---|---|---|
| `datetime` | `@Column({ type: 'datetime' })` | `@IsDateString()` |
| `date` | `@Column({ type: 'date' })` | `@IsDateString()` |

## Boolean Fields

| SQL | TypeORM | DTO Validators |
|---|---|---|
| `tinyint(1)` | `@Column({ type: 'boolean' })` | `@IsBoolean()` |

## Foreign Key Fields

Generate both a scalar FK column and a relation property:

```typescript
// Scalar FK column
@Column({ type: 'int' })
companyId!: number;

// Relation (always at the end of the class)
@ManyToOne(() => Company, { onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
@JoinColumn({
  name: 'companyId',
  referencedColumnName: 'id',
  foreignKeyConstraintName: 'FK_{{TABLE_NAME}}_companyId_Company_id',
})
company!: Company;
```
