---
name: html-conventions
description: Enforce HTML coding conventions for elements, attributes, and style separation. Use when writing, reviewing, or generating HTML markup, or when the user asks about HTML best practices, structure, or formatting.
---

# HTML Conventions

## Elements

- Add closing tags to elements that aren't self-closing.
- Don't add the forward-slash for self-closing elements.
- Avoid unnecessary markup — don't wrap block elements in a superfluous `div`.
- Use lowercase for all tags.
- Use a maximum of one empty line to visually separate elements.

```html
<!-- Bad -->
<DIV>
  <UL>
    <LI>Item 1
    <LI>Item 2
  </UL>
</DIV>
<INPUT type="text" />
<p>some sample text

<!-- Good -->
<ul>
  <li>Item 1</li>
  <li>Item 2</li>
</ul>
<input type="text">
<p>Some sample text</p>
```

## Attributes

- Avoid `id`, use `class` instead.
- Surround attribute values in double quotes.
- Separate attributes with a single space only.
- Boolean attributes (e.g. `required`, `disabled`) don't need a value.
- Follow this attribute order:
  1. `class`
  2. Structural directives (`ngIf`, `ngFor`, `ngModel`)
  3. Event bindings (e.g. `(click)`)
  4. All other attributes (`required`, `href`, `value`, etc.)

```html
<!-- Bad -->
<input id="button" (click)="getName()"  type='radio' class="input" required='true'>

<!-- Good -->
<input class="input" (click)="getName()" type="radio" required>
```

## Content vs. Style

- Do not use inline styles.
- HTML defines structure and meaning — leave all styling to CSS.

```html
<!-- Bad -->
<span class="title" style="color:#abc; font-size:14px;"></span>

<!-- Good -->
<span class="title"></span>
```
