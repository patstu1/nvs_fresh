import 'dart:math';
import 'package:flutter/material.dart';
import 'package:nvs/theme/nvs_theme.dart';
import 'package:nvs/features/connect/presentation/widgets/match_card.dart';

class ConnectScreen extends StatefulWidget {
  const ConnectScreen({super.key});
  @override
  State<ConnectScreen> createState() => _ConnectScreenState();
}

class _ConnectScreenState extends State<ConnectScreen> {
  final ScrollController _scroll = ScrollController();
  final List<_Person> _items = <_Person>[];
  bool _isLoading = false;
  bool _listMode = false; // toggle list/grid

  @override
  void initState() {
    super.initState();
    _loadMore(); // initial
    _scroll.addListener(() {
      if (_scroll.position.pixels > _scroll.position.maxScrollExtent - 600) {
        _loadMore();
      }
    });
  }

  Future<void> _loadMore() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    // TODO: replace with your backend page call (after, set _isLoading=false)
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final Random rnd = Random();
    final int start = _items.length;
    for (int i = start; i < start + 20; i++) {
      _items.add(_Person(
        name: <String>['JAX', 'REI', 'NIKO', 'LUCA', 'ZEN', 'KAI', 'ORION', 'RHYS'][rnd.nextInt(8)],
        age: 22 + rnd.nextInt(16),
        score: .55 + rnd.nextDouble() * .45,
        metrics: <MetricBar>[
          MetricBar(label: 'INTENSITY', value: rnd.nextDouble(), gradient: const <Color>[Color(0xFF8AFFE9), Color(0xFF35F9C8)]),
          MetricBar(label: 'ALIGNMENT', value: rnd.nextDouble(), gradient: const <Color>[Color(0xFFFFE27A), Color(0xFFFFB86B)]),
          MetricBar(label: 'RHYTHM', value: rnd.nextDouble(), gradient: const <Color>[Color(0xFFFF719E), Color(0xFFFF5A7A)]),
        ],
      ),);
    }

    setState(() => _isLoading = false);
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color bg = NvsColors.bg;
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        elevation: 0,
        title: const Text('CONNECT', style: TextStyle(letterSpacing: 2)),
        actions: <Widget>[
          IconButton(
            tooltip: 'TOGGLE VIEW',
            onPressed: () => setState(() => _listMode = !_listMode),
            icon: Icon(_listMode ? Icons.grid_view_rounded : Icons.view_agenda_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: NvsColors.mint,
        backgroundColor: NvsColors.panel,
        onRefresh: () async {
          _items.clear();
          await _loadMore();
        },
        child: _listMode ? _buildList() : _buildGrid(),
      ),
    );
  }

  Widget _buildGrid() {
    return GridView.builder(
      controller: _scroll,
      padding: const EdgeInsets.all(12),
      itemCount: _items.length + 1,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1, // one-wide cyber card columns (feel premium)
        childAspectRatio: 1.95,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, int i) {
        if (i >= _items.length) return _tailLoader();
        final _Person p = _items[i];
        return MatchCard(name: p.name, age: p.age, score: p.score, metrics: p.metrics, onMessage: () {}, onPin: () {});
      },
    );
  }

  Widget _buildList() {
    return ListView.separated(
      controller: _scroll,
      padding: const EdgeInsets.all(12),
      itemCount: _items.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, int i) {
        if (i >= _items.length) return _tailLoader();
        final _Person p = _items[i];
        return MatchCard(name: p.name, age: p.age, score: p.score, metrics: p.metrics, onMessage: () {}, onPin: () {});
      },
    );
  }

  Widget _tailLoader() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(child: _isLoading ? const CircularProgressIndicator(strokeWidth: 2, color: NvsColors.mint) : const SizedBox.shrink()),
      );
}

class _Person {
  _Person({required this.name, required this.age, required this.score, required this.metrics});
  final String name;
  final int age;
  final double score;
  final List<MetricBar> metrics;
}

