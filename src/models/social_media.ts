import { DataTypes, Model, Sequelize } from 'sequelize';
import { User } from './user';
export class SocialMedia extends Model {
  public id!: number;
  public user_id!: number;
  public created_at!: Date;
  public updated_at!: Date;
}
export function initialize(sequelize: Sequelize) {
  SocialMedia.init(
    {
      id: {
        type: DataTypes.INTEGER.UNSIGNED,
        autoIncrement: true,
        primaryKey: true,
      },
      user_id: {
        type: DataTypes.INTEGER.UNSIGNED,
        allowNull: false,
      },
      created_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
      },
      updated_at: {
        type: DataTypes.DATE,
        allowNull: false,
        defaultValue: Sequelize.literal('CURRENT_TIMESTAMP'),
      },
    },
    {
      tableName: 'social_media',
      sequelize,
      timestamps: false,
    }
  );
  SocialMedia.belongsTo(User, {
    foreignKey: 'user_id',
    as: 'user',
  });
}
