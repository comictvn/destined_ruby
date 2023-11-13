import { DataTypes, Model, Sequelize } from 'sequelize';
import { SocialMedia } from './socialMedia';
export class User extends Model {
  public id!: number;
  public created_at!: Date;
  public updated_at!: Date;
  public email!: string;
  public password!: string;
  public name!: string;
  public age!: number;
  public gender!: string;
  public location!: string;
  public preferences!: string;
  public profile_picture!: string;
  public bio!: string;
  public readonly socialMedia?: SocialMedia[];
  public static initialize(sequelize: Sequelize) {
    User.init(
      {
        id: {
          type: DataTypes.INTEGER.UNSIGNED,
          autoIncrement: true,
          primaryKey: true,
        },
        created_at: DataTypes.DATE,
        updated_at: DataTypes.DATE,
        email: DataTypes.STRING,
        password: DataTypes.STRING,
        name: DataTypes.STRING,
        age: DataTypes.INTEGER,
        gender: DataTypes.STRING,
        location: DataTypes.STRING,
        preferences: DataTypes.STRING,
        profile_picture: DataTypes.STRING,
        bio: DataTypes.STRING,
      },
      {
        tableName: 'users',
        sequelize,
      }
    );
  }
  public static associate() {
    User.hasMany(SocialMedia, {
      sourceKey: 'id',
      foreignKey: 'user_id',
      as: 'socialMedia',
    });
  }
}
