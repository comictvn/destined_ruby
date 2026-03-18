import { Entity, PrimaryGeneratedColumn, Column, ManyToOne, JoinColumn } from 'typeorm';
import { ActiveStorageBlob } from './ActiveStorageBlob';

@Entity('active_storage_variant_records')
export class ActiveStorageVariantRecord {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  created_at: Date;

  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  updated_at: Date;

  @Column()
  variation_digest: string;

  @Column()
  blob_id: number;

  @ManyToOne(() => ActiveStorageBlob, (blob) => blob.variant_records)
  @JoinColumn({ name: 'blob_id' })
  blob: ActiveStorageBlob;
}