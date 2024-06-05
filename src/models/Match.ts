import { Model } from 'sequelize';

export class Match extends Model {
  public id!: number;
  public created_at!: Date;
  public updated_at!: Date;
  public matcher1_id!: number;
  public matcher2_id!: number;
}