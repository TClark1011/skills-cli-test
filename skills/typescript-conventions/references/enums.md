# Types & Enums

- **Always type variables** — no untyped variables, no `any`.
- Use **classes/models** for database entities.
- Use **`type`** for other object shapes.
- Use **`enum`** for fixed sets of values (roles, tabs, statuses).

## Enum Rules

| Concern | Casing |
|---|---|
| Enum name | PascalCase |
| Enum attributes | PascalCase |
| String values | kebab-case |

- Enums can be defined inline above the related entity or in a separate file (`{{enumName}}.enum.ts`).
- For UI tab enums, string values are optional — numeric auto-increment is fine.

## Enum with string values

```typescript
export enum SaveState {
  Neutral = 'neutral',
  Loading = 'load',
  Ok = 'ok',
  Error = 'error'
}
```

## Enum with entity class

```typescript
export enum UserRole {
  Admin = 'admin',
  User = 'user'
}

export class User extends Base<User> {
  role: UserRole;
}
```

File structure alternative for global enums:

```
users/
  models/
    user.model.ts
  enums/
    user-role.enum.ts
```

## Numeric enum for UI tabs

```typescript
enum Tabs {
  Summary,
  Details,
  Donations,
  Timeline,
  Notes,
  Files
}

export class SupporterComponent implements OnDestroy {
  Tabs = Tabs;
  tab = Tabs.Summary;
}
```

```html
<div class="tabs separator">
  <button type="button" class="tab" (click)="tab = Tabs.Summary" [class.current]="tab === Tabs.Summary">Summary</button>
  <button type="button" class="tab" (click)="tab = Tabs.Details" [class.current]="tab === Tabs.Details">Details</button>
  <button type="button" class="tab" (click)="tab = Tabs.Donations" [class.current]="tab === Tabs.Donations">Donations</button>
  <button type="button" class="tab" (click)="tab = Tabs.Timeline" [class.current]="tab === Tabs.Timeline">Timeline</button>
  <button type="button" class="tab" (click)="tab = Tabs.Notes" [class.current]="tab === Tabs.Notes">Notes</button>
  <button type="button" class="tab" (click)="tab = Tabs.Files" [class.current]="tab === Tabs.Files">Files</button>
</div>

<div class="tab-content">
  <ng-container [ngSwitch]="tab">
    <app-supporter-summary *ngSwitchCase="Tabs.Summary" [supporter]="supporter"></app-supporter-summary>
    <app-supporter-details *ngSwitchCase="Tabs.Details" [supporter]="supporter" (refresh)="init()"></app-supporter-details>
    <app-supporter-donations *ngSwitchCase="Tabs.Donations" [supporter]="supporter"></app-supporter-donations>
    <app-supporter-timeline *ngSwitchCase="Tabs.Timeline" [supporter]="supporter"></app-supporter-timeline>
    <app-supporter-notes *ngSwitchCase="Tabs.Notes" [supporter]="supporter"></app-supporter-notes>
  </ng-container>
</div>
```
