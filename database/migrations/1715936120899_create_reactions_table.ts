import * as Knex from 'knex';

export async function up(knex: Knex): Promise<void> {
  return knex.schema.createTable('reactions', (table) => {
    table.increments('id').primary();
    table.timestamp('created_at').defaultTo(knex.fn.now());
    table.timestamp('updated_at').defaultTo(knex.fn.now());
    table.integer('reacter_id').notNullable();
    table.integer('reacted_id').notNullable();
    table.string('react_type').notNullable();
  });
}

export async function down(knex: Knex): Promise<void> {
  return knex.schema.dropTable('reactions');
}