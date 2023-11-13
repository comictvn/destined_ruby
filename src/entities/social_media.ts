import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne
} from "typeorm";
import { User } from "./user";
@Entity("social_media")
export class SocialMedia {
  @PrimaryGeneratedColumn("uuid")
  id: string;
  @CreateDateColumn()
  created_at: Date;
  @UpdateDateColumn()
  updated_at: Date;
  @Column()
  platform: string;
  @Column()
  email: string;
  @Column({ type: "varchar", length: 255 })
  title: string;
  @ManyToOne(() => User, (user) => user.social_medias)
  user: User;
}
