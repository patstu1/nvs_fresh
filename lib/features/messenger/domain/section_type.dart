import 'package:nvs/features/messages/domain/models/message.dart' show ChatContextType;

enum SectionType {
  live,
  grid,
  now,
  connect,
}

extension SectionTypeX on SectionType {
  String get label {
    switch (this) {
      case SectionType.live:
        return 'LIVE';
      case SectionType.grid:
        return 'MEATUP';
      case SectionType.now:
        return 'NOW';
      case SectionType.connect:
        return 'CONNECT';
    }
  }

  ChatContextType get context {
    switch (this) {
      case SectionType.live:
        return ChatContextType.live;
      case SectionType.grid:
        return ChatContextType.grid;
      case SectionType.now:
        return ChatContextType.now;
      case SectionType.connect:
        return ChatContextType.connect;
    }
  }
}
