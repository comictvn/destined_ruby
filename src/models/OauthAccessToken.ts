import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { OauthApplication } from './OauthApplication';

@Entity('oauth_access_tokens')
export class OauthAccessToken {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  created_at: Date;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  updated_at: Date;

  @Column()
  resource_owner_id: string;

  @Column()
  token: string;

  @Column({ nullable: true })
  refresh_token: string;

  @Column('int')
  expires_in: number;

  @Column({ type: 'timestamp', nullable: true })
  revoked_at: Date;

  @Column('text', { array: true, default: '{}' })
  scopes: string[];

  @Column({ nullable: true })
  previous_refresh_token: string;

  @Column()
  resource_owner_type: string;

  @Column('int', { nullable: true })
  refresh_expires_in: number;

  @Column()
  application_id: string;

  @ManyToOne(() => OauthApplication)
  @JoinColumn({ name: 'application_id' })
  application: OauthApplication;
}