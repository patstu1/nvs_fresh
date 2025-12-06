import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/user_model.dart';
import '../../../services/mock_user_service.dart';

class GridViewWidget extends ConsumerWidget {
  const GridViewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(mockUserServiceProvider).getMockUsers();

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: users.length,
        itemBuilder: (BuildContext context, int index) {
          final user = users[index];
          return Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1B1B1B),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFA7FFE0).withOpacity(0.6),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '${user.matchPercent}%',
                      style: const TextStyle(
                        color: Color(0xFFA7FFE0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Icon(
                      Icons.favorite_border,
                      color: Colors.white38,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const CircleAvatar(radius: 28, backgroundColor: Colors.white12),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      '${user.displayName}, ${user.age}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    if (user.online)
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: const BoxDecoration(
                            color: Colors.greenAccent,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user.username,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB0FF5A),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    user.role,
                    style: const TextStyle(color: Colors.black, fontSize: 10),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
