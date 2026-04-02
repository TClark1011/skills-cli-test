# NestJS Module — Coding Standards

All generated code must be 100% strict TypeScript, ESLint-clean, and production-ready.

## Import Organization (mandatory order)

```typescript
// 1. Node modules (alphabetical)
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';

// 2. Relative imports from parent directories
import BaseEntity from '../../../common/core/entities/base.entity';

// 3. Relative imports from same level
import { Create{{ModuleName}}Dto } from './dtos/create-{{module-name}}.dto';

// 4. Relative imports from subdirectories
import { {{ModuleName}} } from './entities/{{module-name}}.entity';
```

Never mix import order — strictly enforced.

## TypeScript Strictness

```typescript
// Required field — use !
@Column({ type: 'varchar', length: 255 })
name!: string;

// Optional field — use ?
@Column({ type: 'text', nullable: true })
description?: string;

// Explicit return types everywhere
async findOne(id: number): Promise<{{ModuleName}}> { ... }

// FORBIDDEN: implicit types or any
async findOne(id) { ... }  // ❌
```

## Error Handling

```typescript
async findOne(id: number): Promise<{{ModuleName}}> {
  if (!id || id < 1) {
    throw new BadRequestException('Invalid {{module-name}} ID');
  }
  const entity = await this.{{moduleName}}Repo.findOne({ where: { id } });
  if (!entity) {
    throw new NotFoundException(`{{ModuleName}} with ID ${id} not found`);
  }
  return entity;
}

async create(dto: Create{{ModuleName}}Dto): Promise<{{ModuleName}}> {
  try {
    const entity = this.{{moduleName}}Repo.create(dto);
    return this.{{moduleName}}Repo.save(entity);
  } catch (error) {
    if (error.code === 'ER_DUP_ENTRY') {
      throw new ConflictException('{{ModuleName}} already exists');
    }
    console.error('Unexpected error in {{ModuleName}}Service.create:', error);
    throw new BadRequestException('Failed to create {{module-name}}');
  }
}
```

## DTO Validation

```typescript
export class Create{{ModuleName}}Dto {
  @IsString()
  @IsNotEmpty()
  @MaxLength(255)
  name!: string;

  @IsEmail()
  @MaxLength(150)
  email!: string;

  @IsInt()
  @Min(1)
  categoryId!: number;

  @IsBoolean()
  @IsOptional()
  isActive?: boolean;
}

export class Query{{ModuleName}}Dto {
  @IsOptional()
  @Transform(({ value }) => parseInt(value, 10))
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number = 20;

  @IsOptional()
  @Transform(({ value }) => parseInt(value, 10))
  @IsInt()
  @Min(0)
  offset?: number = 0;

  @IsOptional()
  @IsString()
  @MaxLength(255)
  search?: string;

  @IsOptional()
  @IsIn(['name', 'email', 'createdAt', 'updatedAt'])
  sortBy?: 'name' | 'email' | 'createdAt' | 'updatedAt' = 'createdAt';

  @IsOptional()
  @IsIn(['ASC', 'DESC'])
  sortDir?: 'ASC' | 'DESC' = 'DESC';
}
```

Every field must have appropriate validation decorators.

## Entity / Database Standards

```typescript
@Entity('Example_{{ModuleName}}')
@Index('IDX_Example_{{ModuleName}}_searchField', ['searchField'])
@Index('IDX_Example_{{ModuleName}}_uniqueField', ['uniqueField'], { unique: true })
export class {{ModuleName}} extends BaseEntity<{{ModuleName}}> {
  @Column({ type: 'varchar', length: 255 })
  name!: string;

  @Column({ type: 'text', nullable: true })
  description?: string;

  @Column({ type: 'int' })
  relatedEntityId!: number;

  // Relations always go at the end
  @ManyToOne(() => RelatedEntity, { onDelete: 'RESTRICT', onUpdate: 'CASCADE' })
  @JoinColumn({
    name: 'relatedEntityId',
    referencedColumnName: 'id',
    foreignKeyConstraintName: 'FK_Example_{{ModuleName}}_relatedEntityId_RelatedEntity_id',
  })
  relatedEntity!: RelatedEntity;
}
```

Rules:
1. Always prefix tables with `Example_`
2. Always index searchable and FK fields
3. Always use explicit FK constraint names
4. Always specify column types and lengths
5. Always set explicit `onDelete` / `onUpdate` actions

## Service Query Standards

```typescript
async findAll(query: Query{{ModuleName}}Dto): Promise<{ data: {{ModuleName}}[]; total: number; limit: number; offset: number; }> {
  const qb = this.{{moduleName}}Repo.createQueryBuilder('{{moduleName[0]}}');

  if (query.search && query.search.trim().length > 0) {
    const searchTerm = `%${query.search.trim()}%`;
    qb.andWhere(
      '({{moduleName[0]}}.name LIKE :search OR {{moduleName[0]}}.description LIKE :search)',
      { search: searchTerm },
    );
  }

  const sortBy = query.sortBy ?? 'createdAt';
  const sortDir = query.sortDir ?? 'DESC';
  qb.orderBy(`{{moduleName[0]}}.${sortBy}`, sortDir);

  const limit = Math.min(query.limit ?? 20, 100);
  const offset = Math.max(query.offset ?? 0, 0);
  qb.take(limit).skip(offset);

  const [rows, total] = await qb.getManyAndCount();
  return { data: rows, total, limit, offset };
}
```

## Controller Standards

Rules:
1. Route prefix: `examples/{{module-name}}s`
2. Always use `ParseIntPipe` for ID params
3. Always use `async/await` consistently
4. Always return `{ success: true }` from delete endpoints
5. Never expose internal implementation details
