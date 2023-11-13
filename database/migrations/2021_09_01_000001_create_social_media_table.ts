import { Knex } from "knex";
export async function up(knex: Knex): Promise<void> {
    return knex.schema.createTable("social_media", (table) => {
        table.increments("id").primary();
        table.timestamp("created_at").defaultTo(knex.raw("CURRENT_TIMESTAMP"));
        table.timestamp("updated_at").defaultTo(knex.raw("CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP"));
        table.string("platform");
        table.string("email");
        table.integer("user_id").unsigned().notNullable();
        table.string("title", 255).notNullable();
        table.foreign("user_id").references("users.user_id");
    });
}
export async function down(knex: Knex): Promise<void> {
    return knex.schema.dropTable("social_media");
}
