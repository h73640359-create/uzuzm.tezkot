import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/state_views.dart';
import '../../data/models/address.dart';
import '../../providers/user_provider.dart';

class AddressesScreen extends ConsumerWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(addressesProvider);
    final notifier = ref.read(addressesProvider.notifier);
    final c = context.colors;
    return Scaffold(
      appBar: AppBar(title: const Text('Manzillarim')),
      body: list.isEmpty
          ? const EmptyView(
              icon: Icons.location_off_outlined,
              title: "Manzil qo'shilmagan",
              subtitle: "Yetkazib berish uchun manzil qo'shing",
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: list.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) {
                final a = list[i];
                return Container(
                  padding: const EdgeInsets.fromLTRB(14, 14, 6, 14),
                  decoration: BoxDecoration(
                    color: c.surface,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: a.isDefault ? AppColors.primary : Colors.transparent, width: 1.4),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        a.title.toLowerCase() == 'ish' ? Icons.work_outline_rounded : Icons.home_outlined,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(a.title, style: context.text.titleSmall),
                                if (a.isDefault) ...[
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: const Text('Asosiy', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.w800)),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(a.full, style: context.text.bodySmall),
                          ],
                        ),
                      ),
                      PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert_rounded, color: c.textSecondary),
                        onSelected: (v) async {
                          switch (v) {
                            case 'default':
                              notifier.setDefault(a.id);
                            case 'edit':
                              final edited = await showAddressEditor(context, existing: a);
                              if (edited != null) notifier.update(edited);
                            case 'delete':
                              notifier.remove(a.id);
                          }
                        },
                        itemBuilder: (_) => [
                          if (!a.isDefault) const PopupMenuItem(value: 'default', child: Text('Asosiy qilish')),
                          const PopupMenuItem(value: 'edit', child: Text('Tahrirlash')),
                          const PopupMenuItem(value: 'delete', child: Text("O'chirish", style: TextStyle(color: AppColors.danger))),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: AppButton(
            label: "Yangi manzil qo'shish",
            icon: Icons.add_location_alt_outlined,
            onPressed: () async {
              final a = await showAddressEditor(context);
              if (a != null) notifier.add(a);
            },
          ),
        ),
      ),
    );
  }
}

/// Manzil qo'shish/tahrirlash bottom sheet.
Future<Address?> showAddressEditor(BuildContext context, {Address? existing}) {
  return showModalBottomSheet<Address>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => _AddressEditor(existing: existing),
  );
}

class _AddressEditor extends StatefulWidget {
  const _AddressEditor({this.existing});
  final Address? existing;

  @override
  State<_AddressEditor> createState() => _AddressEditorState();
}

class _AddressEditorState extends State<_AddressEditor> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(text: widget.existing?.title ?? '');
  late final _city = TextEditingController(text: widget.existing?.city ?? 'Toshkent');
  late final _street = TextEditingController(text: widget.existing?.street ?? '');
  late final _details = TextEditingController(text: widget.existing?.details ?? '');
  late bool _default = widget.existing?.isDefault ?? false;

  static const _cities = ['Toshkent', 'Samarqand', 'Buxoro', 'Andijon', 'Namangan', "Farg'ona", 'Nukus', 'Qarshi', 'Termiz', 'Urganch', 'Jizzax', 'Navoiy', 'Guliston'];

  @override
  void dispose() {
    _title.dispose();
    _city.dispose();
    _street.dispose();
    _details.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_form.currentState?.validate() ?? false)) return;
    final a = Address(
      id: widget.existing?.id ?? 'a${DateTime.now().millisecondsSinceEpoch}',
      title: _title.text.trim(),
      city: _city.text.trim(),
      street: _street.text.trim(),
      details: _details.text.trim(),
      isDefault: _default,
    );
    Navigator.of(context).pop(a);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Form(
        key: _form,
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          children: [
            Text(widget.existing == null ? 'Yangi manzil' : 'Manzilni tahrirlash', style: context.text.titleLarge),
            const SizedBox(height: 14),
            Wrap(
              spacing: 8,
              children: [
                for (final t in const ['Uy', 'Ish', 'Boshqa'])
                  ChoiceChip(
                    label: Text(t),
                    selected: _title.text == t,
                    labelStyle: context.text.labelMedium?.copyWith(color: _title.text == t ? Colors.white : context.colors.text),
                    onSelected: (_) => setState(() => _title.text = t),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _title,
              decoration: const InputDecoration(hintText: 'Nomi (Uy, Ish...)'),
              validator: (v) => (v ?? '').trim().isEmpty ? 'Nom kiriting' : null,
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              initialValue: _cities.contains(_city.text) ? _city.text : _cities.first,
              decoration: const InputDecoration(),
              items: [for (final c in _cities) DropdownMenuItem(value: c, child: Text(c))],
              onChanged: (v) => _city.text = v ?? 'Toshkent',
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _street,
              decoration: const InputDecoration(hintText: "Ko'cha, uy"),
              validator: (v) => (v ?? '').trim().length < 3 ? "Ko'cha va uyni kiriting" : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _details,
              decoration: const InputDecoration(hintText: 'Podyezd, qavat, xonadon (ixtiyoriy)'),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Asosiy manzil qilish'),
              value: _default,
              onChanged: (v) => setState(() => _default = v),
            ),
            const SizedBox(height: 6),
            AppButton(label: 'Saqlash', onPressed: _save),
          ],
        ),
      ),
    );
  }
}
