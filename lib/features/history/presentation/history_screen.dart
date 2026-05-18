import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../record/domain/record.dart';
import '../../record/presentation/add_record_sheet.dart';
import '../../record/presentation/record_provider.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allAsync = ref.watch(recordListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('기록 전체')),
      body: allAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('오류: $e')),
        data: (all) {
          if (all.isEmpty) {
            return const Center(child: Text('기록이 없습니다'));
          }
          final grouped = _groupByDate(all);
          final dates = grouped.keys.toList();
          return ListView.builder(
            itemCount: dates.length,
            itemBuilder: (ctx, i) {
              final date = dates[i];
              final records = grouped[date]!;
              return _DateGroup(
                date: date,
                records: records,
                onEdit: (r) => showAddRecordSheet(ctx, editing: r),
                onDelete: (r) => ref.read(recordListProvider.notifier).remove(r.id!),
              );
            },
          );
        },
      ),
    );
  }

  Map<String, List<Record>> _groupByDate(List<Record> records) {
    final map = <String, List<Record>>{};
    for (final r in records) {
      final key = DateFormat('yyyy-MM-dd').format(r.recordedAt);
      map.putIfAbsent(key, () => []).add(r);
    }
    return map;
  }
}

class _DateGroup extends StatelessWidget {
  final String date;
  final List<Record> records;
  final void Function(Record) onEdit;
  final void Function(Record) onDelete;

  const _DateGroup({
    required this.date,
    required this.records,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(String date) {
    final d = DateTime.parse(date);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(d.year, d.month, d.day);
    final diff = today.difference(target).inDays;
    if (diff == 0) return '오늘';
    if (diff == 1) return '어제';
    return DateFormat('M월 d일 (E)', 'ko').format(d);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            _formatDate(date),
            style: Theme.of(context)
                .textTheme
                .labelLarge
                ?.copyWith(color: Theme.of(context).colorScheme.primary),
          ),
        ),
        ...records.map((r) => _RecordTile(
              record: r,
              onEdit: () => onEdit(r),
              onDelete: () => onDelete(r),
            )),
        const Divider(height: 1),
      ],
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
      leading: Text(_emoji, style: const TextStyle(fontSize: 22)),
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
