import { Conversation, Message } from './chat.model.js';
import { NotFoundError, ForbiddenError } from '../../core/errors/app-error.js';
import { wsManager } from '../../core/websocket/ws-server.js';
import type { StartConversationInput, SendMessageInput } from './chat.schema.js';

export class ChatService {
  public async getOrCreateConversation(userId: string, input: StartConversationInput) {
    let conversation = await Conversation.findOne({
      participants: { $all: [userId, input.recipientId] },
    }).populate('participants', 'fullName email phone profilePicture role');

    if (!conversation) {
      conversation = await Conversation.create({
        participants: [userId, input.recipientId],
      });
      conversation = await conversation.populate('participants', 'fullName email phone profilePicture role');
    }

    if (input.initialMessage) {
      await this.sendMessage(conversation._id.toString(), userId, { text: input.initialMessage });
    }

    return conversation;
  }

  public async listUserConversations(userId: string) {
    return Conversation.find({ participants: userId })
      .populate('participants', 'fullName email phone profilePicture role')
      .sort({ lastMessageAt: -1 });
  }

  public async getMessages(conversationId: string, userId: string) {
    const conversation = await Conversation.findById(conversationId);
    if (!conversation) throw new NotFoundError('Conversation');

    if (!conversation.participants.some((p) => p.toString() === userId)) {
      throw new ForbiddenError('You are not a participant in this conversation');
    }

    return Message.find({ conversationId })
      .populate('senderId', 'fullName profilePicture')
      .sort({ createdAt: 1 });
  }

  public async sendMessage(conversationId: string, senderId: string, input: SendMessageInput) {
    const conversation = await Conversation.findById(conversationId);
    if (!conversation) throw new NotFoundError('Conversation');

    if (!conversation.participants.some((p) => p.toString() === senderId)) {
      throw new ForbiddenError('You are not a participant in this conversation');
    }

    const message = await Message.create({
      conversationId,
      senderId,
      text: input.text,
      isRead: false,
    });

    conversation.lastMessage = input.text;
    conversation.lastMessageAt = new Date();
    await conversation.save();

    const populated = await message.populate('senderId', 'fullName profilePicture');

    // Real-time broadcast via WebSocket to room and other participant
    wsManager.broadcastToRoom(`conversation:${conversationId}`, 'message:received', populated);

    const otherParticipant = conversation.participants.find((p) => p.toString() !== senderId);
    if (otherParticipant) {
      wsManager.broadcastToUser(otherParticipant.toString(), 'message:notification', {
        conversationId,
        message: populated,
      });
    }

    return populated;
  }
}

export const chatService = new ChatService();
