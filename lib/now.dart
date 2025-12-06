// Now package exports
library;

// Now presentation layer - widgets (simplified exports to avoid missing dependencies)
// export 'presentation/widgets/data_scape_view.dart'; // Has mapbox dependencies - DISABLED
export 'presentation/widgets/presence_marker.dart';
export 'presentation/widgets/now_hud.dart';
export 'presentation/widgets/globe_intro.dart';
export 'presentation/widgets/spinning_earth_widget.dart';
export 'presentation/widgets/cyberpunk_3d_globe.dart';
export 'presentation/widgets/cluster_widget.dart';
// export 'presentation/widgets/user_cluster_avatar.dart'; // Has MockUser dependency
export 'presentation/widgets/user_avatar_widget.dart';
export 'presentation/widgets/ephemeral_chat.dart';
export 'presentation/widgets/cruising_feed.dart';
export 'presentation/widgets/filter_button.dart';
export 'presentation/widgets/now_user_bubble.dart';
export 'presentation/widgets/user_profile_drawer.dart';
export 'presentation/widgets/map_filters_panel.dart';

// Now pages and views
export 'presentation/pages/now_spinning_earth_view.dart';
export 'presentation/views/now_view.dart';
// export 'presentation/pages/now_main_view.dart'; // Conflicts with now_view.dart NowViewWidget
// export 'presentation/pages/enhanced_now_view.dart'; // Has missing model dependencies
// export 'presentation/pages/simple_now_view.dart'; // Has MockUser dependencies
// export 'presentation/views/data_scape_view.dart'; // THE LIVING CITY
