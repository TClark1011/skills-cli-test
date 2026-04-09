---
name: class-validator
description: Use the class-validator library to validate objects.
---

# class-validator

Allows use of decorator and non-decorator based validation. Internally uses validator.js. Works on browser and node.js.

## Usage

```typescript
import { validate, validateOrReject, Contains, IsInt, Length, IsEmail, IsFQDN, IsDate, Min, Max } from 'class-validator';

export class Post {
  @Length(10, 20) title: string;
  @Contains('hello') text: string;
  @IsInt() @Min(0) @Max(10) rating: number;
  @IsEmail() email: string;
  @IsFQDN() site: string;
  @IsDate() createDate: Date;
}

const post = new Post();
// ... populate post ...

// Async validation
const errors = await validate(post);
if (errors.length > 0) throw errors;

// Or throw automatically
await validateOrReject(post);
```

### Passing options

`validate(post, options: ValidatorOptions)`

```ts
export interface ValidatorOptions {
  skipMissingProperties?: boolean;
  whitelist?: boolean;
  forbidNonWhitelisted?: boolean;
  groups?: string[];
  dismissDefaultMessages?: boolean;
  validationError?: { target?: boolean; value?: boolean; };
  forbidUnknownValues?: boolean; // default: true
  stopAtFirstError?: boolean;
}
```

## Validation errors

`validate` returns an array of `ValidationError`:

```typescript
{
    target: Object; // Validated object
    property: string; // Property that failed
    value: any; // Failed value
    constraints?: { [type: string]: string; }; // Failed constraints with error messages
    contexts?: { [type: string]: any; }; // Custom contexts
    children?: ValidationError[]; // Nested validation errors
}
```

To hide `target` in errors: `validate(post, { validationError: { target: false } });`

## Validation messages

Specify custom messages in decorator options:

```typescript
@MinLength(10, { message: 'Title is too short' })
title: string;
```

**Special tokens:**
- `$value` - validated value
- `$property` - property name
- `$target` - class name
- `$constraint1`, `$constraint2`, ... - constraints defined by validation type

**Message function:**
```typescript
@MinLength(10, {
  message: (args: ValidationArguments) => `Too short, minimum length is ${args.constraints[0]} characters`
})
```

`ValidationArguments` properties: `value`, `constraints`, `targetName`, `object`, `property`.

## Validating Collections & Nested Objects

**Arrays, Sets, Maps:** Use `{ each: true }`
```typescript
@MaxLength(20, { each: true })
tags: string[]; // or Set<string> or Map<string, string>
```

**Nested Objects:** Use `@ValidateNested()`
```typescript
import { ValidateNested } from 'class-validator';

export class Post {
  @ValidateNested()
  user: User; // Must be an instance of a class
}
```

**Promises:** Use `@ValidatePromise()`
```typescript
@ValidateNested()
@ValidatePromise()
user: Promise<User>;
```

## Inheritance
Subclasses automatically inherit parent's decorators.

## Conditional validation

**@ValidateIf (Decorator):** Ignores validators if condition is false.
```typescript
@ValidateIf(o => o.otherProperty === 'value')
@IsNotEmpty()
example: string;
```

**validateIf (Option):** Granular control per validator.
```typescript
@Min(5, { validateIf: (o, value) => o.someOtherProperty === 'min' })
someProperty: number;
```

## Whitelisting
Strip properties without decorators: `validate(post, { whitelist: true })`.
Throw error on non-whitelisted: `validate(post, { whitelist: true, forbidNonWhitelisted: true })`.
Use `@Allow()` to whitelist a property without applying constraints.

## Passing context
Pass custom object accessible on `ValidationError` if validation fails.
```typescript
@MinLength(32, { context: { errorCode: 1003 } })
eicCode: string;
```

## Skipping missing properties
Skip validation of undefined/null properties: `validate(post, { skipMissingProperties: true })`.
`@IsDefined()` ignores `skipMissingProperties`.

## Validation groups
Apply validation schemas conditionally.
```typescript
@Min(12, { groups: ['registration'] })
age: number;

validate(user, { groups: ['registration'] });
```
Use `{ always: true }` to apply regardless of group.

## Custom validation classes

```typescript
import { ValidatorConstraint, ValidatorConstraintInterface, ValidationArguments, Validate } from 'class-validator';

@ValidatorConstraint({ name: 'customText', async: false })
export class CustomTextLength implements ValidatorConstraintInterface {
  validate(text: string, args: ValidationArguments) {
    return text.length > args.constraints[0] && text.length < args.constraints[1];
  }
  defaultMessage(args: ValidationArguments) {
    return 'Text ($value) is too short or too long!';
  }
}

// Usage
@Validate(CustomTextLength, [3, 20], { message: 'Wrong post title' })
title: string;
```

