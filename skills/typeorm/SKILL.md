---
name: typeorm
description: Guide for writing TypeORM entities, columns, relationships, and migrations following project conventions. Use when creating or editing TypeORM entities, writing migrations, defining relationships, or working with the database layer.
---

# TypeORM

## Entities

For column types, validation, relationships, and indexes, see [references/defining-entities.md](references/defining-entities.md).

---

## Transactions

Wrap multi-step database operations in a transaction to guarantee atomicity.

```ts
await dataSource.transaction(async (manager) => {
  await manager.save(user);
  await manager.save(order);
});
```

When using custom repositories inside a transaction, use `manager.withRepository()`.

---

## Migrations

For creating migrations see [references/migrations.md](references/migrations.md).

---

## Additional best practices

- Use `select: false` on sensitive columns (e.g. password hashes) so they are not returned by default queries.
- Avoid N+1 queries: use `relations` in `find` options or eager-load via `QueryBuilder` with explicit `leftJoinAndSelect`.
- Use `QueryBuilder` for complex filtering, sorting, or aggregation rather than chaining many `find` options.
- Avoid excessive joins that would significantly impact performance; prefer targeted queries over loading entire object graphs.
- Never pass raw user input directly into query strings — use parameterised queries or TypeORM's built-in query builder bindings.
- Use `!` to mark non-nullable properties to satisfy Typescript `strictPropertyInitialization` rule.
