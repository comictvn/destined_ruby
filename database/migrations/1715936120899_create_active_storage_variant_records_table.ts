import { MigrationInterface, QueryRunner, Table, TableForeignKey } from 'typeorm';

export class createActiveStorageVariantRecordsTable1715936120899 implements MigrationInterface {
  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.createTable(
      new Table({
        name: 'active_storage_variant_records',
        columns: [
          {
            name: 'id',
            type: 'int',
            isPrimary: true,
            isGenerated: true,
            generationStrategy: 'increment',
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
            name: 'variation_digest',
            type: 'varchar',
          },
          {
            name: 'blob_id',
            type: 'int',
          },
        ],
      }),
      true,
    );

    await queryRunner.createForeignKey(
      'active_storage_variant_records',
      new TableForeignKey({
        columnNames: ['blob_id'],
        referencedColumnNames: ['id'],
        referencedTableName: 'active_storage_blobs',
        onDelete: 'CASCADE',
      }),
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    const table = await queryRunner.getTable('active_storage_variant_records');
    const foreignKey = table.foreignKeys.find(fk => fk.columnNames.indexOf('blob_id') !== -1);
    await queryRunner.dropForeignKey('active_storage_variant_records', foreignKey);
    await queryRunner.dropTable('active_storage_variant_records');
  }
}