---
name: nestjs-module
description: 
  Scaffolds a complete NestJS module with TypeORM entity, service, controller,
  and DTOs following established project patterns. Use when creating a new NestJS
  module, generating CRUD endpoints, scaffolding a resource, adding a new entity,
  or setting up TypeORM with a NestJS service and controller.
---

# NestJS Module Scaffolding

Generates a full NestJS module: entity, service, controller, and DTOs with TypeORM. All code must follow strict TypeScript and ESLint standards.

## Template Variables

| Variable | Format | Example |
|---|---|---|
| `{{ModuleName}}` | PascalCase | `Product` |
| `{{moduleName}}` | camelCase | `product` |
| `{{module-name}}` | kebab-case | `product` |
| `{{TABLE_NAME}}` | Entity table name | `Example_Product` |
| `{{entityFields}}` | Generated from SQL schema | — |
| `{{dtoFields}}` | Generated from SQL schema with validations | — |
| `{{searchableFields}}` | Fields searchable via `?search=` | — |
| `{{sortableFields}}` | Fields allowed in `?sortBy=` | — |

## File Structure

```
server/src/{{module-name}}/
├── {{module-name}}.module.ts
├── {{module-name}}.controller.ts
├── {{module-name}}.service.ts
├── entities/
│   └── {{module-name}}.entity.ts
└── dtos/
    ├── create-{{module-name}}.dto.ts
    ├── update-{{module-name}}.dto.ts
    └── query-{{module-name}}.dto.ts
```

## Naming Conventions

| Concern | Pattern | Example |
|---|---|---|
| Entity table | `Example_{{ModuleName}}` | `Example_Product` |
| Controller route | `examples/{{module-name}}s` | `examples/products` |
| FK constraint | `FK_{{TABLE_NAME}}_{{column}}_{{RefTable}}_{{refCol}}` | — |
| Index | `IDX_{{TABLE_NAME}}_{{column}}` | — |
| Files | kebab-case | `product-category.service.ts` |
| Classes | PascalCase | `ProductCategoryService` |
| Variables | camelCase | `productCategoryService` |

## Integration Steps

1. Add the new module to `examples.module.ts` imports
2. Create a TypeORM migration if schema changes are needed
3. Update routing in the Angular app (see Angular rules)

## Reference Files

All file paths are relative to this skill's directory.
- Code templates for all generated files: [references/templates.md](references/templates.md)
- SQL-to-TypeORM field mapping rules: [references/sql-field-mapping.md](references/sql-field-mapping.md)
- Exhaustive coding standards (imports, error handling, validation, DB, query, controller): [references/standards.md](references/standards.md)
