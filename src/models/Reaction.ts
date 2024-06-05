import { Model } from 'objection';

class Reaction extends Model {
  static get tableName() {
    return 'reactions';
  }

  static get idColumn() {
    return 'id';
  }

  id!: number;
  created_at!: Date;
  updated_at!: Date;
  reacter_id!: number;
  reacted_id!: number;
  react_type!: string;
}