# Variable Declarations

- **Never use `var`.**
- Use **`const`** by default.
- Use **`let`** only when reassignment is needed (e.g. loop counters, swaps).
- Avoid unnecessary local variables.

## const vs let

```typescript
// Bad — uses let when const would work
getUsers() {
  let users = buildUsersArray();
  for (let user of users) {
    // manipulate user
  }
  return users;
}

// Good
getUsers() {
  const users = buildUsersArray();
  for (const user of users) {
    // manipulate user
  }
  return users;
}
```

## Avoid unnecessary locals

```typescript
// Bad
getUsers() {
  const users = buildUsersArray();
  return users;
}

// Good
getUsers() {
  return buildUsersArray();
}
```
