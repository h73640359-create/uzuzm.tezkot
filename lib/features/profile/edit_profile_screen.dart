import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/theme/app_theme.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_snackbar.dart';
import '../../providers/user_provider.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: ref.read(userProvider).name);
  late final _phone = TextEditingController(text: Formatters.phone(ref.read(userProvider).phone));
  late final _email = TextEditingController(text: ref.read(userProvider).email);
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    await ref.read(userProvider.notifier).update(
          name: _name.text.trim(),
          phone: '+${_phone.text.replaceAll(RegExp(r'\D'), '')}',
          email: _email.text.trim(),
        );
    if (!mounted) return;
    showAppSnackBar(context, 'Profil saqlandi');
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profilni tahrirlash')),
      body: Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _label('Ism-familiya'),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(hintText: 'Ismingiz', prefixIcon: Icon(Icons.person_outline_rounded)),
              validator: (v) => (v ?? '').trim().length < 2 ? 'Ism kiriting' : null,
            ),
            const SizedBox(height: 16),
            _label('Telefon'),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(hintText: '+998 90 123 45 67', prefixIcon: Icon(Icons.phone_outlined)),
              validator: (v) {
                final d = (v ?? '').replaceAll(RegExp(r'\D'), '');
                return d.length == 12 && d.startsWith('998') ? null : "To'g'ri raqam kiriting";
              },
            ),
            const SizedBox(height: 16),
            _label('Email'),
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(hintText: 'email@misol.uz', prefixIcon: Icon(Icons.mail_outline_rounded)),
              validator: (v) => RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch((v ?? '').trim()) ? null : "To'g'ri email kiriting",
            ),
            const SizedBox(height: 28),
            AppButton(label: 'Saqlash', loading: _saving, onPressed: _save),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 2),
        child: Text(t, style: context.text.labelMedium),
      );
}
