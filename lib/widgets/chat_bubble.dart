import 'package:flutter/material.dart';

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final String? mentorName;
  final String? mentorImage;

  const ChatBubble({
    super.key,
    required this.text,
    required this.isUser,
    this.mentorName,
    this.mentorImage,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft, // 사용자(오른쪽) / 멘토(왼쪽)
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          mainAxisAlignment:
          isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!isUser && mentorImage != null) ...[
              CircleAvatar(
                radius: 20,
                backgroundImage: AssetImage(mentorImage!),
              ),
              const SizedBox(width: 8),
            ],
            Column(
              crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isUser && mentorName != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 5, bottom: 3),
                    child: Text(
                      mentorName!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Container(
                  margin: const EdgeInsets.only(top: 5),
                  padding: const EdgeInsets.all(12),
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  decoration: BoxDecoration(
                    color: isUser ? Colors.green : Colors.grey.shade200,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(15),
                      topRight: const Radius.circular(15),
                      bottomLeft: isUser ? const Radius.circular(15) : Radius.zero,
                      bottomRight: isUser ? Radius.zero : const Radius.circular(15),
                    ),
                  ),
                  child: Text(
                    text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
