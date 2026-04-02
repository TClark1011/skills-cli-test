# NestJS Module Templates

All template variables are documented in [SKILL.md](../SKILL.md).

## Module (`{{module-name}}.module.ts`)

```typescript
import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { {{ModuleName}}Controller } from './{{module-name}}.controller';
import { {{ModuleName}}Service } from './{{module-name}}.service';
import { {{ModuleName}} } from './entities/{{module-name}}.entity';

@Module({
  imports: [TypeOrmModule.forFeature([{{ModuleName}}])],
  providers: [{{ModuleName}}Service],
  controllers: [{{ModuleName}}Controller],
  exports: [{{ModuleName}}Service],
})
export class {{ModuleName}}Module { }
```

## Entity (`entities/{{module-name}}.entity.ts`)

```typescript
import { Column, Entity, Index } from 'typeorm';
import BaseEntity from '../../../common/core/entities/base.entity';

@Entity('{{TABLE_NAME}}')
{{entityIndexes}}
export class {{ModuleName}} extends BaseEntity<{{ModuleName}}> {
{{entityFields}}
}
```

## Service (`{{module-name}}.service.ts`)

```typescript
import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Create{{ModuleName}}Dto } from './dtos/create-{{module-name}}.dto';
import { Query{{ModuleName}}Dto } from './dtos/query-{{module-name}}.dto';
import { Update{{ModuleName}}Dto } from './dtos/update-{{module-name}}.dto';
import { {{ModuleName}} } from './entities/{{module-name}}.entity';

@Injectable()
export class {{ModuleName}}Service {
  constructor(
    @InjectRepository({{ModuleName}}) private readonly {{moduleName}}Repo: Repository<{{ModuleName}}>,
  ) { }

  async create(dto: Create{{ModuleName}}Dto): Promise<{{ModuleName}}> {
    const entity = this.{{moduleName}}Repo.create(dto);
    return this.{{moduleName}}Repo.save(entity);
  }

  async findAll(query: Query{{ModuleName}}Dto): Promise<{ data: {{ModuleName}}[]; total: number; limit: number; offset: number; }> {
    const qb = this.{{moduleName}}Repo.createQueryBuilder('{{moduleName[0]}}');

    {{searchLogic}}

    qb.orderBy(`{{moduleName[0]}}.${query.sortBy ?? 'createdAt'}`, query.sortDir ?? 'DESC');

    const limit = query.limit ?? 20;
    const offset = query.offset ?? 0;
    qb.take(limit).skip(offset);

    const [rows, total] = await qb.getManyAndCount();
    return { data: rows, total, limit, offset };
  }

  async findOne(id: number): Promise<{{ModuleName}}> {
    const entity = await this.{{moduleName}}Repo.findOne({ where: { id } });
    if (!entity) throw new NotFoundException('{{ModuleName}} not found');
    return entity;
  }

  async update(id: number, dto: Update{{ModuleName}}Dto): Promise<{{ModuleName}}> {
    const entity = await this.findOne(id);
    Object.assign(entity, dto);
    return this.{{moduleName}}Repo.save(entity);
  }

  async remove(id: number): Promise<void> {
    const entity = await this.findOne(id);
    await this.{{moduleName}}Repo.softRemove(entity);
  }
}
```

## Controller (`{{module-name}}.controller.ts`)

```typescript
import { Body, Controller, Delete, Get, Param, ParseIntPipe, Post, Put, Query } from '@nestjs/common';
import { {{ModuleName}}Service } from './{{module-name}}.service';
import { Create{{ModuleName}}Dto } from './dtos/create-{{module-name}}.dto';
import { Query{{ModuleName}}Dto } from './dtos/query-{{module-name}}.dto';
import { Update{{ModuleName}}Dto } from './dtos/update-{{module-name}}.dto';

@Controller('examples/{{module-name}}s')
export class {{ModuleName}}Controller {
  constructor(private readonly service: {{ModuleName}}Service) { }

  @Post()
  async create(@Body() dto: Create{{ModuleName}}Dto) {
    return this.service.create(dto);
  }

  @Get()
  async findAll(@Query() query: Query{{ModuleName}}Dto) {
    return this.service.findAll(query);
  }

  @Get(':id')
  async findOne(@Param('id', ParseIntPipe) id: number) {
    return this.service.findOne(id);
  }

  @Put(':id')
  async update(@Param('id', ParseIntPipe) id: number, @Body() dto: Update{{ModuleName}}Dto) {
    return this.service.update(id, dto);
  }

  @Delete(':id')
  async remove(@Param('id', ParseIntPipe) id: number) {
    await this.service.remove(id);
    return { success: true };
  }
}
```

## Create DTO (`dtos/create-{{module-name}}.dto.ts`)

```typescript
{{createDtoImports}}

export class Create{{ModuleName}}Dto {
{{createDtoFields}}
}
```

## Update DTO (`dtos/update-{{module-name}}.dto.ts`)

```typescript
{{updateDtoImports}}

export class Update{{ModuleName}}Dto {
{{updateDtoFields}}
}
```

## Query DTO (`dtos/query-{{module-name}}.dto.ts`)

```typescript
import { Transform } from 'class-transformer';
import { IsIn, IsInt, IsOptional, IsString, Max, Min } from 'class-validator';

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
  search?: string;

  @IsOptional()
  @IsIn([{{sortableFieldsList}}])
  sortBy?: {{sortableFieldsType}} = 'createdAt';

  @IsOptional()
  @IsIn(['ASC', 'DESC'])
  sortDir?: 'ASC' | 'DESC' = 'DESC';
}
```
