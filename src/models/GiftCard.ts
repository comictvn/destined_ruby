import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, CreateDateColumn, UpdateDateColumn } from 'typeorm';
import { User } from './User';

@Entity('gift_cards')
export class GiftCard {
  @PrimaryGeneratedColumn()
  id: number;

  @CreateDateColumn({ type: 'timestamp' })
  created_at: Date;

  @UpdateDateColumn({ type: 'timestamp' })
  updated_at: Date;

  @Column({ type: 'varchar' })
  code: string;

  @Column({ type: 'int' })
  user_id: number;

  @ManyToOne(() => User, user => user.giftCards)
  user: User;
}