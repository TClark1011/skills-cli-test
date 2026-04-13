---
name: typescript-conventions
description: >-
  Enforces TypeScript coding conventions including naming, types, enums, JSDoc,
  code ordering, and clean code practices. Use when writing or reviewing
  TypeScript code, generating TypeScript functions or classes, or when the user
  asks about TypeScript coding standards or style.
---

# TypeScript Conventions

## Consistency

- Follow existing conventions in the codebase over these rules when they conflict.
- Use single quotes for strings (`'` not `"`).

## Naming

- Use **camelCase**, keep names short and meaningful.
- For functions use preferred action names when possible: `fetch`, `get`, `create`, `update`, `delete`, `display`, `toggle`.
- All identifiers must be written in **English**. Watch for misspellings; if a word has US/British variants, match the variant already used in the codebase.

[Naming examples](references/naming-examples.md)

## Variables

- **Never use `var`.**
- Use **`const`** by default.
- Use **`let`** only when reassignment is needed (e.g. loop counters, swaps).
- Avoid unnecessary local variables.

[Variable declaration examples](references/variables.md)

## Types & Enums

- **Always type variables** — no untyped variables, no `any`.
- Use **classes/models** for database entities.
- Use **`type`** for other object shapes.
- Use **`enum`** for fixed sets of values (roles, tabs, statuses).

[Types & Enums reference](references/enums.md)

## JSDoc

- Add JSDoc (`/** */`) to **all** functions, classes, types, and attributes.
- Include `@link` references to sources when applicable.

[JSDoc examples](references/jsdoc.md)

## Comments

- Keep short and meaningful.
- One space after `//`; start with uppercase.
- No grammar mistakes.

## Code Ordering

- Group functions by the object/entity they operate on.
- Within each group, order by action type: GetAll → GetOne → Create → Update → Delete → Others.

[Code ordering examples](references/ordering.md)

## Arrays & Objects

- Use built-in array methods (`map`, `filter`, `find`, `some`, `every`, `reduce`, `sort`) instead of manual loops.
- Use spread syntax for object composition instead of `Object.assign` or manual property assignment.

[Array & object examples](references/arrays-objects.md)

## Loops

- Prefer **`forEach`** for readability.
- Use indexed **`for`** only when performance matters on large datasets.
- Default to readability; optimise for performance only when needed.

[Loop performance reference](references/loops.md)

## Clean Code

- Remove `console.log` calls used for debugging before committing.
- Delete commented-out code segments — use version control instead.
- When copying a file as a template, remove all unused code from the original.
