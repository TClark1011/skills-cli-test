# Array & Object Manipulation

- Use built-in array methods (`map`, `filter`, `find`, `some`, `every`, `reduce`, `sort`) instead of manual loops.
- Use spread syntax for object composition instead of `Object.assign` or manual property assignment.

## Array methods

```typescript
const faces = ['💩', '😀', '😍', '🤤', '🤯', '🤠', '🥳'];

// Transform values
const withIndex = faces.map((v, i) => `face ${i} is ${v}`);

// Test at least one value meets a condition
const isPoopy = faces.some(v => v === '💩');

// Test all values meet a condition
const isEmoji = faces.every(v => v > 'ÿ');

// Find first matching value
const poo = faces.find(v => v === '💩');

// Filter out values
const withPoo = faces.filter(v => v === '💩');

// Reduce to a single value
const reduced = faces.reduce((acc, cur) => acc + cur);

// Sort
const numbers = [2, 3, 1, 0];
numbers.sort((a, b) => a - b); // Mutates the original array
const sorted = [...numbers].sort((a, b) => a - b); // Use spread syntax if you don't want to mutate the original array
```

## Object spread

```typescript
const pikachu = { name: 'Pikachu 🐹' };
const stats = { hp: 40, attack: 60, defense: 45 };

// ❌ Bad — manual property assignment
pikachu.hp = stats.hp;
pikachu.attack = stats.attack;
pikachu.defense = stats.defense;

// ❌ Bad — Object.assign (mutates the original `pikachu` object)
const lvl0 = Object.assign(pikachu, stats);
const lvl1 = Object.assign(pikachu, { hp: 45 });

// ✅Good — spread syntax
const lvl0 = { ...pikachu, ...stats };
const lvl1 = { ...pikachu, hp: 45 };
```
