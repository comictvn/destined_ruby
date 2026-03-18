import { MigrationInterface, QueryRunner, Table, TableForeignKey } from 'typeorm';

export class createOauthAccessTokensTable1715936207679 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(new Table({
      name: 'oauth_access_tokens',
      columns: [
        {
          name: 'id',
          type: 'uuid',
          isPrimary: true,
          isGenerated: true,
          generationStrategy: 'uuid',
        },
        {
          name: 'created_at',
          type: 'timestamp',
          default: 'CURRENT_TIMESTAMP',
        },
        {
          name: 'updated_at',
          type: 'timestamp',
          default: 'CURRENT_TIMESTAMP',
        },
        {
          name: 'resource_owner_id',
          type: 'varchar',
        },
        {
          name: 'token',
          type: 'varchar',
        },
        {
          name: 'refresh_token',
          type: 'varchar',
          isNullable: true,
        },
        {
          name: 'expires_in',
          type: 'int',
        },
        {
          name: 'revoked_at',
          type: 'timestamp',
          isNullable: true,
        },
        {
          name: 'scopes',
          type: 'text',
          isArray: true,
          default: '{}',
        },
        {
          name: 'previous_refresh_token',
          type: 'varchar',
          isNullable: true,
        },
        {
          name: 'resource_owner_type',
          type: 'varchar',
        },
        {
          name: 'refresh_expires_in',
          type: 'int',
          isNullable: true,
        },
        {
          name: 'application_id',
          type: 'uuid',
        },
      ],
    }), true);

    await queryRunner.createForeignKey('oauth_access_tokens', new TableForeignKey({
      columnNames: ['application_id'],
      referencedColumnNames: ['id'],
      referencedTableName: 'oauth_applications',
      onDelete: 'CASCADE',
    }));
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.dropTable('oauth_access_tokens');
  }
}