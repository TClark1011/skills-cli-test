#!/bin/bash

MIGRATIONS_DIR="$1"
MIGRATION_NAME="$2"

TIMESTAMP=$(date +%s)

# Convert migration name to PascalCase (split on -, _, and spaces)
PASCAL_NAME=$(echo "$MIGRATION_NAME" | sed 's/[-_ ]/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) substr($i,2); print}' | sed 's/ //g')

CLASS_NAME="${PASCAL_NAME}${TIMESTAMP}"
FILE_NAME="${TIMESTAMP}-${MIGRATION_NAME}.ts"

cat > "${MIGRATIONS_DIR}/${FILE_NAME}" <<EOF
import { MigrationInterface, QueryRunner } from "typeorm";

export class ${CLASS_NAME} implements MigrationInterface {
    name = '${CLASS_NAME}'

    public async up(queryRunner: QueryRunner): Promise<void> {
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
    }

}
EOF

echo "Created: ${MIGRATIONS_DIR}/${FILE_NAME}"
