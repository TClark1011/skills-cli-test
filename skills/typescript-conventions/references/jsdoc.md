# JSDoc

## Link to a reference

```typescript
/** Inspired by this {@link https://github.com/speakbox/nestjs-firebase-admin example} */
@Injectable()
export class FirebaseService {
  ...
}
```

## Documenting a function

```typescript
/**
 * Builds a full name by concatenating the given first and last names.
 *
 * @returns {string} The full name, with the first and last names separated by a space.
 */
static buildFullName(supporter: Supporter) {
  ...
}
```
