/// Icebreaker game types for live video rooms
enum IcebreakerType {
  quickQuestion,
  wouldYouRather,
  truthOrDare,
  rolePlay,
  storyBuilding,
  rapidFire,
  wordAssociation,
  trivia,
  question,
  poll,
}

/// Game type alias for compatibility
typedef GameType = IcebreakerType;

/// Icebreaker game data model
class IcebreakerGame {
  const IcebreakerGame({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    this.prompt = '',
    this.prompts = const <String>[],
    this.options = const <String>[],
    this.duration = const Duration(seconds: 60),
    this.settings = const <String, dynamic>{},
    this.timeLimit = 60,
    this.minParticipants = 2,
    this.maxParticipants = 10,
    this.isAdultOnly = false,
    this.tags = const <String>[],
    this.metadata = const <String, dynamic>{},
  });

  factory IcebreakerGame.create({
    required String id,
    required IcebreakerType type,
    required String title,
    required String description,
    required List<String> prompts,
    String prompt = '',
    int timeLimit = 60,
    int minParticipants = 2,
    int maxParticipants = 10,
    bool isAdultOnly = false,
    List<String> tags = const <String>[],
    Map<String, dynamic> metadata = const <String, dynamic>{},
  }) {
    return IcebreakerGame(
      id: id,
      type: type,
      title: title,
      description: description,
      prompt: prompt,
      prompts: prompts,
      timeLimit: timeLimit,
      minParticipants: minParticipants,
      maxParticipants: maxParticipants,
      isAdultOnly: isAdultOnly,
      tags: tags,
      metadata: metadata,
    );
  }
  final String id;
  final IcebreakerType type;
  final String title;
  final String description;
  final String prompt; // Single prompt for backwards compatibility
  final List<String> prompts;
  final List<String> options; // For games with choices
  final Duration duration; // Duration object for compatibility
  final Map<String, dynamic> settings; // Game settings
  final int timeLimit; // in seconds
  final int minParticipants;
  final int maxParticipants;
  final bool isAdultOnly;
  final List<String> tags;
  final Map<String, dynamic> metadata;

  // Copy with method
  IcebreakerGame copyWith({
    String? id,
    IcebreakerType? type,
    String? title,
    String? description,
    List<String>? prompts,
    int? timeLimit,
    int? minParticipants,
    int? maxParticipants,
    bool? isAdultOnly,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    return IcebreakerGame.create(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      description: description ?? this.description,
      prompts: prompts ?? this.prompts,
      timeLimit: timeLimit ?? this.timeLimit,
      minParticipants: minParticipants ?? this.minParticipants,
      maxParticipants: maxParticipants ?? this.maxParticipants,
      isAdultOnly: isAdultOnly ?? this.isAdultOnly,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
    );
  }

  // Get random prompt
  String get randomPrompt {
    if (prompts.isEmpty) return 'Tell us something interesting about yourself!';
    final int random = DateTime.now().millisecondsSinceEpoch % prompts.length;
    return prompts[random];
  }

  @override
  String toString() => 'IcebreakerGame(id: $id, title: $title, type: $type)';
}
