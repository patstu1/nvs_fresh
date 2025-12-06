import 'package:flutter/material.dart';

/// Room theme enumeration for live video rooms
enum RoomTheme {
  cyberpunkRave,
  cyberpunkNoir,
  midnightClub,
  chillLoft,
  digitalGarden,
  neonNoir,
  cosmicVoid,
  urbanSunset,
  techLounge,
}

/// Sentiment type enumeration for room atmosphere
enum SentimentType {
  energetic,
  relaxed,
  social,
  tense,
  chill,
  mysterious,
  playful,
}

/// Theme configuration and metadata
class ThemeConfig {

  const ThemeConfig({
    required this.theme,
    required this.name,
    required this.description,
    required this.primaryColor,
    required this.secondaryColor,
    required this.accentColor,
    this.isPremium = false,
  });
  final RoomTheme theme;
  final String name;
  final String description;
  final Color primaryColor;
  final Color secondaryColor;
  final Color accentColor;
  final bool isPremium;

  // Get theme configuration
  ThemeConfig getTheme() {
    return _configs[this] ?? _configs[RoomTheme.cyberpunkRave]!;
  }

  static const Map<RoomTheme, ThemeConfig> _configs = <RoomTheme, ThemeConfig>{
    RoomTheme.cyberpunkRave: ThemeConfig(
      theme: RoomTheme.cyberpunkRave,
      name: 'Cyberpunk Rave',
      description: 'High-energy neon vibes',
      primaryColor: Color(0xFF00FF88),
      secondaryColor: Color(0xFFFF0080),
      accentColor: Color(0xFF00FFAA),
    ),
    RoomTheme.cyberpunkNoir: ThemeConfig(
      theme: RoomTheme.cyberpunkNoir,
      name: 'Cyberpunk Noir',
      description: 'Dark futuristic atmosphere',
      primaryColor: Color(0xFF4BEFE0),
      secondaryColor: Color(0xFF1A1A1A),
      accentColor: Color(0xFF8A2BE2),
    ),
    RoomTheme.midnightClub: ThemeConfig(
      theme: RoomTheme.midnightClub,
      name: 'Midnight Club',
      description: 'Underground club vibes',
      primaryColor: Color(0xFF9933FF),
      secondaryColor: Color(0xFF330066),
      accentColor: Color(0xFFFF6B6B),
    ),
    RoomTheme.chillLoft: ThemeConfig(
      theme: RoomTheme.chillLoft,
      name: 'Chill Loft',
      description: 'Relaxed ambient atmosphere',
      primaryColor: Color(0xFF66FF99),
      secondaryColor: Color(0xFF003311),
      accentColor: Color(0xFFFFE66D),
    ),
    RoomTheme.digitalGarden: ThemeConfig(
      theme: RoomTheme.digitalGarden,
      name: 'Digital Garden',
      description: 'Nature meets technology',
      primaryColor: Color(0xFF00FF66),
      secondaryColor: Color(0xFF004422),
      accentColor: Color(0xFF81C784),
    ),
    RoomTheme.neonNoir: ThemeConfig(
      theme: RoomTheme.neonNoir,
      name: 'Neon Noir',
      description: 'Mystery meets neon',
      primaryColor: Color(0xFFFF6600),
      secondaryColor: Color(0xFF221100),
      accentColor: Color(0xFFFFB74D),
    ),
    RoomTheme.cosmicVoid: ThemeConfig(
      theme: RoomTheme.cosmicVoid,
      name: 'Cosmic Void',
      description: 'Deep space atmosphere',
      primaryColor: Color(0xFF6600FF),
      secondaryColor: Color(0xFF110022),
      accentColor: Color(0xFF9C27B0),
    ),
    RoomTheme.urbanSunset: ThemeConfig(
      theme: RoomTheme.urbanSunset,
      name: 'Urban Sunset',
      description: 'City meets twilight',
      primaryColor: Color(0xFFFF9900),
      secondaryColor: Color(0xFF663300),
      accentColor: Color(0xFFFF5722),
    ),
    RoomTheme.techLounge: ThemeConfig(
      theme: RoomTheme.techLounge,
      name: 'Tech Lounge',
      description: 'Professional tech vibes',
      primaryColor: Color(0xFF0099FF),
      secondaryColor: Color(0xFF003366),
      accentColor: Color(0xFF2196F3),
    ),
  };

  static Map<RoomTheme, ThemeConfig> getAllThemes() => _configs;

  static ThemeConfig? getConfig(RoomTheme theme) => _configs[theme];
}
