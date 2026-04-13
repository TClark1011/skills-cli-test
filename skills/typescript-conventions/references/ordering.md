# Code Ordering

```typescript
// ❌ Bad — no grouping, no action ordering
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

// ✅ Good — grouped by entity, actions ordered (get → create → delete)
// Trainers
getTrainers()
// Pokemons
getPokemons()
createPokemon()
deletePokemon()
```
