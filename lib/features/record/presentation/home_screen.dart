import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../domain/record.dart';
import 'add_record_sheet.dart';
import 'record_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(recordListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Myapp'),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: allAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (all) {
          final today = _todayRecords(all);
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _SummaryCard(records: today)),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('오늘 기록', style: Theme.of(context).textTheme.titleMedium),
                      if (today.length > 5)
                        TextButton(
                          onPressed: () {},
                          child: const Text('더보기 →'),
                        ),
                    ],
                  ),
                ),
              ),
              today.isEmpty
                  ? const SliverFillRemaining(child: _EmptyState())
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (ctx, i) => _RecordTile(
                          record: today[i],
                          onEdit: () => showAddRecordSheet(ctx, editing: today[i]),
                          onDelete: () => ref.read(recordListProvider.notifier).remove(today[i].id!),
                        ),
                        childCount: today.length,
                      ),
                    ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddRecordSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Record> _todayRecords(List<Record> all) {
    final now = DateTime.now();
    return all.where((r) {
      return r.recordedAt.year == now.year &&
          r.recordedAt.month == now.month &&
          r.recordedAt.day == now.day;
    }).toList();
  }
}

class _SummaryCard extends StatelessWidget {
  final List<Record> records;
  const _SummaryCard({required this.records});

  @override
  Widget build(BuildContext context) {
    final totalSpend = records
        .where((r) => r.category == '지출')
        .fold<int>(0, (sum, r) => sum + (int.tryParse(r.value) ?? 0));

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('yyyy년 M월 d일', 'ko').format(DateTime.now()),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '기록 ${records.length}건',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              if (totalSpend > 0)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('오늘 지출', style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 4),
                    Text(
                      '${NumberFormat('#,###').format(totalSpend)}원',
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RecordTile extends StatelessWidget {
  final Record record;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _RecordTile({required this.record, required this.onEdit, required this.onDelete});

  String get _emoji =>
      kCategories.firstWhere((c) => c.name == record.category, orElse: () => kCategories.last).emoji;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(_emoji, style: const TextStyle(fontSize: 24)),
      title: Text(record.category),
      subtitle: Text(
        record.category == '지출'
            ? '${NumberFormat('#,###').format(int.tryParse(record.value) ?? 0)}원'
            : record.value,
      ),
      trailing: Text(
        DateFormat('HH:mm').format(record.recordedAt),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onLongPress: () => _showOptions(context),
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('수정'),
              onTap: () {
                Navigator.pop(context);
                onEdit();
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('삭제', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                onDelete();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.edit_note_outlined, size: 64, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          Text('첫 기록을 남겨보세요', style: Theme.of(context).textTheme.bodyLarge),
          const SizedBox(height: 8),
          Text(
            '+ 버튼을 눌러 시작하세요',
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: Theme.of(context).colorScheme.outline),
          ),
        ],
      ),
    );
  }
}
