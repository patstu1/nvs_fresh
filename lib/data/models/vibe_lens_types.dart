// packages/grid/lib/data/models/vibe_lens_types.dart

/// Enum for VibeLens filter types
enum VibeLensType { nearby, trending, newFaces, nomads, refine }

/// Extension for VibeLens display names
extension VibeLensTypeExtension on VibeLensType {
  String get displayName {
    switch (this) {
      case VibeLensType.nearby:
        return 'Nearby';
      case VibeLensType.trending:
        return 'Trending';
      case VibeLensType.newFaces:
        return 'New Faces';
      case VibeLensType.nomads:
        return 'Nomads';
      case VibeLensType.refine:
        return 'Refine';
    }
  }
}

/// Input class for refine details
class RefineDetailsInput {
  final List<String>? position;
  final List<String>? bodyType;
  final int? minAge;
  final int? maxAge;
  final double? maxDistance;

  const RefineDetailsInput({
    this.position,
    this.bodyType,
    this.minAge,
    this.maxAge,
    this.maxDistance,
  });

  Map<String, dynamic> toJson() {
    return {
      if (position != null) 'position': position,
      if (bodyType != null) 'bodyType': bodyType,
      if (minAge != null) 'minAge': minAge,
      if (maxAge != null) 'maxAge': maxAge,
      if (maxDistance != null) 'maxDistance': maxDistance,
    };
  }
}








