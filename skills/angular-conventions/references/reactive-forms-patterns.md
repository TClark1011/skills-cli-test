# Reactive Forms Patterns

### Form with nested group

```typescript
form = this.fb.group({
  personal: this.fb.group({
    firstName: ['', Validators.required],
    lastName:  ['', Validators.required],
  }),
  contact: this.fb.group({
    email: ['', [Validators.required, Validators.email]],
    phone: [''],
  }),
});
```

```html
<form [formGroup]="form" (ngSubmit)="onSubmit()">
  <div formGroupName="personal">
    <input formControlName="firstName" />
    <input formControlName="lastName" />
  </div>
  <div formGroupName="contact">
    <input type="email" formControlName="email" />
  </div>
  <button type="submit">Submit</button>
</form>
```

### Patching values programmatically

```typescript
// Update specific fields without touching others
this.form.patchValue({ email: 'new@email.com' });

// Replace all values
this.form.setValue({ firstName: 'Alice', lastName: 'Smith', email: 'a@b.com' });
```

### Custom validator

```typescript
import { AbstractControl, ValidationErrors } from '@angular/forms';

function noWhitespace(control: AbstractControl): ValidationErrors | null {
  return /\s/.test(control.value ?? '') ? { noWhitespace: true } : null;
}

// Usage
username: ['', [Validators.required, noWhitespace]]
```
