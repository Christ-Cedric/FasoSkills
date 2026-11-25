import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/chat_bloc.dart';
import '../../domain/models/message.dart';

class MessagesScreen extends StatefulWidget {
  final String conversationId;
  const MessagesScreen({super.key, this.conversationId = 'default_conv'});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatBloc>().add(LoadMessages(widget.conversationId));
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _messageController.text.trim();
    if (text.isNotEmpty) {
      context.read<ChatBloc>().add(
            SendMessageSubmitted(
              conversationId: widget.conversationId,
              text: text,
            ),
          );
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.person, color: Colors.white, size: 18),
            ),
            SizedBox(width: 10),
            Text('Messagerie en direct', style: TextStyle(fontSize: 16)),
          ],
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.circle, size: 12, color: Colors.green),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ChatError) {
                  return Center(child: Text(state.message));
                }

                if (state is ChatLoaded) {
                  if (state.messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'Aucun message pour l’instant.\nEnvoyez un message en temps réel !',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppTheme.textSecondary),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final msg = state.messages[index];
                      return _buildMessageBubble(msg);
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Écrivez un message en temps réel...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: AppTheme.primaryColor),
                    onPressed: _send,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage msg) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          msg.text,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}
