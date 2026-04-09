# Migrations

## Creating a migration file

Use the script bundled inside this skill folder to create a new migration file:

```bash
bash scripts/create-migration-file.sh <path-to-migrations-folder> <migration-name>
```

- Migration name should be `kebab-case`, short and descriptive (e.g. `user-table`, `nicknames-nullable`)
- The script generates a timestamped file with a PascalCase class name

Example:

```bash
bash scripts/create-migration-file.sh src/migrations add-user-table
# Created: src/migrations/1744123456789-add-user-table.ts
```
---

## Imports inside migration files

Always use relative imports — path aliases will break at migration runtime.

```ts
// ✅ Relative imports
import { SomeImport } from './../../relative/path/to/file';

// 💩 Alias/absolute imports will break
import { SomeImport } from 'src/absolute/path/to/file';
```
