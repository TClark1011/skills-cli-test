# Code Ordering

For files with many functions/methods order by:

1. **Primary**: Group functions by the object/entity they operate on.
2. **Secondary**: Within each group, sort by action type: GetAll → GetOne → Create → Update → Delete → Others

```typescript
// Bad — no grouping, no action ordering
createPokemon()
getTrainers()
deletePokemon()
getPokemons()

// OK — grouped by entity, but actions unordered
// Trainers
getTrainers()
// Pokemons
createPokemon()
deletePokemon()
getPokemons()

// Good — grouped by entity, actions ordered (get → create → delete)
// Trainers
getTrainers()
// Pokemons
getPokemons()
createPokemon()
deletePokemon()
```
