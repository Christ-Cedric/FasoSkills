import mongoose, { Schema, type Document } from 'mongoose';

export interface IConversation extends Document {
  participants: mongoose.Types.ObjectId[];
  lastMessage?: string;
  lastMessageAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

const conversationSchema = new Schema<IConversation>(
  {
    participants: [{ type: Schema.Types.ObjectId, ref: 'User', required: true }],
    lastMessage: { type: String, default: '' },
    lastMessageAt: { type: Date, default: Date.now },
  },
  { timestamps: true }
);

conversationSchema.index({ participants: 1 });

export const Conversation = mongoose.model<IConversation>('Conversation', conversationSchema);

export interface IMessage extends Document {
  conversationId: mongoose.Types.ObjectId;
  senderId: mongoose.Types.ObjectId;
  text: string;
  isRead: boolean;
  createdAt: Date;
}

const messageSchema = new Schema<IMessage>(
  {
    conversationId: { type: Schema.Types.ObjectId, ref: 'Conversation', required: true, index: true },
    senderId: { type: Schema.Types.ObjectId, ref: 'User', required: true, index: true },
    text: { type: String, required: true, trim: true },
    isRead: { type: Boolean, default: false },
  },
  { timestamps: { createdAt: true, updatedAt: false } }
);

messageSchema.index({ conversationId: 1, createdAt: 1 });

export const Message = mongoose.model<IMessage>('Message', messageSchema);
