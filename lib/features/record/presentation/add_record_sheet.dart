import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/record.dart';
import 'record_provider.dart';

Future<void> showAddRecordSheet(BuildContext context, {Record? editing}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (_) => _AddRecordSheet(editing: editing),
  );
}

class _AddRecordSheet extends ConsumerStatefulWidget {
  final Record? editing;
  const _AddRecordSheet({this.editing});

  @override
  ConsumerState<_AddRecordSheet> createState() => _AddRecordSheetState();
}

class _AddRecordSheetState extends ConsumerState<_AddRecordSheet> {
  late RecordCategory _selected;
  late final TextEditingController _valueCtrl;
  final _formKey = GlobalKey<FormState>();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _selected = widget.editing != null
        ? kCategories.firstWhere((c) => c.name == widget.editing!.category,
            orElse: () => kCategories.first)
        : kCategories.first;
    _valueCtrl = TextEditingController(text: widget.editing?.value ?? '');
  }

  @override
  void dispose() {
    _valueCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final notifier = ref.read(recordListProvider.notifier);
    final record = Record(
      id: widget.editing?.id,
      category: _selected.name,
      value: _valueCtrl.text.trim(),
      recordedAt: widget.editing?.recordedAt ?? DateTime.now(),
      source: widget.editing?.source ?? 'manual',
    );

    if (widget.editing != null) {
      await notifier.edit(record);
      if (mounted) Navigator.pop(context);
    } else {
      final id = await notifier.add(record);
      if (!mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('기록됐어요 ✓'),
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: '취소',
            onPressed: () => ref.read(recordListProvider.notifier).remove(id),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + bottom),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.editing != null ? '기록 수정' : '새 기록',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            _CategoryGrid(
              selected: _selected,
              onSelect: (c) => setState(() {
                _selected = c;
                _valueCtrl.clear();
              }),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _valueCtrl,
              autofocus: true,
              keyboardType: _selected.isNumeric ? TextInputType.number : TextInputType.text,
              inputFormatters: _selected.isNumeric
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              decoration: InputDecoration(
                labelText: _selected.isNumeric ? '금액 (원)' : '내용',
                border: const OutlineInputBorder(),
                suffixText: _selected.isNumeric ? '원' : null,
              ),
              validator: (v) => (v == null || v.trim().isEmpty) ? '값을 입력해주세요' : null,
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: _saving ? null : _save,
                child: _saving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(widget.editing != null ? '수정 완료' : '저장'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryGrid extends StatelessWidget {
  final RecordCategory selected;
  final ValueChanged<RecordCategory> onSelect;

  const _CategoryGrid({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kCategories.map((c) {
        final isSelected = c.name == selected.name;
        return ChoiceChip(
          label: Text('${c.emoji} ${c.name}'),
          selected: isSelected,
          onSelected: (_) => onSelect(c),
        );
      }).toList(),
    );
  }
}
