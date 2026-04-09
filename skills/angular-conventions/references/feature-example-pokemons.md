# Complete Feature Example: Pokemons

### pokemons.service.ts

```typescript
import { Injectable, inject } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { firstValueFrom } from 'rxjs';

export interface Pokemon {
  id: number;
  name: string;
  element: string;
}

export interface Element {
  id: number;
  name: string;
}

@Injectable({ providedIn: 'root' })
export class PokemonsService {
  private http = inject(HttpClient);

  getPokemons(): Promise<Pokemon[]> {
    return firstValueFrom(this.http.get<Pokemon[]>('pokemons'));
  }

  getPokemon(id: number): Promise<Pokemon> {
    return firstValueFrom(this.http.get<Pokemon>(`pokemons/${id}`));
  }

  // Duplicated here even if used elsewhere — keeps service self-contained
  getElements(): Promise<Element[]> {
    return firstValueFrom(this.http.get<Element[]>('elements'));
  }
}
```

### pokemons.component.ts

```typescript
import { Component, signal, computed, inject, OnInit } from '@angular/core';
import { NgFor, NgIf } from '@angular/common';
import { RouterLink } from '@angular/router';
import { PokemonsService, Pokemon, Element } from './pokemons.service';
import { PokemonComponent } from './pokemon/pokemon.component';

@Component({
  standalone: true,
  selector: 'app-pokemons',
  imports: [NgFor, NgIf, RouterLink, PokemonComponent],
  templateUrl: './pokemons.component.html',
  styleUrl: './pokemons.component.scss',
})
export class PokemonsComponent implements OnInit {
  private pokemonsService = inject(PokemonsService);

  pokemons = signal<Pokemon[]>([]);
  elements = signal<Element[]>([]);
  isLoading = signal(false);
  selectedElementId = signal<number | null>(null);

  filteredPokemons = computed(() => {
    const id = this.selectedElementId();
    return id
      ? this.pokemons().filter(p => p.element === String(id))
      : this.pokemons();
  });

  async ngOnInit() {
    this.isLoading.set(true);
    const [pokemons, elements] = await Promise.all([
      this.pokemonsService.getPokemons(),
      this.pokemonsService.getElements(),
    ]);
    this.pokemons.set(pokemons);
    this.elements.set(elements);
    this.isLoading.set(false);
  }

  filterByElement(id: number | null) {
    this.selectedElementId.set(id);
  }
}
```

### pokemons.component.html

```html
@if (isLoading()) {
  <p>Loading...</p>
} @else {
  <div class="filters">
    <button (click)="filterByElement(null)">All</button>
    @for (el of elements(); track el.id) {
      <button (click)="filterByElement(el.id)">{{ el.name }}</button>
    }
  </div>

  <div class="grid">
    @for (pokemon of filteredPokemons(); track pokemon.id) {
      <app-pokemon [pokemon]="pokemon" />
    }
  </div>
}
```
