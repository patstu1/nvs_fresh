import 'package:flutter/material.dart';
import 'package:nvs/meatup_core.dart';
import '../../../../shared/widgets/nvs_logo_app_bar.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/search_provider.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    ref.read(searchQueryProvider.notifier).state = query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NVSColors.pureBlack,
      appBar: const NvsLogoAppBar(),
      body: Column(
        children: <Widget>[
          _buildSearchBar(),
          _buildResults(),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final bool isLoading = ref.watch(searchResultsProvider).isLoading;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        onChanged: _performSearch,
        style: const TextStyle(color: NVSColors.ultraLightMint),
        decoration: InputDecoration(
          hintText: 'Search users + role + emoji tags 🐷🍆🧠💦...',
          prefixIcon: const Icon(Icons.search, color: NVSColors.neonMint),
          suffixIcon: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(12.0),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: NVSColors.neonMint,
                  ),
                )
              : null,
        ),
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildResults() {
    final AsyncValue<List<UserProfile>> asyncResults = ref.watch(searchResultsProvider);

    if (_searchController.text.isEmpty) {
      return Expanded(
        child: Center(
          child: Text(
            'Search the network',
            style: NvsTextStyles.heading.copyWith(color: NVSColors.secondaryText),
          ).animate().fadeIn(delay: 200.ms),
        ),
      );
    }

    return Expanded(
      child: asyncResults.when(
        data: (List<UserProfile> results) => ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: results.length,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(color: NVSColors.dividerColor, height: 1),
          itemBuilder: (BuildContext context, int index) {
            final UserProfile result = results[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(result.photoURL ?? ''),
              ),
              title: Text(
                result.displayName,
                style: const TextStyle(color: NVSColors.ultraLightMint),
              ),
              onTap: () {},
            ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.2);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (Object error, StackTrace stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