## Custom validation decorators

```typescript
import { registerDecorator, ValidationOptions, ValidationArguments } from 'class-validator';

export function IsLongerThan(property: string, validationOptions?: ValidationOptions) {
  return function (object: Object, propertyName: string) {
    registerDecorator({
      name: 'isLongerThan',
      target: object.constructor,
      propertyName: propertyName,
      constraints: [property],
      options: validationOptions,
      validator: {
        validate(value: any, args: ValidationArguments) {
          const [relatedPropertyName] = args.constraints;
          const relatedValue = (args.object as any)[relatedPropertyName];
          return typeof value === 'string' && typeof relatedValue === 'string' && value.length > relatedValue.length;
        },
      },
    });
  };
}
```

## Other Features
- **Service Container:** `useContainer(Container);` to inject dependencies into custom constraints.
- **Synchronous validation:** `validateSync(post)` (ignores async validations).
- **Manual validation:** `isEmpty(value)`, `isBoolean(value)`.
- **Validating plain objects:** Must instantiate using `new Class()` or use `class-transformer` to convert plain objects to class instances.

## Validation decorators

| Decorator | Description |
| --- | --- |
| **Common** | |
| `@IsDefined(value: any)` | Checks if value is defined (!== undefined, !== null). Ignores skipMissingProperties. |
| `@IsOptional()` | Checks if given value is empty (=== null, === undefined), ignores validators if so. |
| `@Equals(comparison: any)` | Checks if value equals ("===") comparison. |
| `@NotEquals(comparison: any)` | Checks if value not equal ("!==") comparison. |
| `@IsEmpty()` | Checks if given value is empty (=== '', === null, === undefined). |
| `@IsNotEmpty()` | Checks if given value is not empty (!== '', !== null, !== undefined). |
| `@IsIn(values: any[])` | Checks if value is in an array of allowed values. |
| `@IsNotIn(values: any[])` | Checks if value is not in an array of disallowed values. |
| **Type** | |
| `@IsBoolean()` | Checks if a value is a boolean. |
| `@IsDate()` | Checks if the value is a date. |
| `@IsString()` | Checks if the value is a string. |
| `@IsNumber(options: IsNumberOptions)` | Checks if the value is a number. |
| `@IsInt()` | Checks if the value is an integer number. |
| `@IsArray()` | Checks if the value is an array |
| `@IsEnum(entity: object)` | Checks if the value is a valid enum |
| **Number** | |
| `@IsDivisibleBy(num: number)` | Checks if the value is a number that's divisible by another. |
| `@IsPositive()` | Checks if the value is a positive number greater than zero. |
| `@IsNegative()` | Checks if the value is a negative number smaller than zero. |
| `@Min(min: number)` | Checks if the given number is greater than or equal to given number. |
| `@Max(max: number)` | Checks if the given number is less than or equal to given number. |
| **Date** | |
| `@MinDate(date: Date \| (() => Date))` | Checks if the value is a date that's after the specified date. |
| `@MaxDate(date: Date \| (() => Date))` | Checks if the value is a date that's before the specified date. |
| **String-type** | |
| `@IsBooleanString()` | Checks if a string is a boolean (e.g. is "true" or "false" or "1", "0"). |
| `@IsDateString()` | Alias for `@IsISO8601()`. |
| `@IsNumberString(options?: IsNumericOptions)` | Checks if a string is a number. |
| **String** | |
| `@Contains(seed: string)` | Checks if the string contains the seed. |
| `@NotContains(seed: string)` | Checks if the string not contains the seed. |
| `@IsAlpha()` | Checks if the string contains only letters (a-zA-Z). |
| `@IsAlphanumeric()` | Checks if the string contains only letters and numbers. |
| `@IsDecimal(options?: IsDecimalOptions)` | Checks if the string is a valid decimal value. |
| `@IsAscii()` | Checks if the string contains ASCII chars only. |
| `@IsBase32()`, `@IsBase58()`, `@IsBase64(options?: IsBase64Options)` | Checks if a string is base32/58/64 encoded. |
| `@IsIBAN()`, `@IsBIC()` | Checks if a string is a IBAN or BIC/SWIFT code. |
| `@IsByteLength(min: number, max?: number)` | Checks if the string's length (in bytes) falls in a range. |
| `@IsCreditCard()` | Checks if the string is a credit card. |
| `@IsCurrency(options?: IsCurrencyOptions)` | Checks if the string is a valid currency amount. |
| `@IsISO4217CurrencyCode()` | Checks if the string is an ISO 4217 currency code. |
| `@IsEthereumAddress()`, `@IsBtcAddress()` | Checks if the string is an Ethereum/BTC address. |
| `@IsDataURI()` | Checks if the string is a data uri format. |
| `@IsEmail(options?: IsEmailOptions)` | Checks if the string is an email. |
| `@IsFQDN(options?: IsFQDNOptions)` | Checks if the string is a fully qualified domain name. |
| `@IsFullWidth()`, `@IsHalfWidth()`, `@IsVariableWidth()` | Checks if string contains full/half/variable width chars. |
| `@IsHexColor()`, `@IsHSL()`, `@IsRgbColor(options?: IsRgbOptions)` | Checks if string is hex/HSL/RGB color. |
| `@IsIdentityCard(locale?: string)`, `@IsPassportNumber(countryCode?: string)` | Checks identity card/passport number. |
| `@IsPostalCode(locale?: string)` | Checks if the string is a postal code. |
| `@IsHexadecimal()`, `@IsOctal()` | Checks if the string is a hexadecimal/octal number. |
| `@IsMACAddress(options?: IsMACAddressOptions)` | Checks if the string is a MAC Address. |
| `@IsIP(version?: "4"\|"6")` | Checks if the string is an IP (version 4 or 6). |
| `@IsPort()` | Checks if the string is a valid port number. |
| `@IsISBN(version?: "10"\|"13")`, `@IsEAN()`, `@IsISIN()` | Checks ISBN/EAN/ISIN. |
| `@IsISO8601(options?: IsISO8601Options)` | Checks if the string is a valid ISO 8601 date format. |
| `@IsJSON()`, `@IsJWT()` | Checks if the string is valid JSON/JWT. |
| `@IsObject()`, `@IsNotEmptyObject()` | Checks if the object is valid Object/not empty. |
| `@IsLowercase()`, `@IsUppercase()` | Checks if the string is lowercase/uppercase. |
| `@IsLatLong()`, `@IsLatitude()`, `@IsLongitude()` | Checks coordinates. |
| `@IsMobilePhone(locale: string)`, `@IsPhoneNumber(region: string)` | Checks mobile/phone number. |
| `@IsISO6391()`, `@IsISO31661Alpha2()`, `@IsISO31661Alpha3()`, `@IsISO31661Numeric()` | Checks ISO language/country codes. |
| `@IsLocale()` | Checks if the string is a locale. |
| `@IsMongoId()` | Checks if the string is a valid MongoDB ObjectId. |
| `@IsMultibyte()`, `@IsSurrogatePair()` | Checks for multibyte/surrogate pair chars. |
| `@IsTaxId()` | Checks if the string is a valid tax ID. |
| `@IsUrl(options?: IsURLOptions)`, `@IsMagnetURI()` | Checks URL/Magnet URI. |
| `@IsUUID(version?: UUIDVersion)` | Checks if the string is a UUID. |
| `@IsFirebasePushId()` | Checks if the string is a Firebase Push ID. |
| `@Length(min: number, max?: number)`, `@MinLength(min: number)`, `@MaxLength(max: number)` | Checks string length. |
| `@Matches(pattern: RegExp, modifiers?: string)` | Checks if string matches the pattern. |
| `@IsMilitaryTime()`, `@IsTimeZone()` | Checks military time/IANA time-zone. |
| `@IsHash(algorithm: string)` | Checks hash (md4, md5, sha1, sha256, etc). |
| `@IsMimeType()` | Checks MIME type format. |
| `@IsSemVer()` | Checks SemVer. |
| `@IsISSN(options?: IsISSNOptions)`, `@IsISRC()` | Checks ISSN/ISRC. |
| `@IsRFC3339()` | Checks RFC 3339 date. |
| `@IsStrongPassword(options?: IsStrongPasswordOptions)` | Checks strong password. |
| **Array** | |
| `@ArrayContains(values: any[])`, `@ArrayNotContains(values: any[])` | Checks if array contains/does not contain values. |
| `@ArrayNotEmpty()` | Checks if given array is not empty. |
| `@ArrayMinSize(min: number)`, `@ArrayMaxSize(max: number)` | Checks array length. |
| `@ArrayUnique(identifier?: (o) => any)` | Checks if all array's values are unique. |
| **Object** | |
| `@IsInstance(value: any)` | Checks if the property is an instance of the passed value. |
| **Other** | |
| `@Allow()` | Prevent stripping off the property when no other constraint is specified. |