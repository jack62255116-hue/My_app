import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/record_dao.dart';
import '../domain/record.dart';

final recordDaoProvider = Provider((_) => RecordDao());

final recordListProvider =
    AsyncNotifierProvider<RecordListNotifier, List<Record>>(RecordListNotifier.new);

class RecordListNotifier extends AsyncNotifier<List<Record>> {
  @override
  Future<List<Record>> build() => ref.read(recordDaoProvider).getAll();

  Future<int> add(Record record) async {
    final id = await ref.read(recordDaoProvider).insert(record);
    ref.invalidateSelf();
    return id;
  }

  Future<void> remove(int id) async {
    await ref.read(recordDaoProvider).delete(id);
    ref.invalidateSelf();
  }

  Future<void> edit(Record record) async {
    await ref.read(recordDaoProvider).update(record);
    ref.invalidateSelf();
  }
}
