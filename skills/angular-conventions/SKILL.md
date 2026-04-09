---
name: angular-conventions
description: Applies project Angular coding conventions when generating or modifying Angular code. Use when creating Angular components, services, forms, or state management, or when the user asks to follow Angular project structure standards.
---

# Angular Conventions

## File Structure

Max **2 sublevels** inside `app/`:

```
src/app/
├── auth/
├── pokemons/
│   ├── pokemons.component.ts
│   ├── pokemons.component.html
│   ├── pokemons.component.scss
│   ├── pokemons.service.ts
│   └── pokemon/                 ← child component (1 sublevel)
│       ├── pokemon.component.ts
│       ├── pokemon.component.html
│       └── pokemon.component.scss
├── shared/                      ← components used across multiple features
├── app.routes.ts
├── app.config.ts
├── app.component.ts
└── app.component.html
```

- ✅ `app > users > user`
- ✅ `app > users > permits`
- ❌ `app > users > user > permits`

## Components

Use **standalone components** (`standalone: true`). Declare dependencies in the component `imports` array — no NgModule needed.

```typescript
import { Component } from '@angular/core';
import { NgIf, NgFor } from '@angular/common';
import { RouterLink } from '@angular/router';

@Component({
  standalone: true,
  selector: 'app-pokemons',
  imports: [NgIf, NgFor, RouterLink, PokemonComponent],
  templateUrl: './pokemons.component.html',
  styleUrl: './pokemons.component.scss',
})
export class PokemonsComponent { }
```

**Placement rules:**
- One main component per page/feature, placed directly under `app/`
- Child components go under their parent feature folder
- Shared components (used in multiple features) go in `app/shared/`

## Types

Always use types, including Angular-provided ones:

```typescript
@ViewChild('form') form!: ElementRef<HTMLFormElement>;
@ViewChild('canvas') canvas!: ElementRef<HTMLCanvasElement>;
@ViewChildren('items') items!: QueryList<ItemComponent>;
```

## Services

One service per main component containing all API calls for that feature and its children. Import only that one service in the main component.

```typescript
// ✅ pokemons.service.ts — contains all calls needed by pokemons feature
getPokemons() {
  return this.http.get<Pokemon[]>('pokemons');
}
getElements() {
  return this.http.get<Element[]>('elements');
}

// ✅ pokemons.component.ts — single service import
private pokemonsService = inject(PokemonsService);
```

If the same API route is needed in two different features, duplicate it in each feature's service. Don't import one feature's service into another.

## State Management (Signals)

Use **signals** for all component state instead of plain class properties.

```typescript
import { Component, signal, computed, effect, inject } from '@angular/core';

@Component({ standalone: true, ... })
export class PokemonsComponent {
  pokemons = signal<Pokemon[]>([]);
  isLoading = signal(false);
  selectedId = signal<number | null>(null);

  selectedPokemon = computed(() =>
    this.pokemons().find(p => p.id === this.selectedId())
  );

  constructor() {
    effect(() => {
      console.log('Selected:', this.selectedPokemon());
    });
  }

  select(id: number) {
    this.selectedId.set(id);
  }

  addPokemon(pokemon: Pokemon) {
    this.pokemons.update(list => [...list, pokemon]);
  }
}
```

**Template:** call signals as functions with `()`:

```html
@if (isLoading()) {
  <p>Loading...</p>
}
@for (pokemon of pokemons(); track pokemon.id) {
  <app-pokemon [data]="pokemon" />
}
```

**Encapsulate writable state in services:**

```typescript
@Injectable({ providedIn: 'root' })
export class PokemonsService {
  private readonly _pokemons = signal<Pokemon[]>([]);
  readonly pokemons = this._pokemons.asReadonly();
}
```

## Forms (Reactive)

Use **`FormGroup`** and **`FormControl`** (or `FormBuilder`) for all forms. Import `ReactiveFormsModule` in the component.

```typescript
import { Component, inject } from '@angular/core';
import { FormBuilder, Validators, ReactiveFormsModule } from '@angular/forms';

@Component({
  standalone: true,
  imports: [ReactiveFormsModule],
  templateUrl: './login.component.html',
})
export class LoginComponent {
  private fb = inject(FormBuilder);

  form = this.fb.group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(8)]],
  });

  onSubmit() {
    if (this.form.valid) {
      console.log(this.form.value);
    } else {
      this.form.markAllAsTouched();
    }
  }
}
```

```html
<form [formGroup]="form" (ngSubmit)="onSubmit()">
  <input type="email" formControlName="email" />
  @if (form.get('email')?.errors?.['required'] && form.get('email')?.touched) {
    <p>Email is required.</p>
  }
  <input type="password" formControlName="password" />
  <button type="submit" [disabled]="form.invalid">Login</button>
</form>
```

## App Bootstrap

Bootstrap with `bootstrapApplication` — no `AppModule`:

```typescript
// main.ts
import { bootstrapApplication } from '@angular/platform-browser';
import { AppComponent } from './app/app.component';
import { appConfig } from './app/app.config';

bootstrapApplication(AppComponent, appConfig).catch(console.error);
```

```typescript
// app.config.ts
import { ApplicationConfig } from '@angular/core';
import { provideRouter } from '@angular/router';
import { provideHttpClient } from '@angular/common/http';
import { routes } from './app.routes';

export const appConfig: ApplicationConfig = {
  providers: [provideRouter(routes), provideHttpClient()],
};
```

## Additional Resources

- Full feature walkthrough (service + component + template): [references/feature-example-pokemons.md](references/feature-example-pokemons.md)
- Signals encapsulation patterns: [references/signals-patterns.md](references/signals-patterns.md)
- Reactive forms patterns (nested groups, patchValue, custom validators): [references/reactive-forms-patterns.md](references/reactive-forms-patterns.md)
