import { Schema, model } from 'mongoose';
import { IUser } from './user';
export interface ISocialMedia {
  id: string;
  created_at: Date;
  updated_at: Date;
  platform: string;
  email: string;
  user_id: IUser['_id'];
  title: string;
}
const SocialMediaSchema = new Schema<ISocialMedia>({
  id: { type: String, required: true },
  created_at: { type: Date, required: true },
  updated_at: { type: Date, required: true },
  platform: { type: String, required: true },
  email: { type: String, required: true },
  user_id: { type: Schema.Types.ObjectId, ref: 'User', required: true },
  title: { type: String, required: true, maxlength: 255 },
});
export default model<ISocialMedia>('SocialMedia', SocialMediaSchema);
