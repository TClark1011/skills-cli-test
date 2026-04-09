---
name: class-transformer
description: Use the class-transformer library to transform plain objects to class instances and vice versa.
---
# class-transformer

## Core Concept
Transforms plain objects to class instances and vice versa. Also serializes/deserializes objects.

## Methods
- `plainToInstance(cls, plain)`: Transforms plain javascript object to instance of specific class. Supports arrays.
- `plainToClassFromExist(clsObject, plain)`: Transforms plain object into an instance using an already filled Object which is an instance of the target class.
- `instanceToPlain(instance, options?)`: Transforms class object to plain javascript object.
- `instanceToInstance(instance, options?)`: Deep clones class object.
- `serialize(instance, options?)`: Serializes model to JSON string.
- `deserialize(cls, json, options?)`: Deserializes JSON string to model.
- `deserializeArray(cls, json, options?)`: Deserializes JSON string to array of models.

## Type-safe Instances
By default, `plainToInstance` sets all properties from the plain object.
To enforce type-safety and exclude extraneous properties, use `excludeExtraneousValues: true` and `@Expose()`:
```typescript
class User {
  @Expose() id: number;
}
plainToInstance(User, plainUser, { excludeExtraneousValues: true });
```

## Nested Objects
Use `@Type` decorator to specify the type of nested objects.
```typescript
class Album {
  @Type(() => Photo)
  photos: Photo[];
}
```

### Polymorphic Types (Discriminator)
```typescript
@Type(() => Photo, {
  discriminator: {
    property: '__type',
    subTypes: [
      { value: Landscape, name: 'landscape' },
      { value: Portrait, name: 'portrait' }
    ],
  },
})
topPhoto: Landscape | Portrait;
```

## Getters and Methods
Use `@Expose()` to expose getters or method return values.
```typescript
@Expose() get name() { return this.firstName + ' ' + this.lastName; }
@Expose() getFullName() { return this.firstName + ' ' + this.lastName; }
```

## Property Renaming
```typescript
@Expose({ name: 'uid' }) id: number;
```

## Skipping Properties
- `@Exclude()`: Excludes property during transformation.
- `@Exclude({ toPlainOnly: true })`: Excludes only during `instanceToPlain`.
- `@Exclude({ toClassOnly: true })`: Excludes only during `plainToInstance`.
- `@Exclude()` on class: Skips all properties, requires explicit `@Expose()` on properties.
- `instanceToPlain(obj, { strategy: 'excludeAll' })`: Excludes all properties during transformation.
- `instanceToPlain(obj, { excludePrefixes: ['_'] })`: Excludes properties with specific prefixes.

## Groups
Control exposed/excluded properties using groups.
```typescript
@Expose({ groups: ['user', 'admin'] }) email: string;
instanceToPlain(user, { groups: ['user'] });
```

## Versioning
```typescript
@Expose({ since: 0.7, until: 1 }) email: string;
instanceToPlain(user, { version: 0.8 });
```

## Primitive Type Conversion
Pass primitive types to `@Type` to convert from strings.
```typescript
@Type(() => Date) registrationDate: Date;
```

## Arrays, Sets, Maps
Always provide the type in `@Type()` for Arrays, Sets, and Maps.
```typescript
@Type(() => Skill) skills: Set<Skill>;
@Type(() => Weapon) weapons: Map<string, Weapon>;
```

## Custom Transformation
Use `@Transform` for custom logic.
```typescript
@Transform(({ value, key, obj, type }) => moment(value), { toClassOnly: true })
date: Moment;
```

## Other Decorators
- `@TransformClassToPlain(options)`
- `@TransformClassToClass(options)`
- `@TransformPlainToClass(cls, options)`

## Implicit Type Conversion
Enable automatic conversion between built-in types based on TypeScript type information.
```typescript
plainToInstance(MyPayload, { prop: 1234 }, { enableImplicitConversion: true });
```

## Circular References
Circular references are ignored during transformation (except `instanceToInstance`).